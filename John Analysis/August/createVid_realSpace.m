%% Loop through each bout in permaList and play the videos of the bouts assigned to the cluster

%  Load relevant files
% load('/Users/johnduva/iCloud Drive (Archive) - 1/Desktop/mkislin Files/correctedTens5.mat');
% load('/Users/johnduva/iCloud Drive (Archive) - 1/Desktop/mkislin Files/allTracks.mat');
% load('/Users/johnduva/iCloud Drive (Archive) - 1/Desktop/mkislin Files/keepersOnly.mat');
% load('/Users/johnduva/iCloud Drive (Archive) - 1/Desktop/mkislin Files/filenames.mat') % files_by_day.mat
% load('/Users/johnduva/Git/StrideAnalysis/John Analysis/Mat Files/phenosAll.mat')  % phenos
% load('/Users/johnduva/Git/StrideAnalysis/John Analysis/Mat Files/ASD_all.mat') 
% load('/Users/johnduva/Git/StrideAnalysis/John Analysis/Mat Files/Cntnap2_all.mat')

% Which gait/cluster do we want to aggregate movies of? 
cluster = 3;

% For each bout in permaList, identify if in current cluster; if so, create movie
for bout = 1:length(permaList)
    % if that bout is a 0 lag bout
    if idx(bout)==cluster && mod(bout,4)==0
        % See what the current bout is
        disp(bout);
        disp(permaList(bout, 3:4));
        
        an = permaList(bout,5);
        % phenos, ASD_all, or Cntnap2_all
        pORa = ASD_all;
        % Het(1), Homo(2), or Neg(3)
        phe = 1; day = 1;
        
        allPaws = permute( correctedTens5{pORa{phe}(1,an),day}([5,6,9,10], : , :), [2 1 3]);

        index = 1;
        for frame = 1: length(allTracks{pORa{phe}(1,an),day})
            if ismember(frame, keepersOnly{pORa{phe}(1,an),day}) % && frame == blank + 1
                centroidsF2(index,1) = allTracks{pORa{phe}(1,an),day}(frame,1); 
                centroidsF2(index,2) = allTracks{pORa{phe}(1,an),day}(frame,2);
                index = index + 1;
            end
        end

        % Extract the name of the file by day for the session, and zero pad it
        vid = sprintf('%04d',cell2mat(files_by_day(pORa{phe}(1,an),day)));
        % Load rotVal from proper file
        load(['/Users/johnduva/Desktop/Stride Figures/ASDvids/OFT-', vid, '-00_box_aligned_info.mat'], 'mouseInfo')
        
        %%%%%%%%%%%%%%% Change coordinates to real space %%%%%%%%%%%%%%%%%%
        allPaws2 = permute(allPaws,[2 1 3]);
        tempr = deg2rad(mouseInfo.rotVal);
        tempr = tempr(keepersOnly{pORa{phe}(1,an),day});
        midJoints = double(allPaws2) - 200;
        jx = double(squeeze(midJoints(:,1,:)));
        jy = double(squeeze(midJoints(:,2,:)));
        ff = zeros(size(allPaws2));
        for i = 1:length(jx)
        [jp2j(:,i), jp2i(:,i)] = cart2pol( jx(:,i)', jy(:,i)' );
        tjp(:,i) = jp2j(:,i) + repmat(tempr(i),[4 1]);
        [jp3j(:,i), jp3i(:,i)] = pol2cart(tjp(:,i),jp2i(:,i));
        ogc1(:,i) = jp3j(:,i) + centroidsF2(i,1);
        ogc2(:,i) = jp3i(:,i) + centroidsF2(i,2);
        end
        ff(:,1,:) = ogc1; 
        ff(:,2,:) = ogc2;
        clearvars jp2i jp2j jp3j jp3i jx jy midJoints ogc1 ogc2 tempt tempr tempCents tjp;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Show video of four paws in real space
        boutNum = sprintf('%04d',bout);
        clusterNum = sprintf('%d',cluster);
        
        v = VideoWriter(['tscHet_Gait3_', boutNum, '.mp4'], 'MPEG-4');
        v.FrameRate = 10;
        open(v);
        
        % Generate a set of frames, get the frame from the figure, and then write each frame to the file.
        for k = permaList(bout,3) : permaList(bout,4)
            h1 = scatter(ff(1,1,k), ff(1,2,k), 'r'); % this is 5
            hold on;
            h2 = scatter(ff(2,1,k), ff(2,2,k), 'b'); % this is 6
            hold on;
            h3 = scatter(ff(3,1,k), ff(3,2,k), 'b'); % this is 9
            hold on;
            h4 = scatter(ff(4,1,k), ff(4,2,k), 'r'); % this is 10

            % legend('Hindpaws','Forepaws', 'Location','NorthWest')
            title('TscHet - Gait 3')
            xlim([0 1000])
            ylim([0 1200])
            frame = getframe(gcf);
            writeVideo(v,frame);

            hold off;
            delete(findall(gcf,'Tag','stream'));
            label1 = 'Frame = %d';
            str = sprintf(label1, k);
            annotation('textbox',[.75 .8 .1 .1],'string',str, 'Tag', 'stream')
            
%             delete(findall(gcf,'Tag','stream'));
            label2 = 'Bout Lag = %f';
            str = sprintf(label2, permaList(bout,2));
            annotation('textbox',[.15 .1 .1 .1],'string',str, 'Tag', 'stream')
            drawnow;
        end

        close(v);
        
    end
    
%     if length(dir) >= 20
%         break
%     end
    
end


