% Written by John D'Uva (April 2020).
% Go through each frame and check if it is between min->max 
% (implying a state of swing) or max->min (implying a state of stance).
function [swing_frames, stance_frames] = frame_to_state(preX, minpkx, maxpkx, numLimbs)
    for j=1:numLimbs % for each limb...
        %stance_frames = {}; swing_frames = {};
        stanceIDX = 1;swingIDX = 1;
        minIndex = 1; maxIndex = 1;
        for frame = 1:length(preX)
            % if: current frameIDX less than index of first minima, 
            %     AND current frameIDX less than index of first maxima, 
            %     AND the first min is less than the first max
            if frame <= minpkx{1,j}(1,1) ...
                    && frame <= maxpkx{1,j}(1,1) ...
                    && minpkx{1,j}(1,1) < maxpkx{1,j}(1,1)
                % then that frame is a stance 
                stance_frames{j}(stanceIDX) = frame;
                stanceIDX = stanceIDX + 1;

            elseif frame <= minpkx{1,j}(1,1) ...
                    && frame <= maxpkx{1,j}(1,1)...
                    && minpkx{1,j}(1,1) > maxpkx{1,j}(1,1) % first max is less than the first min
                % then that frame is a swing
                swing_frames{j}(swingIDX) = frame;
                swingIDX = swingIDX + 1;


            % if we're above the first instance of min or max...
            elseif frame >= min( minpkx{1,j}(1,1), maxpkx{1,j}(1,1) )
                % then determine if frame between min->max or max->min

                % MIN:
                if frame > minpkx{1,j}(minIndex,1)  &&  frame <= maxpkx{1,j}(maxIndex,1)
                    % then that frame is a swing
                    swing_frames{j}(swingIDX) = frame;
                    swingIDX = swingIDX + 1;
                    % if we've reached the max, then update minIndex
                    if frame == maxpkx{1,j}(maxIndex,1)
                        minIndex = minIndex + 1;
                    end

                % MAX:
                elseif frame <= minpkx{1,j}(minIndex,1)  &&  frame > maxpkx{1,j}(maxIndex,1)
                    % then that frame is a stance
                    stance_frames{j}(stanceIDX) = frame;
                    stanceIDX = stanceIDX + 1;
                    % if we've reached the next min, then update maxIndex
                    if frame == minpkx{1,j}(minIndex,1)
                        maxIndex = maxIndex + 1;
                    end
                    
                else
                    continue
                end

            end
        end
    end
end

% include 17 on first stance