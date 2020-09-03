%% Create individual Speed Histograms
vec = PL_neuropixel(PL_neuropixel(:,1)<.4);
histogram(vec, 20, 'FaceColor', 'red')
title('Neuropixel Velocity Counts (n=4)')
xlabel('Velocity (m/s)')
ylabel('Counts')
ylim([0 500])
saveas(gcf,'neuropixelHist.png')
hold on;

%% Combine speed histograms 
vec = PL_neuropixel(PL_neuropixel(:,1)<.4);
histogram(vec, 20, 'FaceColor', 'red')
% title('Neuropixel Velocity Counts (n=4)')
xlabel('Velocity (m/s)')
ylabel('Counts')
% saveas(gcf,'neuropixelHist.png')
hold on;

histogram(PL_miniscope(:,1), 20, 'FaceColor', 'blue')
title('Neuropixel vs Miniscope Speeds')
legend('Neuropixel', 'Miniscope')
saveas(gcf,'miniVsNeuroHist.png')

%% Plot avg speed versus lag
scatter(PL_miniscope(:,1), PL_miniscope(:,2), 2, 'o', 'b' )
title('Neuropixel vs Miniscope')
xlabel('Velocity (m/s)')
ylabel('Lag (radians)')
ylim([-5 1])
xlim([0 .4])
hold on

scatter(PL_neuropixel(:,1), PL_neuropixel(:,2), 2, 'o', 'r' )
legend('Miniscope', 'Neuropixel')
saveas(gcf, 'neuroVsMini.png')
