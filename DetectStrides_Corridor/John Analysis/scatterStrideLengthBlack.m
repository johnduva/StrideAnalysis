% [1:8 12:16 18];
% 1 2 3 4 5 6 7 8 12 13 
%         5 6      9 10 
% ALREADY PULLING FROM SET OF 14

Fs = 80;
% start with C57Bl
phe = 1; 
% Calculate body velocity from centroid coordinates:
strideVelFinal = zeros(1, 2);
for an = 1:length(ASD_all{1,phe}(1,:)) % for each animal in the first row of LobVI1D_ans
    for day = 1: 4% length( correctedTens2(ASD_all{phe}(1,an) , :) ) % correctedTens2(198,:) 
                                  % correctedTens{phenos{1}(1,198), 1}  (4limbs, all xy coords, all frames
        allPaws = permute( correctedTens{phenos{phe}(1,an),day}([5,6,9,10], : , :), [2 1 3]);
        numLimbs = size(allPaws, 2);
        frames = (1:size(allPaws,3))';
        % x-values for all paws
        preX = squeeze(allPaws(1,:,:))';
        % For each paw, calculate which frames are peaks/valleys
        for limb = 1:numLimbs 
            [maxpkx{limb}, minpkx{limb}] = peakdet(preX(:,limb), 25); 
            %Do not consider first peak if frame of first peak < 1
            if maxpkx{limb}(1,1) <= 5
                maxpkx{limb} = cat(2,maxpkx{limb}(2:end,1), maxpkx{limb}(2:end,2));
            end
            if minpkx{limb}(1,1)<=5
                minpkx{limb} = cat(2,minpkx{limb}(2:end,1), minpkx{limb}(2:end,2));
            end
        end
        
        
        
        
        index = 1;
        for frame = 1: length(allTracks{ASD_all{phe}(1,an),day})
            if ismember(frame, keepersOnly{ASD_all{phe}(1,an),day})
                centroidsF2(index,1) = allTracks{ASD_all{phe}(1,an),day}(frame,1); 
                centroidsF2(index,2) = allTracks{ASD_all{phe}(1,an),day}(frame,2);
                index = index + 1;
            end
        end

        % get change in x-coordinate per frame (negative just means a change to the left)
        vx = gradient(centroidsF2(:,1));
        % get the change in y-coordinate per frame
        vy = gradient(centroidsF2(:,2));
        % velocity 
        vel = ((sqrt(vx.^2 + vy.^2)));
        vel = fillmissing(vel,'linear');
        vel = movmedian(vel,Fs/2);
        vel = 

        % make scatterplot: stride length vs velocity:
        colors = {[.5 .5 .5],'k','b','c'};
        for k = 1:numLimbs
                       % zeros(641,2)
            strideVel = zeros( size(maxpkx{1,k},1), 2); 
            % if the first min < first max
            if minpkx{1,k}(1,1) <= maxpkx{1,k}(1,1)
                for i = 1:size(maxpkx{1, k},1)-1
                    % stride length (max - min)
                    strideVel(i,1) = maxpkx{1,k}(i,1) - minpkx{1,k}(i,1);
                    % mean centroid velocity during that stride
                    strideVel(i,2) = mean( vel(minpkx{1,k}(i,1) : maxpkx{1,k}(i,1), 1));
                end
                
            % if the first max < first min
            else % minpkx{1,k}(1,1) > maxpkx{1,k}(1,1)
               for i = 1:size(maxpkx{1, k},1)-1
                    % stride length (max - min)
                    strideVel(i,1) = maxpkx{1,k}(i+1,1) - minpkx{1,k}(i,1);
                    % mean centroid velocity during that stride
                    strideVel(i,2) = mean( vel(minpkx{1,k}(i,1) : maxpkx{1,k}(i+1,1), 1));
               end
            end
%             strideVelFinal = zeros(1, 2); at beginning
            strideVelFinal = [strideVelFinal; strideVel];
        end
    end
end
%%
scatter( strideVelFinal(:,2)/1.97,  strideVelFinal(:,1)/1.97,  10,  'k',  'filled');
% lsline
% legend('Left Front', 'Right Front','Left Rear', 'Right Rear');
legend('All Paws')
ylabel('Stride length (mm)');
xlabel('Speed (mm/sec)');
ylim([0 100]);
xlim([0 4.5]);
title('Tsc Negative (n=9)');
hold all;  

R = corrcoef(strideVelFinal(:,2)/1.97,  strideVelFinal(:,1)/1.97)

% tbl = table(strideVel(:,2)/1.97, strideVel(:,1)/1.97);
% mdl = fitlm(tbl);
% plot(mdl);

% saveas(getfig, 'plotCNOonlyStride.png')

