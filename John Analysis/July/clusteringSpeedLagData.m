%% Cluster the Speed vs Lag data in permaList
 
% load('/Users/johnduva/Git/StrideAnalysis/John Analysis/August/PL_tscHet.mat')

% Z-score the data
X = zscore(PL_tscHet(:,1:2));
scatter(X(:,1), X(:,2), 1)



%% Manual clustering of data
X = PL_tscHet(:,1:2);
Xabove = [];
Xbelow = [];
for i = 1: length(X)
    if X(i,2) >= -.3
        Xabove = [Xabove; X(i,:)];
    else 
        Xbelow = [Xbelow; X(i,:)];
    end
end

s = scatter(Xabove(:,1), Xabove(:,2), 2);
s.MarkerFaceColor = 'blue';
hold on;
s = scatter(Xbelow(:,1), Xbelow(:,2), 2);
s.MarkerFaceColor = 'red';
legend('Cluster 1','Cluster 2', 'Centroids',...
       'Location','SE')
title 'Cluster Assignments - TscHet'
% ylim([-3.5 1])
% xlim([.0 .3])
hold off

%%
clusters = 2;
opts = statset('Display','final');
% idx = kmedoids(X,clusters,'Distance', 'city', 'Replicates',1, 'Options',opts);
[idx3, C] = kmeans(X,clusters,'Distance', 'city', 'Replicates', 10, 'Display','final');
idx = idx3;
% Note: all rows wherein idx==1 in the first column
% X(idx==1,1)

point_size=5;

figure;
plot(X(idx==1,1),X(idx==1,2),'k.','MarkerSize',point_size)
hold on
plot(X(idx==2,1),X(idx==2,2),'b.','MarkerSize',point_size)
hold on

plot(C(:,1),C(:,2),'kx',...
     'Color', 'k','MarkerSize',12,'LineWidth',2) 
legend('Cluster 1','Cluster 2', 'Centroids',...
       'Location','SE')
title 'Cluster Assignments and Centroids - TscHet'
% ylim([-3.5 1])
% xlim([.0 .3])
hold off

    