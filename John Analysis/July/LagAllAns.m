%% Create plot of avg velocity vs. xcorr lag per stride phase
clearvars -except allTracks correctedTens5 keepersOnly z Cntnap2_all ASD_all phenos permaList

% phenos, ASD_all, or Cntnap2_all
pORa = ASD_all;
% Het(1), Homo(2), or Neg(3)
phe = 2;
day = 1;
fprintf('%d animals in current phenotype:\n', length(pORa{1,phe}(1,:)));
PL_tscHomo = nan(1,5);

for an = 1 : length(pORa{1,phe}(1,:)) 
    disp(an);
    % 5==left_forepaw; 6==right_forepaw; 9==left_hindpaw; 10==right_hindpaw
    %         1                2                 3                 4
    allPaws = permute( correctedTens5{pORa{phe}(1,an),day}([5,6,9,10], : , :), [2 1 3]);
    paws = [ zscore(squeeze(allPaws(2,2,:))), zscore(squeeze(allPaws(2,3,:))) ];

    % Get the minpeaks so we can consider each 2π phase
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
        [~,i] = max(cnew);
        t = lags_interp(i);
        
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
        
        count = count + 1;
    end
    
    % Add strides from this animal to the permanent list
    PL_tscHomo = [PL_tscHomo; rmoutliers(temp_strides);];
    
end
PL_tscHomo(1,:) = [];
save('PL_tscHomo.mat', 'PL_tscHomo')

%% Plot avg speed versus lag
figure(z)
scatter(PL_tscHomo(:,1), PL_tscHomo(:,2), 10, 'x', 'b' )
title('CntnapNeg Velocity vs Lag (n=17)')
xlabel('Velocity (m/s)')
ylabel('Lag (radians)')
ylim([-3.5 1])
xlim([0 .4])
legend('off')

% Include r on plot
% r = corrcoef(permaList(:,1), permaList(:,2));
% r = r(1,2);
% str = sprintf( 'r= %1.2f', r);
% annotation('textbox', [0.8, 0.8, 0.1, 0.1], 'String', str)

% Include mean lag on plot
meanLag = mean(PL_tscHomo(:,2));
str2 = sprintf( 'avg lag = %1.2f', meanLag);
annotation('textbox', [0.15, 0.8, 0.1, 0.1], 'String', str2)

% Include mean speed on plot
meanSpeed = mean(PL_tscHomo(:,1));
str3 = sprintf( 'avg vel = %1.2f', meanSpeed);
annotation('textbox', [0.7, 0.15, 0.2, 0.05], 'String', str3)

saveas(gcf, 'cntnapHomo.png')

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

