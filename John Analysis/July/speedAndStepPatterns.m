
velTscHet_HIGH = [];
velTscHet_MED = [];
velTscHet_LOW = [];
velTscHet_ZERO = [];

% Options: velC57, velTscHet, or velCntnap
vel = velTscHet;
% Get the thresholds for animal velocities:
quant = quantile(vel,[0 0.25 0.50 0.75 1]);
% Start the counters at 1 to keep track of each one individually:
countHIGH = 1; countMED = 1; countLOW = 1; countZERO = 1;
% Create two-column vectors (index, velocity) for HIGH, MED...
for i = 1 : length(vel)
    if vel(i) >= quant(4)
        velTscHet_HIGH = [velTscHet_HIGH; [i, vel(i)]];
        countHIGH = countHIGH + 1;
    elseif vel(i) < quant(4) && vel(i) > quant(3)
        velTscHet_MED = [velTscHet_MED; [i, vel(i)]];
        countMED = countMED + 1;
    elseif vel(i) < quant(3) && vel(i) > quant(2)
        velTscHet_LOW = [velTscHet_LOW; [i, vel(i)]];
        countLOW = countLOW + 1;
    else %if vel(i) < quant(2) 
        velTscHet_ZERO = [velTscHet_ZERO; [i, vel(i)]];
        countZERO = countZERO + 1;
    end
end

% Cross correlation between limbs
% slot = velTscHet_ZERO(:,1);
slot = (1:length(paws));
[c, lags] = xcorr(paws(slot,1), paws(slot,2));
c = c/max(c);
[m,i] = max(c);
t = lags(i)

% The C57s will have 0 lag at all speeds.
% We want to know if the mice with lags have altered lags at different speeds


% Plot signals only during periods of high animal velocity
plot(zscore( paws(velTscHet_HIGH(:,1),1 )), 'red')
hold on
plot(zscore( paws(velTscHet_HIGH(:,1),2 )), 'blue')
hold on 
plot(velTscHet_HIGH(:,2)*10)

