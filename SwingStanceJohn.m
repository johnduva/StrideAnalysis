%% Plot sinusoidal timeseries of egocentric paw distance from centroid

pORa = phenos; % ASD_all
phe = 1;
an = 1; day = 1;
allPaws = permute( correctedTens5{pORa{phe}(1,an),day}([5,6,9,10], : , :), [2 1 3]);
RTfront = squeeze(allPaws(2,1,:));
LFrear = squeeze(allPaws(2,4,:));

paws = [ RTfront, LFrear ];
clear RT LT

figure(2)
colors={'r','b'};
for n=1:2 
    plot(zscore(paws(:,n)),'color',colors{n}); 
    lgd = legend('Right Forepaw', 'Left Hindpaw', 'location', 'NorthWest');
    lgd.FontSize = 14;
    title('C57 Paw Synchrony')
    xlabel('Frame')
    ylabel('Paw Distance from Centroid')
    hold on; 
%     [stance_pts{n}, swing_pts{n}] = peakdet(paws(:,n), 3);% if including index on x
%     plot(stance_pts{n}(:,1),stance_pts{n}(:,2),'mo')
%     plot(swing_pts{n}(:,1),swing_pts{n}(:,2),'gs'); hold on;
end

%% Show video of four paws in egocentric space

% Create a video writer object for the output video file and open the object for writing.
v = VideoWriter('test.avi');
open(v);

% Generate a set of frames, get the frame from the figure, and then write each frame to the file.
for k = 715 : length(allPaws)
    h3 = scatter(allPaws(1,3,k), allPaws(2,3,k), 'b');
    hold on;
    
    h1 = scatter(allPaws(1,1,k), allPaws(2,1,k), 'r');
    hold on;
    
%     h2 = scatter(allPaws(1,2,k), allPaws(2,2,k), 'r');
%     hold on;
%     
%     h4 = scatter(allPaws(1,4,k), allPaws(2,4,k), 'b');
    
    legend('Hindpaws','Forepaws', 'Location','NorthWest')
    xlim([100 280])
    ylim([0 300])
    frame = getframe(gcf);
    writeVideo(v,frame);
    
%     pause(.05)
    
    hold off;
    delete(findall(gcf,'Tag','stream'));
    formatspace = 'Frame = %d';
    str = sprintf(formatspace, k);
    annotation('textbox',[.75 .8 .1 .1],'string',str, 'Tag', 'stream')
    drawnow;
end

close(v);



%% Prepare data of particular animal to create video
pORa = phenos; % ASD_all
phe = 1;
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
load(['/Users/johnduva/Desktop/C57vids/OFT-', vid, '-00_box_aligned_info.mat'], 'mouseInfo')

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

%% Cross correlation between paws (right-fore vs hind-left)

[c, lags] = xcorr(squeeze(ff(1,1,:)), squeeze(ff(4,1,:)));
% c = c/max(c);

[m,i] = max(c);
t = lags(i);

stem(lags,c)


%% Show video of four paws in real space
% v = VideoWriter('tscHomoSlow.mp4', 'MPEG-4');
v = VideoWriter('DELtscHETSlow.mp4', 'MPEG-4');
v.FrameRate = 10;
open(v);


% Generate a set of frames, get the frame from the figure, and then write each frame to the file.
% for k = 25 : 250 % C57
% for k = 400 : 625 % tscHet
% for k = 500 : 650 % tscHomo
% for k = 1000 : 1100 % tscNeg

for k = 400 : 625 % tscHet
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
    formatspace = 'Frame = %d';
    str = sprintf(formatspace, k);
    annotation('textbox',[.75 .8 .1 .1],'string',str, 'Tag', 'stream')
    drawnow;
end

close(v);
