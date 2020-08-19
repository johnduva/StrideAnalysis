%% Coordination of animals with headgear
% Create plot of avg velocity vs. xcorr lag per stride phase

load('sLEAP_positions_pred_by_day_headgear.mat')
day = 1;
PL_headgear = nan(1,6);

allPaws = permute( correctedTens5{pORa{phe}(1,an),day}([5,6,9,10], : , :), [2 1 3]);
paws = [ zscore(squeeze(allPaws(2,2,:))), zscore(squeeze(allPaws(2,3,:))) ];

% Just 4 neuropixel animals
for an = 1 : 4
    allPaws = [permute(positions_pred_by_day{an,1}(:, [5 6 8 9], 1), [2 3 1]), ...
                permute(positions_pred_by_day{an,1}(:, [5 6 8 9], 2), [2 3 1])]; 
    
    centroid = [positions_pred_by_day{an,1}(:,7,1), positions_pred_by_day{an,1}(:,7,2)];
    centroid = permute(centroid, [3 2 1]);
    
    forepaw = allPaws(1,:,:);
    hindpaw = allPaws(3,:,:);
    
    ego_fore = permute((forepaw(1,1,:)-centroid(1,1,:)).^2 + (forepaw(1,2,:)-centroid(1,2,:)).^2, [3 1 2]);
    ego_hind = (hindpaw(1,1,:)-centroid(1,1,:)).^2 + (hindpaw(1,2,:)-centroid(1,2,:)).^2;
end
plot(ego_fore); hold on; plot(ego_hind)



% Get the maxpeaks so we can consider each 2π phase
for k = 1:2
    [maxx, maxIndex] = findpeaks(paws(:,k),'MinPeakDistance', 9);
    maxpkx{k} = [maxIndex, maxx];
    clear maxx maxIndex
end

%% Get the cross correlation of the y-values from maxpk(k) to maxpk(k+1)
% Get the centroid locations from 'keepersOnly' (only 27,525 instead of 95k)
index = 1;
for frame = 1: length(allTracks{pORa{phe}(1,an),day})
    if ismember(frame, keepersOnly{pORa{phe}(1,an),day}) % && frame == blank + 1
        centroidsF2(index,1) = allTracks{pORa{phe}(1,an),day}(frame,1); 
        centroidsF2(index,2) = allTracks{pORa{phe}(1,an),day}(frame,2);
        index = index + 1;
    end
end

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extract the name of the file by day for the session, and zero pad it
vid = sprintf('%04d',cell2mat(files_by_day(pORa{phe}(1,an),day)));
% Load rotVal from proper file
load(['/Users/johnduva/Desktop/Stride Figures/ASDvids/OFT-', vid, '-00_box_aligned_info.mat'], 'mouseInfo')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Change coordinates to real space
allPaws2 = permute(allPaws,[2 1 3]);
tempr = deg2rad(mouseInfo.rotVal);
tempr = tempr(keepersOnly{pORa{phe}(1,an),day});
midJoints = double(allPaws2) - 200;

jx = double(squeeze(midJoints(:,1,:)));
jy = double(squeeze(midJoints(:,2,:)));
ff = zeros(size(allPaws2));

for i = 1:length(jx)
    [jp2j(:,i), jp2i(:,i)] = cart2pol(jx(:,i)',jy(:,i)');
    tjp(:,i) = jp2j(:,i) + repmat(tempr(i),[4 1]);
    [jp3j(:,i), jp3i(:,i)] = pol2cart(tjp(:,i),jp2i(:,i));
    ogc1(:,i) = jp3j(:,i) + centroidsF2(i,1);
    ogc2(:,i) = jp3i(:,i) + centroidsF2(i,2);
end

ff(:,1,:) = ogc1; 
ff(:,2,:) = ogc2;
clearvars jp2i jp2j jp3j jp3i jx jy midJoints ogc1 ogc2 tempt tempr tempCents tjp;

% Convert the centroid locations to velocities
% Get change in x-coordinate per frame (negative just means a change to the left)
vx = gradient(centroidsF2(:,1));
% get the change in y-coordinate per frame
vy = gradient(centroidsF2(:,2));
% velocity 
vel = ((sqrt(vx.^2 + vy.^2)));
clear vx vy;
vel = fillmissing(vel,'linear');
vel = movmedian(vel,80/2);
% from pixels per frame to mm per second
vel = vel * 80 * .51 / 1000;


