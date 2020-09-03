%% Create plot of avg velocity vs. xcorr lag per stride phase
clearvars -except allTracks correctedTens5 keepersOnly z Cntnap2_all ASD_all phenos permaList files_by_day

% phenos, ASD_all, or Cntnap2_all
pORa = ASD_all;
% Het(1), Homo(2), or Neg(3)
phe = 2;
day = 1;
fprintf('%d animals in current phenotype:\n', length(pORa{1,phe}(1,:)));
PL_tscHomo = 0 ;

for an = 1 : length(pORa{1,phe}(1,:)) 
    disp(an);
    % 5==left_forepaw; 6==right_forepaw; 9==left_hindpaw; 10==right_hindpaw
    %         1                2                 3                 4
    % Get the trajectories of all four paws
    allPaws = permute( correctedTens5{pORa{phe}(1,an),day}([5,6,9,10], : , :), [2 1 3]);
    % Reshape them by reducing to two dimensional matrix: 'paws'
    paws = [ squeeze(allPaws(2,1,:)), squeeze(allPaws(2,2,:)), squeeze(allPaws(2,3,:)), squeeze(allPaws(2,4,:)),  ];

    % Get the maxpeaks so we can consider each 2π phase
    for k = 1:4
        [maxx, maxIndex] = findpeaks(paws(:,k),'MinPeakDistance', 9);
        maxpkx{k} = [maxIndex, maxx];
        clear maxx maxIndex
    end
    
    % Create skeleton: each row will contain a lag and a speed to create a scatterplot
%     temp_strides = nan(1,4);
    temp_strides = nan(1,100);
    count = 1;
    for k = 1 : min( [length(maxpkx{1,1}); length(maxpkx{1,2}); length(maxpkx{1,3}); length(maxpkx{1,4})]  )-1

        % Paw vectors of normalized distances from TTI from one max to the next
        v1 = zscore(paws( maxpkx{1,1}(k,1) : maxpkx{1,1}(k+1,1), 1));
        v2 = zscore(paws( maxpkx{1,1}(k,1) : maxpkx{1,1}(k+1,1), 2));
        v3 = zscore(paws( maxpkx{1,1}(k,1) : maxpkx{1,1}(k+1,1), 3));
        v4 = zscore(paws( maxpkx{1,1}(k,1) : maxpkx{1,1}(k+1,1), 4));
        
        temp_strides(count,:) = v1';
%         temp_strides(count,2) = {v2};
%         temp_strides(count,3) = {v3};
%         temp_strides(count,4) = {v4};
        
%         start = maxpkx{1,1}(k,1);
%         finish = maxpkx{1,1}(k+1,1);        
        count = count + 1;
    end
    
    % Add strides from this animal to the permanent list
    PL_tscHomo = [PL_tscHomo; temp_strides];
end
PL_tscHomo(1,:) = [];
% save('PL_tscHet.mat', 'PL_tscHet')


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
speed = PL_tscHomo(:,1);
lag = PL_tscHomo(:,2);
strideLength = PL_tscHomo(:,6);

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
meanLag = mean(PL_tscHomo(:,2));
str2 = sprintf( 'avg lag = %1.2f', meanLag);
annotation('textbox', [0.15, 0.8, 0.1, 0.1], 'String', str2)

% Include mean speed on plot
meanSpeed = mean(PL_tscHomo(:,1));
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

