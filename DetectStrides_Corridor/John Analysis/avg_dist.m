% reminder: label right paw and left on the figur
% how fast they walk (avg speed)
% figure 3 and 5 in 2019 paper
%     sqrt( (x-x)^2 + (y-y)^2 )
%    (x2-x1)

%% Average Stance Width Calculation
% For each animal, what is the average horizontal distance between
% their front paws? Then, what is the average distance for all lobVI1D
% animals combined?
phe = 1;
counter = 0;
dist = 0;
for an = 1:length(ASD_all{1,phe}(1,:)) % for each animal in the first row of LobVI1D_ans
    for day = 1:length( correctedTens2(ASD_all{phe}(1,an) , :) ) % correctedTens2(198,:) 
        for frame = 1:length(    correctedTens2{ASD_all{phe}(1,an),day}(3)      )
            dist = dist + abs(correctedTens{pheno(1,an),day}(5,1,frame) - correctedTens{pheno(1,an),day}(6,1,frame));
            counter = counter + 1;
        end
    end
    pheno(2,an) = dist / counter;
end
pheno(3,1) = dist / counter;
Vehicle2D = pheno;
clear('pheno');

%% Average Stride Length Calculation
% For each animal, what is the average vertical distance between
% each paw's maxpeak and minpeak? Then, what is the average distance for 
% all animals of that phenotype combined?

% 5: Left Front
% 6: Right Front
% 9: Left Rear
% 10: Right Rear

pheno = TscNeg;
counter = 0;
dist = 0;
for an = 1:length(pheno)
    for day = 1:length({correctedTens{pheno(1,an),:}})
        allPaws = permute(correctedTens{pheno(1,an)}([5,6,9,10],:,:), [2 1 3]);
        Fs = 80;
        numLimbs = size(allPaws, 2);
        frames = (1:size(allPaws,3))';
        % x-values for all paws
        preX = squeeze(allPaws(1,:,:))';
         % For each paw, calculate which frames are peaks/valleys
         for limb = 1:numLimbs 
            [maxpkx{limb}, minpkx{limb}] = peakdet(preX(:,limb), 3); 
            %Do not consider first peak if frame of first peak < 1
            if maxpkx{limb}(1,1) <= 5
                maxpkx{limb} = cat(2,maxpkx{limb}(2:end,1), maxpkx{limb}(2:end,2));
            end
            if minpkx{limb}(1,1)<=5
                minpkx{limb} = cat(2,minpkx{limb}(2:end,1), minpkx{limb}(2:end,2));
            end
         end
         
        % For each paw, organize frames into states of stance or swing
        [stance_frames, swing_frames]  =  frame_to_state(preX, minpkx, maxpkx, numLimbs);
        
        % for each limb...
        for j = 1:numLimbs
            % calculate avg stride dist
            dist = 0;
            % if the first min/max is a valley...
            if minpkx{j}(1,1) < maxpkx{j}(1,1)
                for i = 1: length(maxpkx{1,1})-2
                    dist = dist + maxpkx{1,1}(i,2) - minpkx{1,1}(i,2);
                end
                
            % if the first instance is a peak
            else % minpkx{j}(1,1) >= maxpkx{j}(1,1)
                for i = 1: length(minpkx{1,1})-2
                    % skip the first peak
                    dist = dist + maxpkx{1,1}(i+1,2) - minpkx{1,1}(i,2);
                end
            end
            
            % add the average stride length to the pheno's spreadsheet
            pheno(3+j,an) = dist / (length(minpkx{1,1})-1);
        end        
    end
    disp(an);
end

TscNeg = pheno;
clear('pheno');



%% Save out files
save('phenos.mat', 'C57Bl_ans', 'CNOonly2D_ans', ...
     'CrusILT2D_ans', 'CrusIRT2D_ans', 'JuvCNOonly_ans',...
     'JuvCrusI_ans', 'JuvLobVI_ans','LobVI1D_ans', 'Vehicle2D')

% phenos = {C57Bl_ans, CNOonly2D_ans, CrusILT2D_ans, CrusIRT2D_ans, JuvCNOonly_ans,JuvCrusI_ans, JuvLobVI_ans,LobVI1D_ans, Vehicle2D};
%            1               2            3              4               5              6               7         8             9   

ASD_all = {TscHet, TscHomo, TscNeg };
save('ASD_all.mat', 'ASD_all')


%% calculate each row's average stride length
for pheno = 1:3
    for row = 4:7
        % loop through each phenotype's spreadsheet
        for pheno = 1:length(ASD_all)
            sum = 0;
            for avg = 1:length(ASD_all{pheno}(row,:))
                % get the average for each row (paw)
                sum = sum + ASD_all{pheno}(row,avg);
            end
            ASD_all{pheno}(row+4,1) = sum / length(ASD_all{pheno}(row,:));
        end
    end
end
disp('Finished running.')
