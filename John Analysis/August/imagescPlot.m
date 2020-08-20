% heatmap, see if the correlations are higher at 
% plot histogram of velocity, l


% imagesc, visualize metrics (values given by the colorscale) 
ax1 = subplot(2,3,1);
imagesc(Ca_data(:,1:9953)); 
% colorbar; 
caxis([0 30])

ax4 = subplot(2,3,4);
plot(zscore(speed(1:9953)),'r')
linkaxes([ax1 ax2], 'x')
ylim([0 5])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ax2 = subplot(2,3,2);
imagesc(Ca_data(:,9955:21909)); 
% colorbar; 
caxis([0 30])

ax5 = subplot(2,3,5);
plot(zscore(speed(9955:21909)),'r')
linkaxes([ax1 ax2], 'x')
ylim([0 5])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%