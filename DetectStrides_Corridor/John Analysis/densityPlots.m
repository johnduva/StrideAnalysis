% density plot
x2 = strideVelFront(:,2)*1.97;
y2 = strideVelFront(:,1)*1.97;

x3 = strideVelRear(:,2)*1.97;
y3 = strideVelRear(:,1)*1.97;

figure(3)
densityplot(x2,y2, [20, 20])
ylim([0 150])
title('Front Paws')
xlabel('Walking Speed (mm/s)')
ylabel('Stride Count')
% xlim([0 17])
hold on

densityplot(x3,y3, [20, 20])
ylim([0 150])
title('Rear Paws')
xlabel('Walking Speed (mm/s)')
ylabel('Stride Count')
% xlim([0 17])



%% Histogram (Density Plot)
histfit(y)
xlabel('Stride Length')
ylabel('Stride Count')
% ylim([0 50])
xlim([0 150])
title('Wild Type Mice')


%%
histfit(x,20)
xlabel('Walking Speed (mm/s)')
ylabel('Stride Count')
% ylim([0 50])
xlim([0 17])
title('Wild Type Mice')