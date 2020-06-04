%% LobVI1DnC57Bl 
x = categorical({'LobVI1D (n=10)', 'C57Bl (n=60)'});
bar(x, [47.165,44.742])
ylim([40 49])
ylabel('Stance Width (millimeters)','FontSize', 18)
title('Stance Width: C57Bl vs LobVI1D', 'FontSize', 18)
saveas(gcf,'LobVI1DnC57Bl.png')
% [h,p] = ttest2(C57Bl_ans(2,:), LobVI1D_ans(2,:), 'Vartype','unequal') % add p=.0112


%% CNOonly2D vs CrusILT2D vs CrusIRT2D vs Vehicle2D
x = categorical({'CNOonly2D (n=12)', 'CrusILT2D (n=19)', 'CrusIRT2D (n=19)', 'Vehicle2D (n=9)'});
bar(x, [23.760, 25.153, 24.923, 25.885] * 1.97)
ylim([40 52])
ylabel('Stance Width (millimeters)','FontSize', 18)
title('Stance Width: CNOonly2D vs CrusILT2D vs CrusIRT2D ', 'FontSize', 18)
saveas(gcf,'CnoCrusLR.png')
% [h,p] = ttest2(CNOonly2D_ans(2,:), CrusILT2D_ans(2,:), 'Vartype','unequal'); % p = 0.00014342
% [h,p] = ttest2(CNOonly2D_ans(2,:), CrusIRT2D_ans(2,:), 'Vartype','unequal'); % p = 0.00015122
[h,p] = ttest2(CNOonly2D_ans(2,:), Vehicle2D(2,:), 'Vartype','unequal'); % p = 0.00000021714


%% JuvCNOonly vs JuvCrusI vs JuvLobVI
x = categorical({'JuvCNOonly (n=16)', 'JuvCrusI (n=11)', 'JuvLobVI (n=19)'});
bar(x, [24.518, 24.837, 24.344] * 1.97)
ylim([40 51])
ylabel('Stance Width (millimeters)','FontSize', 18)
title('Stance Width: JuvCNOonly vs JuvCrusI vs JuvLobVI', 'FontSize', 18)
saveas(gcf,'JuvCrusLob.png')
% [h,p] = ttest2(JuvCNOonly_ans(2,:), JuvCrusI_ans(2,:), 'Vartype','unequal') % p =  0.1473
% [h,p] = ttest2(JuvCNOonly_ans(2,:), JuvLobVI_ans(2,:), 'Vartype','unequal') % p =  0.9315