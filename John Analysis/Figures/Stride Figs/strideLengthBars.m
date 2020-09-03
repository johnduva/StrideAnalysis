% Run an ANOVA and do post hoc analysis
x = categorical({'C57Bl (n=60)', 'LobVI1D (n=10)','CNOonly2D (n=12)', 'CrusILT2D (n=19)', ...
    'CrusIRT2D (n=19)', 'JuvCNOonly (n=16)', 'JuvCrusI (n=11)', 'JuvLobVI (n=19)'});

y = padcat(...
    phenos{1,1}(4,:)'*1.97, ...
    phenos{1,8}(4,:)'*1.97,...
    phenos{1,2}(4,:)'*1.97,...
    phenos{1,3}(4,:)'*1.97,...
    phenos{1,4}(4,:)'*1.97,...
    phenos{1,5}(4,:)'*1.97,...
    phenos{1,6}(4,:)'*1.97,...
    phenos{1,7}(4,:)'*1.97);

[p,t,stats] = anova1(y,x);
% [c,m,h,nms] = multcompare(stats, 'CType','tukey-kramer');
ylim([15 45])
ylabel('Stride Length (mm)','FontSize', 18)
title('Stride Length: C57Bl vs Experimental Groups', 'FontSize', 18)

%%
% T-tests that we're no longer using

% %% CNOonly2D vs CrusILT2D vs CrusIRT2D vs Vehicle2D
% x = categorical({''});
% bar(x, [phenos{1,2}(8,1), phenos{1,3}(8,1), phenos{1,4}(8,1), phenos{1,9}(8,1)] * 1.97)
% ylim([30 37])
% ylabel('Stride Length (millimeters)','FontSize', 18)
% title('CNOonly2D vs CrusILT2D vs CrusIRT2D vs Vehicle', 'FontSize', 18)
% saveas(gcf,'stride_CnoCrusLR.png')
% % [h,p] = ttest2(phenos{1,2}(4,:), phenos{1,3}(4,:), 'Vartype','unequal') % p = 0.7768
% % [h,p] = ttest2(phenos{1,2}(4,:), phenos{1,4}(4,:), 'Vartype','unequal') % p = 0.4095
% % [h,p] = ttest2(phenos{1,2}(4,:), phenos{1,9}(4,:), 'Vartype','unequal') % p = 0.6021
% 
% 
% %% JuvCNOonly vs JuvCrusI vs JuvLobVI
% 
% bar(x, [phenos{1,5}(8,1), phenos{1,6}(8,1), phenos{1,7}(8,1)] * 1.97)
% ylim([30 37])
% ylabel('Stride Length (millimeters)','FontSize', 18)
% title('JuvCNOonly vs JuvCrusI vs JuvLobVI', 'FontSize', 18)
% saveas(gcf,'stride_JuvCrusLob.png')
% % [h,p] = ttest2(phenos{1,5}(4,:), phenos{1,6}(4,:), 'Vartype','unequal') % p =  0.7309
% % [h,p] = ttest2(phenos{1,5}(4,:), phenos{1,7}(4,:), 'Vartype','unequal') % p =  0.2765
% 
