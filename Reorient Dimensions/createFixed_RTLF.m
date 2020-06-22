
% sz = size(positions_pred_by_day);
load('/Users/johnduva/Desktop/mkislin Files/M26_190607_g0_t0.imec0.sLEAPout_LFrpaw.mat');
load('/Users/johnduva/Desktop/mkislin Files/M26_190607_g0_t0.imec0.sLEAPout_RFrpaw.mat');
% for x = 1:sz(1) % num of rows in positions_pred_by_day (382)
%     for y = 1:sz(2) % num of columns in positions_pred_by_day (5)
%     an,x,-an,y = positions_pred_by_day(x,y)
%     
%     end
% end

%input = positions_pred_by_day{1,1}(:,:,1:1000); % first 1000 frames (first elem in p_p_b_d)

%for x=1:size(input(2))/2
    input =  LFrpaw %, LFrpaw];


for x=1:length(input)
    input(:,3,:) = NaN;
end

input = input(21000:24500,:,:);

RFrpaw = permute(reshape(input, 3, 3501, 1), [1 3 2]);
% mikhails data:
RFrpaw = permute(input, [2 1 3]);


%end