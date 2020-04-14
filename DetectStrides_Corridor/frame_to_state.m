% Written by John D'Uva (April 2020).
% Go through each frame and check if it is between min->max 
% (implying a state of swing) or max->min (implying a state of stance).

function [swing_frames, stance_frames] = frame_to_state(preX, minpkx, maxpkx, numLimbs)

for j=1:numLimbs % for each limb...

    for frame = 1:length(preX)
        stanceIDX = 1;
        swingIDX = 1;
        % if: current frameIDX less than index of first minima, 
        %     AND current frameIDX less than index of first maxima, 
        %     AND the first min is less than the first max
        if frame < minpkx{1,j}(1,1) ...
                && frame < maxpkx{1,j}(1,1) ...
                && minpkx{1,j}(1,1) < maxpkx{1,j}(1,1)
            % then that frame is a stance 
            stance_frames{j}(stanceIDX) = {frame};
            stanceIDX = stanceIDX + 1;

        elseif frame < minpkx{1,j}(1,1) ...
                && frame < maxpkx{1,j}(1,1)...
                && minpkx{1,j}(1,1) > maxpkx{1,j}(1,1) % first max is less than the first min
            % then that frame is a swing
            swing_frames{j}(swingIDX) = [swing_frames frame]; 
            swingIDX = swingIDX + 1;
        end
    end
end
end

%%
for n = 1:size(diff_data)-1
          
    if (x_zero_diff{j}(first) > swing_slope & x_zero_diff{j}(range_threshold) > swing_slope)
        new_swing_points{j}(n) = first;
        break;
    else
        new_swing_points{j}(n) = minpkx{j}(n,1);
    end






        % if we've arrived at the first instance of a min or max...
        elseif frame >= min( minpkx{1,j}(1,1), maxpkx{1,j}(1,1) )
            % keep track of min/max index
            minIndex = 1; 
            maxIndex = 1; 

            % then determine if frame between min->max or max->min
            % MIN:
            if (frame > minpkx{1,j}(minIndex,1))  &&  (frame <= maxpkx{1,j}(maxIndex,1))
                % then that frame is a swing
                swing_frames = [swing_frames + frame]; 
                % if we've reached the max, then update minIndex
                if frame == maxpkx{1,j}(maxIndex,1)
                    minIndex = minIndex + 1;
                end

            % MAX:
            elseif (frame < minpkx{1,j}(minIndex,1))  &&  (frame >= maxpkx{1,j}(maxIndex,1)
                % then that frame is a stance
                stance_frames = [stance_frames + frame]; 
                % if we've reached the next min, then update maxIndex
                if frame == minpkx{1,j}(minIndex,1)
                    maxIndex = maxIndex + 1;
                end
            end

        end
    end
end