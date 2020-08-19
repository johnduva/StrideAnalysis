% Load the headgear data:
% load('/Volumes/wang_mkislin/behneurodata/Bparts/sLEAP_files_by_day_headgear.mat')

% Get four paw real space coordinates for each 95k frame video
for an = 1 : length(positions_pred_by_day)
    for frame = 1 : length(positions_pred_by_day{an,1}) 
        paws = [permute(positions_pred_by_day{an,1}(frame, [5 6 8 9], 1), [2 1 3]), ...
                permute(positions_pred_by_day{an,1}(frame, [5 6 8 9], 2), [2 1 3])];
    end
end


% Plot current frame in real space:
figure(1);
scatter(paws(:,1), paws(:,2)  )
xlim([0 1050])
ylim([0 1050])

%% Get velocity changes by centroid (but maybe paw velocity is better?)

% First instinct is to find dendrite signals having high correlations with:
%     (1) centroid speed: determine if there are dendrites that fire for general locomotion
%     (2) individual paw speeds

%% Establish the centroid velocity vector 'speed' in mm/s
x = diff(centroid(1,:)); % centroid change in x per frame...
y = diff(centroid(2,:));

% Centroid distance (in pixels traveled) per frame:
dist = sqrt( x.^2 + y.^2 );
% Pixels per second:
speed = dist*40;
% mm per second:
speed = speed*.51;

%% Overlay Centroid Velocity and Ca Signal
plot(zscore(speed));
hold on;
plot(zscore(Ca_data(1,:)));
xlim([0 800])
ylim([-.5 3])
xlabel('Frame')
ylabel('Normalized Speed and Ca Signal')
title('Dendrite #1: Signal vs Centroid Velocity')
legend('Centroid Velocity', 'Ca Signal')
saveas(gcf, 'speedSignalOverlay.png')

%% Plot Speed vs Ca Signal
scatter([speed,0], Ca_data(1,:), 2)
xlabel('Speed (mm/s)')
ylabel('Ca Signal')
xlim([-20 450])
title('Speed vs Ca Signal')
saveas(gcf, 'speedVsCa.png')

%% Determine correlation: centroid velocity vs each dendrite
corrs = zeros(134,1);
for dendrite = 1 : size(Ca_data,1)
    [Cnew, lags] = xcorr([speed,0], Ca_data(dendrite,:), 'coeff');
    [r, i] = max(Cnew);
    Cnew(0)
end



