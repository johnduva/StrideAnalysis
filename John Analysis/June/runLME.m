%% Run L.inear M.ixed E.fects models on 'fullTbl' matrix of StrideLength, Speed, Weight, Pheno, and Animal

lme1 = fitlme(fullTbl,'StrideLength ~ Speed + (1+Speed|Animal)');
lme2 = fitlme(fullTbl,'StrideLength ~ Speed + Weight + (1+Speed|Animal)');
lme3 = fitlme(fullTbl,'StrideLength ~ Speed + Weight + Pheno + (1+Speed|Animal)');

lme4 = fitlme(fullTbl,'LogStrideLength ~ LogSpeed + Weight + (1+Speed|Animal)');


%% Comapre models using Theoretical Likelihood Ratio Test
% Significant pVals imply better models
compare(lme1,lme2)
compare(lme2,lme3)

%%
F = fitted(lme3);
R = response(lme3);
figure();
scatter(R,F,1,'rx')
xlabel('Response')
ylabel('Fitted')

% plot both residuals, and real prediction with the data