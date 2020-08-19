%% Cluster the Speed vs Lag data in permaList
% Manual clustering of data
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

s = scatter(Xabove(:,1), Xabove(:,2), 1);
s.MarkerFaceColor = 'blue';
lsline; 
hold on;

s = scatter(Xbelow(:,1), Xbelow(:,2), 1);
s.MarkerFaceColor = 'red';
lsline;

legend('Cluster 1','LS Line 1','Cluster 2', 'LS Line 2',...
       'Location','SE')
title 'Cluster Assignments - TscHomo'
xlabel('Speed')
ylabel('Lag (radians)')
ylim([-3.5 .5])
xlim([.05 .4])
hold off
% saveas(gcf,'cntnapHomoScatter.png')

%% Heatmaps 

% Doesn't work and is not what intended
% figure(1);
% heatscatter(Xabove(:,1), Xabove(:,2), pwd, 'heatmap', '50','5','o',1,1,'',''); 
% hold all; 
% heatscatter(Xbelow(:,1), Xbelow(:,2), pwd, 'heatmap', '50','5','o',1,1,'','');
% xlim([])
% ylim([])

% Now try densityplot():
densityplot(X(:,1), X(:,2));
ylim([-3.5 .5])
xlim([.05 .4])
% hold on;
% densityplot(Xbelow(:,1), Xbelow(:,2));



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

    