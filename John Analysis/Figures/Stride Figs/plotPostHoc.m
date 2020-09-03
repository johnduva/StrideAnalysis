% Create error bars after you're done with ANOVA post hoc

index = 1;
x = categorical({''});
y = [];
neg = [];
pos = [];
pIDx = [];
for i = 1: length(c(:,4))
    if c(i,6) < .05
       x(index) = c(i,1) + " vs " + c(i,2);
       y(index) = c(i,4);
       neg(index) = c(i,4) - c(i,3);
       pos(index) = c(i,5) - c(i,4);
       pIDx(index) = c(i,6);
       index = index + 1;
    end
end

errorbar(x,y,neg,pos, 'o') 
xlim([0 5])
ylim([-8 10])
ylabel('Group Means (and 95% CI')
title('ANOVA Post Hoc: ASD Mice')
% Draws a vertical error bar at each data point, where neg determines the
% length below the data point and pos determines the length above the data
% point, respectively.