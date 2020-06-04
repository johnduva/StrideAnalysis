% Run an anova and do posthoc analysis

y = padcat(phenos{1,1}(4,:)'*1.97, ...
    ASD_all{1,1}(4,:)'*1.97,...
    ASD_all{1,2}(4,:)'*1.97,...
    ASD_all{1,3}(4,:)'*1.97);
% bar(x, [phenos{1,1}(8,1), ASD_all{1,1}(8,1), ASD_all{1,2}(8,1), ASD_all{1,3}(8,1)] * 1.97);
x = categorical({'C57Bl (n=60)','Tsc1 Het (n=17)','Tsc1 Homo (n=9)','Tsc1 Neg (n=17)'});
[p,t,stats] = anova1(y,x);
[c,m,h,nms] = multcompare(stats, 'CType','tukey-kramer');

ylabel('Stride Length (mm)','FontSize', 18)
title('C57Bl vs Tsc1 Strains', 'FontSize', 18)



