RT = squeeze(RT_flipped)';
LT = squeeze(LF_flipped)';
paws = [RT(:,1),LT(:,1)];
plot(paws)

Xs(:,j) = smooth( inpaint_nans( preX(:,j),4),1); % Filtering and Interpolation of NaNs values

colors={'r','b'};
for n = 1:2
    plot(paws(:,n),'color',colors{n}); hold on; 
    
    [stance_pts{n}, swing_pts{n}] = peakdet(paws(:,n), 3);% if including index on x
    
    plot(stance_pts{n}(:,1),stance_pts{n}(:,2),'mo')
    plot(swing_pts{n}(:,1),swing_pts{n}(:,2),'gs'); hold on;

    
end