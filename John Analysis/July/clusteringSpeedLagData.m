%% Cluster the Speed vs Lag data in permaList

% Set the dataset to 'X'
X = permaList;
clusters = 4;

opts = statset('Display','final');
[idx,C] = kmeans(X(:,1:2),clusters,'Distance','cityblock',...
    'Replicates',5,'Options',opts);

% Note: all rows wherein idx==1 in the first column
% X(idx==1,1)

point_size=5;
test = [0.9290,0.6940, 0.1250];

figure;
plot(X(idx==1,1),X(idx==1,2),'k.','MarkerSize',point_size)
hold on
plot(X(idx==2,1),X(idx==2,2),'b.','MarkerSize',point_size)
hold on
plot(X(idx==3,1),X(idx==3,2),'r.','MarkerSize',point_size)
hold on
plot(X(idx==4,1),X(idx==4,2),'m.','MarkerSize',point_size)
hold on
plot(X(idx==5,1),X(idx==5,2),'g.','MarkerSize',point_size)
hold on
plot(C(:,1),C(:,2),'kx',...
     'Color', 'k','MarkerSize',12,'LineWidth',2) 
legend('Cluster 1','Cluster 2','Cluster 3', 'Cluster 4', 'Centroids',...
       'Location','SE')
title 'Cluster Assignments and Centroids'
% ylim([-2.5 0])
hold off

%% Loop through each bout in permaList and play the videos of the bouts assigned to the cluster

%  Load relevant files
load('/Users/johnduva/iCloud Drive (Archive) - 1/Desktop/mkislin Files/correctedTens5.mat');
load('/Users/johnduva/iCloud Drive (Archive) - 1/Desktop/mkislin Files/allTracks.mat');
load('/Users/johnduva/iCloud Drive (Archive) - 1/Desktop/mkislin Files/keepersOnly.mat');
load('/Users/johnduva/iCloud Drive (Archive) - 1/Desktop/mkislin Files/filenames.mat') % files_by_day.mat

load('/Users/johnduva/Git/StrideAnalysis/John Analysis/Mat Files/phenosAll.mat')  % phenos
load('/Users/johnduva/Git/StrideAnalysis/John Analysis/Mat Files/ASD_all.mat') 
load('/Users/johnduva/Git/StrideAnalysis/John Analysis/Mat Files/Cntnap2_all.mat')

% Which gait/cluster do we want to aggregate movies of? 
cluster = 3;

% For each bout in permaList, identify if in cluster - then create movie if it is
for bout = 1:length(permaList)
    % if that bout is a 0 lag bout
    if idx(bout)==cluster
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

        % Change coordinates to real space
        allPaws2 = permute(allPaws,[2 1 3]);
        tempr = deg2rad(mouseInfo.rotVal);
        tempr = tempr(keepersOnly{pORa{phe}(1,an),day});
        midJoints = double(allPaws2) - 200;

        jx = double(squeeze(midJoints(:,1,:)));
        jy = double(squeeze(midJoints(:,2,:)));
        ff = zeros(point_size(allPaws2));

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

        
        
        
    end
end




    