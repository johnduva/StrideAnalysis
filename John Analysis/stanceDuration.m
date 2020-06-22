% clearvars -except allPaws allTracks an keepersOnly correctedTens5 phe phenos PointColors

pORa = phenos;
Fs = 80;
phe = 1; % C57Bl 
stanceDurFinal = zeros(1, 2);
stanceDurFront = zeros(1, 2);
stanceDurRear = zeros(1, 2);
for an = 1:1 %length(ASD_all{1,1}(1,:)) % for each animal in the first row of LobVI1D_ans
    for day = 1:4%length( correctedTens5(pORa{phe}(1,an) , :) ) % correctedTens2(198,:) 
                                  % correctedTens{phenos{1}(1,198), 1}  (4limbs, all xy coords, all frames
        allPaws = permute( correctedTens5{pORa{phe}(1,an),day}([5,6,9,10], : , :), [2 1 3]);
        % OR allPaws = permute( correctedTens5{ASD_all{phe}(1,an),day}([5,6,9,10], : , :), [2 1 3]);
        numLimbs = size(allPaws, 2);
        frames = (1:size(allPaws,3))';
        % x-values for all paws
        preX = squeeze(allPaws(2,:,:))';
        
        % For each paw, calculate which frames are peaks/valleys
        for k = 1:numLimbs 
            [maxpkx{k}, minpkx{k}] = peakdet(preX(:,k), 11); 
            %Do not consider first peak if frame of first peak < 1
            if maxpkx{k}(1,1) <= 5
                maxpkx{k} = cat(2,maxpkx{k}(2:end,1), maxpkx{k}(2:end,2));
            end
            if minpkx{k}(1,1)<=5
                minpkx{k} = cat(2,minpkx{k}(2:end,1), minpkx{k}(2:end,2));
            end
        end
        
        index = 1;
        for frame = 1: length(allTracks{pORa{phe}(1,an),day})
            if ismember(frame, keepersOnly{pORa{phe}(1,an),day})
                centroidsF2(index,1) = allTracks{pORa{phe}(1,an),day}(frame,1); 
                centroidsF2(index,2) = allTracks{pORa{phe}(1,an),day}(frame,2);
                index = index + 1;
            end
        end

        % get change in x-coordinate per frame (negative just means a change to the left)
        vx = gradient(centroidsF2(:,1));
        % get the change in y-coordinate per frame
        vy = gradient(centroidsF2(:,2));
        % velocity 
        vel = ((sqrt(vx.^2 + vy.^2)));
        clear vx vy;
        vel = fillmissing(vel,'linear');
        vel = movmedian(vel,Fs/2);
        
        
        % make scatterplot: swing velocity vs speed:
        colors = {'r','r','k','k'};
        for k = 1:numLimbs
            % zeros(641,2)
            stanceDur = zeros( size(maxpkx{1,k},1), 2); 
            % if index of first min < index of first max...
            if minpkx{1,k}(1,1) <= maxpkx{1,k}(1,1)
                for i = 1:size(maxpkx{1, k},1)-1
                    % calculate number of frames between max and next min
                    stanceDur(i,1) = minpkx{1,k}(i+1,1) - maxpkx{1,k}(i,1);
                    % mean centroid velocity during that stride
                    stanceDur(i,2) = mean( vel(minpkx{1,k}(i,1) : maxpkx{1,k}(i,1), 1));
                end
            % if the first max < first min
            else % minpkx{1,k}(1,1) > maxpkx{1,k}(1,1)
               for i = 1:size(maxpkx{1, k},1)-1
                    % calculate y-pixels traveled per frame (mm/sec)
                    stanceDur(i,1) = minpkx{1,k}(i,1) - maxpkx{1,k}(i,1);
                    % mean centroid velocity during that stride
                    stanceDur(i,2) = mean( vel(minpkx{1,k}(i,1) : maxpkx{1,k}(i+1,1), 1));
               end 
            end
            
            stanceDurFinal = [stanceDurFinal; stanceDur];
            
            if k == 1 || 2
                stanceDurFront = [stanceDurFront; stanceDur];
            else % k = 3 || 4
                stanceDurRear = [stanceDurRear; stanceDur];
            end
                
            figure(3)
            xNow = stanceDur(:,2)*1.97;
            yNow = stanceDur(:,1)*1.97;
            scatter( xNow, yNow, 1, colors{k}, '+')
            hold all
        end
    end
end

x = stanceDurFinal(:,2)*1.97;
y = stanceDurFinal(:,1)*1.97;