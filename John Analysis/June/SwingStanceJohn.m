%% Plot sinusoidal timeseries of egocentric paw distance from centroid

% ASD_all, phenos, or Cntnap2_all
pORa = Cntnap2_all; 
% Het(1), Homo(2), or Neg(3)
phe = 3;
% Make sure using correct phenotype
disp(length(pORa{1,phe}(1,:)))

an = 3; day = 1; 
allPaws = permute( correctedTens5{pORa{phe}(1,an),day}([5,6,9,10], : , :), [2 1 3]);
% RTfront = squeeze(allPaws(2,1,:));
% LFrear = squeeze(allPaws(2,4,:));
% paws = [ RTfront, LFrear ];
LFfront = squeeze(allPaws(2,2,:));
RTrear = squeeze(allPaws(2,3,:));
paws = [ LFfront, RTrear ];

% Cross correlation between limbs
slot = (1:length(paws));
[c, lags] = xcorr(paws(slot,1), paws(slot,2));
c = c/max(c);
[m,i] = max(c);
t = lags(i);
% Usually comment this out
% stem(lags,c)

%%%%%%%%%%%%%%%%%% Calculate animal speed %%%%%%%%%%%%%%%%%%
% Get change in x-coordinate per frame (negative just means a change to the left):
vx = gradient(centroidsF2(:,1));
% Get the change in y-coordinate per frame:
vy = gradient(centroidsF2(:,2));
% velocity :
vel = ((sqrt(vx.^2 + vy.^2)));
vel = fillmissing(vel,'linear');
vel = movmedian(vel,Fs/2);
% from pixels per frame to 
%          mm per second
velTscHet = vel * 80 * .51 / 1000;
clear vel vx vy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(7)
label1 = 'Cross Correlation Lag: %d Frame(s)';
str = sprintf(label1, t);
annotation('textbox',[.58 .8 .1 .1],'string',str)
colors={'r','b'};
% Plot speed
plot(vel(slot)*10)
% Plot paw 
for n=1:2 
    plot(zscore(paws(slot,n)),'color',colors{n}); 
    %     plot(paws(:,n),'color',colors{n}); 
    lgd = legend('Right Forepaw', 'Left Hindpaw', 'location', 'NorthWest');
    lgd.FontSize = 14;
    title('CntNapHet Stride Correlation ')
    xlabel('Frame')
    ylabel('Paw Distance from Centroid')
%     ylim([-3 3])
    hold on; 
%     [stance_pts{n}, swing_pts{n}] = peakdet(paws(:,n), 3);% if including index on x
%     plot(stance_pts{n}(:,1),stance_pts{n}(:,2),'mo')
%     plot(swing_pts{n}(:,1),swing_pts{n}(:,2),'gs'); hold on;
end



%% Prepare data of particular animal to create video

% ASD_all, phenos, or Cntnap2_all
pORa = Cntnap2_all;
% Het(1), Homo(2), or Neg(3)
phe = 1;
% Make sure using correct phenotype
disp(length(pORa{1,phe}(1,:)))

an = 1; day = 1;
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


%% Show video of four paws in real space
v = VideoWriter('tscHetHIGH.mp4', 'MPEG-4');
v.FrameRate = 10;
open(v);
slot = 1:velTscHet_HIGH(:,1);
% Generate a set of frames, get the frame from the figure, and then write each frame to the file.
for k = slot
    h1 = scatter(ff(1,1,k), ff(1,2,k), 'r'); % this is 5
    hold on;
    h2 = scatter(ff(2,1,k), ff(2,2,k), 'b'); % this is 6
    hold on;
    h3 = scatter(ff(3,1,k), ff(3,2,k), 'b'); % this is 9
    hold on;
    h4 = scatter(ff(4,1,k), ff(4,2,k), 'r'); % this is 10
    
%     legend('Hindpaws','Forepaws', 'Location','NorthWest')
    xlim([0 1000])
    ylim([0 1200])
    frame = getframe(gcf);
    writeVideo(v,frame);
    
    hold off;
    delete(findall(gcf,'Tag','stream'));
    label1 = 'Frame = %d';
    str = sprintf(label1, k);
    annotation('textbox',[.75 .8 .1 .1],'string',str, 'Tag', 'stream')
    drawnow;
end

close(v);





%% Show video of four paws in egocentric space
% 
% % Create a video writer object for the output video file and open the object for writing.
% v = VideoWriter('test.avi');
% open(v);
% 
% % Generate a set of frames, get the frame from the figure, and then write each frame to the file.
% for k = 715 : length(allPaws)
%     h3 = scatter(allPaws(1,3,k), allPaws(2,3,k), 'b');
%     hold on;
%     
%     h1 = scatter(allPaws(1,1,k), allPaws(2,1,k), 'r');
%     hold on;
%     
% %     h2 = scatter(allPaws(1,2,k), allPaws(2,2,k), 'r');
% %     hold on;
% %     
% %     h4 = scatter(allPaws(1,4,k), allPaws(2,4,k), 'b');
%     
%     legend('Hindpaws','Forepaws', 'Location','NorthWest')
%     xlim([100 280])
%     ylim([0 300])
%     frame = getframe(gcf);
%     writeVideo(v,frame);
%     
% %     pause(.05)
%     
%     hold off;
%     delete(findall(gcf,'Tag','stream'));
%     formatspace = 'Frame = %d';
%     str = sprintf(formatspace, k);
%     annotation('textbox',[.75 .8 .1 .1],'string',str, 'Tag', 'stream')
%     drawnow;
% end
% 
% close(v);