% Create skeleton: each row will contain a lag and a speed to create a scatterplot
temp_strides = nan(1,4);
count = 1;
for k = 1 : 5 : min( [length(maxpkx{1,2}); length(maxpkx{1,1})]  )-5

    % Forepaw vector of normalized distances from TTI from one max to the next
    v1 = paws(maxpkx{1,1}(k,1) : maxpkx{1,1}(k+5,1) ,1);
    % Hind paw vector of normalized distances from TTI from one max to the next
    v2 = paws(maxpkx{1,1}(k,1) : maxpkx{1,1}(k+5,1) ,2);
    start = maxpkx{1,1}(k,1);
    finish = maxpkx{1,1}(k+5,1);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %          Use 'xcorr' function to get the lag for each iteration (stride)         %        
    % Generate vector 'c'
    [c, lags] = xcorr(v1, v2);
    % Resample 'c' by interpolating with a factor of 100 (same for lags)
    cnew = interp(c,100);
    lags_interp = interp(lags,100);
    % Get the index of the max value and use it to find the (now more precise) lag
    [~,index] = max(cnew);
    t = lags_interp(index);

%         [~,i] = max(c);
%         t = i-length(v1);
%         
%         [m,s] = normfit(c);
%         y = normpdf(c,m,s);
%         [~,i] = max(y);
%         t = i-length(c);
% 
%         plot(c,y,'.');
%         hold on;
%         plot(lags,c)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Average stride length for this five stride bout:
    fiveDists = [];
    for peaks = 1 : 5
        xdist = abs( ff(1, 1, maxpkx{1,1}(k+peaks)) - ff(1, 1, maxpkx{1,1}(k+peaks-1)));
        ydist = abs( ff(1, 2, maxpkx{1,1}(k+peaks)) - ff(1, 2, maxpkx{1,1}(k+peaks-1)));
        fiveDists = [fiveDists, sqrt( xdist^2 + ydist^2)*.51];
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    velocity = mean(  vel(maxpkx{1,1}(k,1):maxpkx{1,1}(k+5,1))  );

    numFrames = maxpkx{1,1}(k+5,1) - maxpkx{1,1}(k,1);
    radians = 2*pi*5/numFrames;

    % Add lag and speed to a new row in 'strides'
    temp_strides(count,1) = velocity;
    temp_strides(count,2) = t*radians;
    temp_strides(count,3) = start;
    temp_strides(count,4) = finish;
    temp_strides(count,5) = an;
    temp_strides(count,6) = mean(fiveDists);

    count = count + 1;
end

% Add strides from this animal to the permanent list
PL_headgear = [PL_headgear; rmoutliers(temp_strides);];
    

PL_headgear(1,:) = [];
save('PL_tscHet.mat', 'PL_tscHet')

%% Plot avg speed versus lag
figure(1)
scatter(PL_tscNeg(:,1), PL_tscNeg(:,2), 2, 'o', 'r' )
title('Negatives: Velocity vs Lag')
xlabel('Velocity (m/s)')
ylabel('Lag (radians)')
ylim([-3.5 .5])
xlim([.05 .4])
% legend('Tsc')
hold on

scatter(PL_cntnapHet(:,1), PL_cntnapHet(:,2), 2, 'o', 'b' )
title('Negatives: Velocity vs Lag')
xlabel('Velocity (m/s)')
ylabel('Lag (radians)')
ylim([-3.5 .5])
xlim([.05 .4])
% legend('Tsc')
saveas(gcf, 'negs.png')


%%
speed = PL_headgear(:,1);
lag = PL_headgear(:,2);
strideLength = PL_headgear(:,6);

scatter(speed, lag, 2, strideLength)
title('Homozygotes: Speed vs Lag vs Stride Length')
xlabel('Speed (m/s)')
ylabel('Lag (radians)')
c = colorbar;
c.Label.String = 'Stride Length (mm)';
ylim([-3.5 0.5])
xlim([0 .4])
% saveas(gcf, 'cntnapNeg_3plot.png')



%%
% Include r on plot
% r = corrcoef(permaList(:,1), permaList(:,2));
% r = r(1,2);
% str = sprintf( 'r= %1.2f', r);
% annotation('textbox', [0.8, 0.8, 0.1, 0.1], 'String', str)

% Include mean lag on plot
meanLag = mean(PL_headgear(:,2));
str2 = sprintf( 'avg lag = %1.2f', meanLag);
annotation('textbox', [0.15, 0.8, 0.1, 0.1], 'String', str2)

% Include mean speed on plot
meanSpeed = mean(PL_headgear(:,1));
str3 = sprintf( 'avg vel = %1.2f', meanSpeed);
annotation('textbox', [0.7, 0.15, 0.2, 0.05], 'String', str3)

% saveas(gcf, 'cntnapHomo.png')

%% Plot entire series with maximums indicated on figure
figure(2)
findpeaks(paws(1:1000,1),'MinPeakDistance', 11)
hold on
findpeaks(paws(1:1000,2),'MinPeakDistance', 11)

%% Density plots
% for temp = 1: length(permaList)
%     if permaList(temp,2) == 0
%         permaList(temp,1) = 0;
%     end
% end
% 
% permaList(:,2)), nonzeros(permaList(:,1))

