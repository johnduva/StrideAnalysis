

load('/Volumes/wang_mkislin/behdata/2019-06-OFTNeuropixels/M26/M26_190607_g0/M26_190607_g0_imec0/M26_190607_g0_t0.imec0.sLEAPout_LFrpaw.mat');

input = LFrpaw;

for x=1:length(input)
input(x,3) = NaN;
end

input = input(21000:24500,:,:);

input = permute(reshape(input', 3, 3501, 1), [1 3 2]);

LFrpaw = input;

front_paws = [LFrpaw, RFrpaw];