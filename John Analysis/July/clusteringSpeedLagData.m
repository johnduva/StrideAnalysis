%% Cluster the Speed vs Lag data in permaList

% Set the dataset to 'X'
X = permaList;

opts = statset('Display','final');
[idx,C] = kmeans(X,3,'Distance','cityblock',...
    'Replicates',5,'Options',opts);

% Note: all rows wherein idx==1 in the first column
% X(idx==1,1)

size=5;

figure;
plot(X(idx==1,1),X(idx==1,2),'g.','MarkerSize',size)
hold on
plot(X(idx==2,1),X(idx==2,2),'b.','MarkerSize',size)
hold on
plot(X(idx==3,1),X(idx==3,2),'r.','MarkerSize',size)
hold on
plot(X(idx==4,1),X(idx==4,2),'k.','MarkerSize',size)
hold on
% plot(C(:,1),C(:,2),'kx',...
%      'Color', '#D95319','MarkerSize',12,'LineWidth',2) 
legend('Cluster 1','Cluster 2','Cluster 3', 'Cluster 4', 'Centroids',...
       'Location','SE')
title 'Cluster Assignments and Centroids'
% ylim([-2.5 0])
hold off

%delete later

