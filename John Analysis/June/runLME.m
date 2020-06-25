%% Run L.inear M.ixed E.fects models on 'fullTbl' matrix of StrideLength, Speed, Weight, Pheno, and Animal

lme1 = fitlme(fullTbl2,'StrideLength ~ Speed + (1+Speed|Animal)');
lme2 = fitlme(fullTbl2,'StrideLength ~ Speed + Weight + (1+Speed|Animal)');
lme3 = fitlme(fullTbl2,'LogStrideLength ~ LogSpeed + Weight + (1+LogSpeed|Animal)');

%  stride length = a*speed^b f

lme4 = fitlme(fullTbl,'StrideLength ~ Speed + Weight + Pheno + (1+Speed|Animal)');




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


%% Find the best fit/model for the data

% Only use the C57 data
x = fullTbl2.Speed(1:739); 
y = fullTbl2.StrideLength(1:739);
cftool(x,y)

x = fullTbl.Speed(1:819); 
y = fullTbl.StrideLength(1:819);
cftool(x,y)

ypred = predict(lme1);
F = fitted(lme1,'Conditional',false)



