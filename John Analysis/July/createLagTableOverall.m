%% Create table 'LagTableOverall' to get lag for each mouse and average lag for each phenotype

% ASD_all, phenos, or Cntnap2_all
pORa = Cntnap2_all; 
% Het(1), Homo(2), or Neg(3)
phe = 3;
% Make sure using correct phenotype
disp(length(pORa{1,phe}(1,:)))

% an = 3; 
day = 1; Fs = 80;
temp = [];
for an = 1:length(pORa{1,phe}(1,:))
    allPaws = permute( correctedTens5{pORa{phe}(1,an),day}([5,6,9,10], : , :), [2 1 3]);
    % RTfront = squeeze(allPaws(2,1,:));
    % LFrear = squeeze(allPaws(2,4,:));
    % paws = [ RTfront, LFrear ];
    LFfront = squeeze(allPaws(2,2,:));
    RTrear = squeeze(allPaws(2,3,:));
    paws = [ LFfront, RTrear ];

    % Cross correlation between limbs
    slot = (1:length(paws));
    [c, lags] = xcorr(paws(slot,1), paws(slot,2));
    c = c/max(c);
    [m,i] = max(c);
    t = lags(i);
    temp = [temp; t];
end