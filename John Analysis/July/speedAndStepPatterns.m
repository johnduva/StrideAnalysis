%% Create a table of HIGH, MED, LOW, ZERO values (one for a mouse of each phenotype)
% Columns are phenotypes, rows are degree (HIGH, MED...)

clear allPaws paws centroidsF2
% ASD_all, phenos, or Cntnap2_all
pORa = Cntnap2_all; 
% Het(1), Homo(2), or Neg(3)
phe = 3;
% Make sure using correct phenotype
disp(length(pORa{1,phe}(1,:)))

an = 1; day = 1; 
allPaws = permute( correctedTens5{pORa{phe}(1,an),day}([5,6,9,10], : , :), [2 1 3]);
% RTfront = squeeze(allPaws(2,1,:));
% LFrear = squeeze(allPaws(2,4,:));
% paws = [ RTfront, LFrear ];
LFfront = squeeze(allPaws(2,2,:));
RTrear = squeeze(allPaws(2,3,:));
paws = [ LFfront, RTrear ];

% Get CentroidsF2
index = 1;
for frame = 1: length(allTracks{pORa{phe}(1,an),day})
    if ismember(frame, keepersOnly{pORa{phe}(1,an),day}) % && frame == blank + 1
        centroidsF2(index,1) = allTracks{pORa{phe}(1,an),day}(frame,1); 
        centroidsF2(index,2) = allTracks{pORa{phe}(1,an),day}(frame,2);
        index = index + 1;
    end
end
% Get change in x-coordinate per frame (negative just means a change to the left):
vx = gradient(centroidsF2(:,1));
% Get the change in y-coordinate per frame:
vy = gradient(centroidsF2(:,2));
% velocity :
vel = ((sqrt(vx.^2 + vy.^2)));
vel = fillmissing(vel,'linear');
vel = movmedian(vel,Fs/2);
% from pixels per frame to 
%          mm per second
velCntnapNeg = vel * 80 * .51 / 1000;
clear vel vx vy

velCntnapNeg_HIGH = [];
velCntnapNeg_MED = [];
velCntnapNeg_LOW = [];
velCntnapNeg_ZERO = [];

% Set equal to line 40 variable
vel = velCntnapNeg;
% Get the thresholds for animal velocities:
quant = quantile(vel,[0 0.25 0.50 0.75 1]);
% Start the counters at 1 to keep track of each one individually:
countHIGH = 1; countMED = 1; countLOW = 1; countZERO = 1;
% Create two-column vectors (index, velocity) for HIGH, MED...
for i = 1 : length(vel)
    if vel(i) >= quant(4)
        velCntnapNeg_HIGH = [velCntnapNeg_HIGH; [i, vel(i)]];
        countHIGH = countHIGH + 1;
    elseif vel(i) < quant(4) && vel(i) > quant(3)
        velCntnapNeg_MED = [velCntnapNeg_MED; [i, vel(i)]];
        countMED = countMED + 1;
    elseif vel(i) < quant(3) && vel(i) > quant(2)
        velCntnapNeg_LOW = [velCntnapNeg_LOW; [i, vel(i)]];
        countLOW = countLOW + 1;
    else %if vel(i) < quant(2) 
        velCntnapNeg_ZERO = [velCntnapNeg_ZERO; [i, vel(i)]];
        countZERO = countZERO + 1;
    end
end

%% Cross correlation between limbs
slot = velCntnapNeg_ZERO(:,1);
% slot = (1:length(paws));
[c, lags] = xcorr(paws(slot,1), paws(slot,2));
c = c/max(c);
[m,i] = max(c);
t = lags(i)

% The CntnapNegs will have 0 lag at all speeds.
% We want to know if the mice with lags have altered lags at different speeds


%% Plot signals only during periods of high animal velocity
plot(zscore( paws(velCntnapNeg_ZERO(:,1),1 )), 'red')
hold on
plot(zscore( paws(velCntnapNeg_ZERO(:,1),2 )), 'blue')
hold on 
plot(velCntnapNeg_ZERO(:,2)*10)

