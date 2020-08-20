%% Coordination of animals with headgear
% Create plot of avg velocity vs. xcorr lag per stride phase

load('/Volumes/wang_mkislin/behneurodata/Bparts/sLEAP_positions_pred_by_day_headgear.mat')
PL_headgear = nan(1,6);
day = 1;

% Only the 4 neuropixel animals:
for an = 1 : 4
    % Get 95k locations for 4 paws from 'positions_pred_by_day'
    allPaws = [permute(positions_pred_by_day{an,1}(:, [5 6 8 9], 1), [2 3 1]), ...
                permute(positions_pred_by_day{an,1}(:, [5 6 8 9], 2), [2 3 1])]; 
    % Isolate diagonal paws
    forepaw = allPaws(1,:,:);
    hindpaw = allPaws(4,:,:);
            
    % Centroid is half the distance between nose and tail base
    tailbase = permute([positions_pred_by_day{an,1}(:,7,1), positions_pred_by_day{an,1}(:,7,2)], [3 2 1]);
    neck     = permute([positions_pred_by_day{an,1}(:,2,1), positions_pred_by_day{an,1}(:,7,2)], [3 2 1]);
    centroid = [
        (abs(tailbase(1,1,:)-neck(1,1,:))/2)+min(tailbase(1,1,:),neck(1,1,:)), ...
        (abs(tailbase(1,2,:)-neck(1,2,:))/2)+min(tailbase(1,2,:),neck(1,2,:))
        ];
    % Sanity check: scatter(centroid(:,1,:), centroid(:,2,:), 1)
    
    % Get distance between paw x,y coordinates and tail base coordinates
    ego_fore = (forepaw(1,1,:)-centroid(1,1,:)).^2 + (forepaw(1,2,:)-centroid(1,2,:)).^2;
    ego_fore = permute(ego_fore, [3 2 1]);
    ego_hind = (hindpaw(1,1,:)-centroid(1,1,:)).^2 + (hindpaw(1,2,:)-centroid(1,2,:)).^2;
    ego_hind = permute(ego_hind, [3 2 1]);
    paws = [ego_fore, ego_hind];
%     plot(paws(:,1)); hold on; plot(paws(:,2));
    
%     figure(2)
%     plot(zscore(ego_fore(~isnan(ego_fore)))); hold on; plot(zscore(ego_hind(~isnan(ego_hind)))); 
    
    % Remove low velocity frames:
    cent = squeeze(centroid)';
    x = gradient(cent(:,1)); % centroid change in x per frame...
    y = gradient(cent(:,2));
    % Centroid distance (in pixels traveled per frame):
    vel = sqrt( x.^2 + y.^2 );
    if an ==1
        vel = fillmissing(vel(1:92770),'linear');
    else
        vel = fillmissing(vel,'linear');
    end
    vel = movmedian(vel,80/2);
    % Pixels per second:
    vel = vel*40;
    % meters per second:
    vel = vel*.51 / 1000;

    % Keep only the frames where velocity > threshold (40th percentile)
    keepFrames = vel(vel>prctile(vel,40));

    % Get the maxpeaks so we can consider each 2π phase
    for k = 1:2
        [maxx, maxIndex] = findpeaks(paws(:,k),'MinPeakDistance', 9);
        maxpkx{k} = [maxIndex, maxx];
        clear maxx maxIndex
    end

    % Get the centroid locations from 'keepersOnly' (only 27,525 instead of 95k)
    index = 1;
    for frame = 1: length(allTracks{pORa{phe}(1,an),day})
        if ismember(frame, keepersOnly{pORa{phe}(1,an),day}) % && frame == blank + 1
            centroidsF2(index,1) = allTracks{pORa{phe}(1,an),day}(frame,1); 
            centroidsF2(index,2) = allTracks{pORa{phe}(1,an),day}(frame,2);
            index = index + 1;
        end
    end


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

