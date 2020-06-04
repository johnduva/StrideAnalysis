%% Calculate Distances Between Centroids at Forepaw Touchdown
xdist = abs(tempc(maxIndex(19),1) - tempc(maxIndex(20),1));
ydist = abs(tempc(maxIndex(19),2) - tempc(maxIndex(20),2));
dist_mm = sqrt(xdist^2 + ydist^2) * 1.97
% clear('dist', 'xdist', 'ydist')

%% Calculate Distances Between Forepaw Touchdowns
xdist = abs( x5(maxIndex(14)) - x5(maxIndex(15)));
ydist = abs( y5(maxIndex(14)) - y5(maxIndex(15))); 
dist_mm = sqrt(xdist^2 + ydist^2) * 1.97
% clear('dist', 'xdist', 'ydist')
