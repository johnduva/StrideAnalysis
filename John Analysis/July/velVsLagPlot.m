%% Create plot of avg velocity vs. xcorr lag per stride phase

% ASD_all, phenos, or Cntnap2_all
pORa = phenos; 
% Het(1), Homo(2), or Neg(3)
phe = 1;

an = 1; day = 1; 
allPaws = permute( correctedTens5{pORa{phe}(1,an),day}([5,6,9,10], : , :), [2 1 3]);
paws = [ zscore(squeeze(allPaws(2,2,:))), zscore(squeeze(allPaws(2,3,:))) ];

% Get the minpeaks so we can consider each 2π phase
for k = 1:2
    [maxx, maxIndex] = findpeaks(paws(:,k),'MinPeakDistance', 9);
    maxpkx{k} = [maxIndex, maxx];
    clear maxx maxIndex
%     [minn, minIndex] = findpeaks(-paws(:,k),'MinPeakDistance', 9);
%     minpkx{k} = [minIndex, -minn];
%     clear minn minIndex
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
strides = nan(1,1);
for k = 1 : min( [length(maxpkx{1,2}); length(maxpkx{1,1})]  )-1
    % Forepaw vector of normalized distances from TTI from one max to the next
    v1 = paws(maxpkx{1,1}(k,1) : maxpkx{1,1}(k+1,1) ,1);
    % Hind paw vector of normalized distances from TTI from one max to the next
%     v2 = paws(maxpkx{1,2}(k,1) : maxpkx{1,2}(k+1,1) ,2);
    v2 = paws(maxpkx{1,1}(k,1) : maxpkx{1,1}(k+1,1) ,2);

    % Use 'xcorr' function to get the lag for each iteration (stride)
    [c, lags]  = xcorr(v1, v2);
    % Normalize
    c = abs(c)/max(c);
    % Get the max value and its index:
    [~,i] = max(c);
    t = lags(i);
    
    
    
    
    
    % Add lag and speed to a new row in 'strides'
    strides(k,1) = t;
%     strides(k,2) = speed;
end

% Plot current stride
figure(3)
plot(v1); hold on; plot(v2)


% Plot stride with 3 frame shift
figure(1)
plot((1:length(v1))+3, v1); hold on; plot(v2)



%%
figure(2)
findpeaks(paws(1:1000,1),'MinPeakDistance', 11)
hold on
findpeaks(paws(1:1000,2),'MinPeakDistance', 11)


