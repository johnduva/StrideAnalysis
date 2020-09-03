%% Coordination of animals with headgear
% Create plot of avg velocity vs. xcorr lag per stride phase

% load('/Volumes/wang_mkislin/behneurodata/Bparts/sLEAP_positions_pred_by_day_headgear.mat')
clearvars -except positions_pred_by_day PL_neuropixel PL_miniscope
PL_miniscope = nan(1,6);
day = 1;
Fs = 40;
thresh = 0;
resample = 1000;

% Only the 4 neuropixel animals:
for an = [5:10,12:15]
    disp(an)
    % Get 95k locations for 4 paws from 'positions_pred_by_day'
    allPaws = [permute(positions_pred_by_day{an,1}(:, [5 6 8 9], 1), [2 3 1]), ...
                permute(positions_pred_by_day{an,1}(:, [5 6 8 9], 2), [2 3 1])]; 
    % x-y realspace coordinates of paws
    paw1 = allPaws(1,:,:); 
    paw2 = allPaws(2,:,:); 
    paw3 = allPaws(3,:,:);
    paw4 = allPaws(4,:,:);
            
    % Centroid is half the distance between neck and tail base
    % This 'centroid' is really TTI
    centroid = permute([positions_pred_by_day{an,1}(:,7,1), positions_pred_by_day{an,1}(:,7,2)], [3 2 1]);
%     neck     = permute([positions_pred_by_day{an,1}(:,2,1), positions_pred_by_day{an,1}(:,7,2)], [3 2 1]);
%     centroid = [
%         (abs(tailbase(1,1,:)-neck(1,1,:))/2)+min(tailbase(1,1,:),neck(1,1,:)), ...
%         (abs(tailbase(1,2,:)-neck(1,2,:))/2)+min(tailbase(1,2,:),neck(1,2,:))
%         ];
%     % Sanity check: 
    % scatter(centroid(:,1,:), centroid(:,2,:), .5)
    
    % Get distance between paw x,y coordinates and centroid coordinates
    ego_fore = sqrt( ... 
        (paw1(1,1,:)-centroid(1,1,:)).^2 + ...
        (paw1(1,2,:)-centroid(1,2,:)).^2 ); ego_fore = permute(ego_fore, [3 2 1]);
    ego_fore = fillmissing(ego_fore,'linear');
    
    
    ego_hind = sqrt( ... 
        (paw3(1,1,:)-centroid(1,1,:)).^2 + ...
        (paw3(1,2,:)-centroid(1,2,:)).^2 ); ego_hind = permute(ego_hind, [3 2 1]);
    ego_hind = fillmissing(ego_hind,'linear');
    
    % Sanity check: make sure y-axis makes sense
%     plot(ego_fore); hold on; plot(ego_hind);
%     figure(2)
%     plot(zscore(ego_fore(~isnan(ego_fore)))); hold on; plot(zscore(ego_hind(~isnan(ego_hind)))); 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Extract velocity from centroid, then remove low velocity frames:
    cent = squeeze(centroid)';
    x = gradient(cent(:,1)); % centroid change in x per frame...
    y = gradient(cent(:,2));
    % Centroid distance (in pixels traveled per frame):
    vel = sqrt( x.^2 + y.^2 );
    if an ==1; vel = fillmissing(vel(1:92770),'linear');
    else; vel = fillmissing(vel,'linear'); end
    vel = movmedian(vel,Fs/2);
    % Pixels per second:
    vel = vel*40;
    % mm per second:
    vel = vel*.51/1000 ;

    % Keep only the frames where velocity > threshold 
    keepFrames = [];
    for velocity = 1:length(vel)
        if vel(velocity)>thresh; keepFrames = [keepFrames; velocity]; end
    end
        
