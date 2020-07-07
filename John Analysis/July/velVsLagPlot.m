%% Create plot of avg velocity vs. xcorr lag per stride phase

% ASD_all, phenos, or Cntnap2_all
pORa = phenos; 
% Het(1), Homo(2), or Neg(3)
phe = 1;

an = 1; day = 1; 
allPaws = permute( correctedTens5{pORa{phe}(1,an),day}([5,6,9,10], : , :), [2 1 3]);
paws = [ zscore(squeeze(allPaws(2,2,:))), zscore(squeeze(allPaws(2,3,:))) ];

% Get the minpeaks so we can consider each 2π phase
for k = 1:2
    [max, maxIndex] = findpeaks(paws(:,k),'MinPeakDistance', 9);
    maxpkx{k} = [maxIndex, max];
    clear maxpksIndex maxpks
    
    [min, minIndex] = findpeaks(-paws(:,k),'MinPeakDistance', 9);
    minpkx{k} = [minIndex, -min];
    clear minpksIndex minpks 
end
    
% maxpkx{1,1}(index)
% [r, lags] = xcorr(  maxpkx{1,1}(1:10,1), maxpkx{1,2}(1:10,1)  )

% Get the cross correlation of the y-values from maxpk(i) to maxpk(i+1)
v1 = paws(   maxpkx{1,1}(1,1) : maxpkx{1,1}(2,1)   ,1);
v2 = paws(   maxpkx{1,2}(1,1) : maxpkx{1,2}(2,1)   ,2);
[r, lags]  = xcorr(v1, v2)




%%
figure(2)
findpeaks(paws(:,1),'MinPeakDistance', 11)
hold on
findpeaks(paws(:,2),'MinPeakDistance', 11)