%     keepCent     = cent;
%     keepEgoPaws  = [ ego_fore, ego_hind];
%     keepRealPaws = [ forepaw; hindpaw];
%     keepVel      = vel;

    % Reduce frame count with 'keepFrames'.
    keepCent     = cent(keepFrames,:);
    keepEgoPaws  = [ ego_fore(keepFrames), ego_hind(keepFrames) ];
    keepVel      = vel(keepFrames);
    keepTTI      = [ centroid(1,1,keepFrames), centroid(1,2,keepFrames) ];
    % (1) right forepaw, (3) left hindpaw 
    keepRealPaws = [ ...
        paw1(:,:,keepFrames); ...
        paw2(:,:,keepFrames); ...
        paw3(:,:,keepFrames); ...
        paw4(:,:,keepFrames)  ];
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Get the maxpeaks so we can consider each 2π phase
    for k = 1:2
        [pks, locs] = findpeaks(keepEgoPaws(:,k),'MinPeakDistance', 31);
        maxpkx{k} = [locs, pks];
        clear maxx maxIndex
    end
    
    % Sanity check: plot signal of both paws with maximums overlaid 
    % (keep optimizing the Name/Value pairs until satisfied (read 'findpeaks')
%     plot(keepEgoPaws(:,1)); hold on; 
%     scatter(maxpkx{1,1}(:,1), maxpkx{1,1}(:,2)  );
%     hold on;
%     plot(keepPaws(:,2)); hold on; 
%     scatter( maxpkx{1,2}(:,1), maxpkx{1,2}(:,2)  );
    
%     plot(zscore(keepEgoPaws(~isnan(keepEgoPaws(:,1)), 1))); hold on; 
%     plot(zscore(keepEgoPaws(~isnan(keepEgoPaws(:,2)), 2))); hold on;
    

    % Create skeleton: each row will contain a lag and a speed to create a scatterplot
    temp_strides = nan(1,4);
    count = 1;
    for k = 1 : 5 : min( [length(maxpkx{1,2}); length(maxpkx{1,1})]  )-5
        %% Forepaw vector of normalized distances from TTI from one max to the next
        v1 = keepEgoPaws(maxpkx{1,1}(k,1) : maxpkx{1,1}(k+5,1) ,1);
        % Hind paw vector of normalized distances from TTI from one max to the next
        v2 = keepEgoPaws(maxpkx{1,1}(k,1) : maxpkx{1,1}(k+5,1) ,2);
        start = maxpkx{1,1}(k,1);
        finish = maxpkx{1,1}(k+5,1);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %          Use 'xcorr' function to get the lag for each iteration (stride)         %        
        % Generate vector 'c'
%         [c, lags] = xcorr(v1, v2, 50, 'coeff');
        [c, lags] = xcorr(zscore(v1), zscore(v2), 25, 'coeff');
        % Resample 'c' by interpolating with a factor of 100 (same for lags)
        cnew = interp(c,resample);
        lags_interp = interp(lags,100);
        % cut results by half
        lags_interp = lags_interp(lags_interp<0);
        cnew = cnew(lags_interp<0);
        % Get the index of the max value and use it to find the (now more precise) lag
        [~,index] = max(cnew);
        t = lags_interp(index);
%         plot(lags_interp,cnew)
% 
%         figure(1); plot(v1);  hold on; plot(v2, 'Color','r'); 
%         figure(2); plot(v1);  hold on; plot((1:frames)+t,v2, 'Color','r')
% 
        % Plot regular bout against corrected bout
%         frames = maxpkx{1,1}(k+5,1) - maxpkx{1,1}(k,1) + 1;
%         subplot(1,2,1)
%         plot(zscore(v1));  hold on; plot(zscore(v2), 'Color','r')
%         subplot(1,2,2)
%         plot(zscore(v1));  hold on; plot((1:frames)+t,zscore(v2), 'Color','r')
%         str4 = sprintf( 'lag = %1.2f frames', t);
%         annotation('textbox', [0.8, 0.15, 0.2, 0.05], 'String', str4, 'FitBoxToText','on')
        %%
        
        % Average stride length for this five stride bout:
        fiveDists = [];
        for peaks = 1 : 5
            xdist = abs( keepRealPaws(1,1,maxpkx{1,1}(k+peaks)) - keepRealPaws(1,1,maxpkx{1,1}(k+peaks-1)));
            ydist = abs( keepRealPaws(1,2,maxpkx{1,1}(k+peaks)) - keepRealPaws(1,2,maxpkx{1,1}(k+peaks-1)));
            fiveDists = [fiveDists, sqrt( xdist^2 + ydist^2)];
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        keepMeanVel = mean(  keepVel(maxpkx{1,1}(k,1):maxpkx{1,1}(k+5,1))  );

        numFrames = maxpkx{1,1}(k+5,1) - maxpkx{1,1}(k,1);
        radians = 2*pi*5/numFrames;

        % Add lag and speed to a new row in 'strides'
        temp_strides(count,1) = keepMeanVel;
        temp_strides(count,2) = radians * t;
        temp_strides(count,3) = start;
        temp_strides(count,4) = finish;
        temp_strides(count,5) = an;
        temp_strides(count,6) = mean(fiveDists);

        count = count + 1;
    end

    % Add strides from this animal to the permanent list
%     PL_headgear = [PL_headgear; rmoutliers(temp_strides);];
    PL_miniscope = [PL_miniscope; temp_strides];
end

PL_miniscope(1,:) = []; % remove first line of NaNs
% save('PL_headgear4.mat', 'PL_tscHet')

%% Plot avg speed versus lag
figure(1)
scatter(PL_tscHomo(:,1), PL_tscHomo(:,2), 2, 'o', 'r' )
title('TscHomo Animals (n=...)')
xlabel('Velocity (m/s)')
ylabel('Lag (radians)')
ylim([-5 1])
xlim([0 .4])
% legend('Tsc')
% saveas(gcf, 'neuropixpel_1000.png')

h1 = histogram(PL_tscHomo(:,1), 19)
% Bin speeds (save to 7th column of matrix)
meanVels = [];
for speed = 1: length(PL_tscHomo(:,1))
    for bin = 1 : length(h1.BinEdges)
        if PL_tscHomo(speed,1) >= h1.BinEdges(bin) && PL_tscHomo(speed,1) < h1.BinEdges(bin+1)
            PL_tscHomo(speed,7) = bin;
            meanVels(bin) = [meanVels(bin), speed];
        end
    end
end
h2 = histogram(PL_tscHomo(:,7), 19)
% Confirm results look like 'histogram(PL_tscHomo(:,1))'
scatter(PL_tscHomo(:,7), PL_tscHomo(:,2), 1)
title('Binned Velocities vs Lag ')
xlabel('Binned Velocities')
ylabel('Lag (radians)')
% saveas(gcf, 'binnedVels.png')

meanLags = nan(19,1);
for binn = 1 : h1.NumBins
    for lag = 1: length(PL_tscHomo(:,7))
        if PL_tscHomo(lag,7) == binn
            meanLags(binn, end+1) = PL_tscHomo(lag,2);
        end
    end
end
% Rremove first column of NaNs
meanLags(:,1) = [];


% Take the average of each row (ignoring the zeros)
binnedAvg = nan(19,1);
for row = 1 : size(meanLags, 1)
    binnedAvg(row) = mean(meanLags(row, meanLags(row,:)~=0 ));
end

figure(3);
scatter(h1.BinEdges(1:19), binnedAvg, 'filled')
title('Binned Speed vs Avg Lag (TscHomo) ')
xlabel('Binned Velocities')
ylabel('Lag (radians)')
ylim([-3.5 0])
% 
% % Now bin the lags (save to 8th column of matrix)
% h = histogram(PL_tscHomo(:,2), 19);
% for lag = 1: length(PL_tscHomo(:,2))
%     for bin = 1 : length(h.BinEdges)
%         if PL_tscHomo(lag,2) >= h.BinEdges(bin) && PL_tscHomo(lag,2) < h.BinEdges(bin+1)
%             PL_tscHomo(lag,8) = bin;
%         end
%     end
% end
% % Confirm results look like 
% figure(2); histogram(PL_tscHomo(:,2), 20)
% histogram(PL_tscHomo(:,8))
% 
% % Now scatter the binned vels vs binned lags
% scatter( PL_tscHomo(:,7), PL_tscHomo(:,8), 7, 'filled')
% title('Binned Vel vs Binned Lag')
% xlabel('Binned Velocity')
% ylabel('Binned Lag')
% saveas(gcf, 'binnedVelsAndLag.png')


%% Speed vs Lag vs Stride Length
% speed = PL_miniscope(:,1);
% lag = PL_miniscope(:,2);
% strideLength = PL_miniscope(:,6);
% 
% scatter(speed, lag, 2, strideLength)
% title('Homozygotes: Speed vs Lag vs Stride Length')
% xlabel('Speed (m/s)')
% ylabel('Lag (radians)')
% c = colorbar;
% c.Label.String = 'Stride Length (mm)';
% ylim([-3.5 0.5])
% xlim([0 .4])
% saveas(gcf, 'cntnapNeg_3plot.png')


%% Density plots
% for temp = 1: length(permaList)
%     if permaList(temp,2) == 0
%         permaList(temp,1) = 0;
%     end
% end
% 
% permaList(:,2)), nonzeros(permaList(:,1))

