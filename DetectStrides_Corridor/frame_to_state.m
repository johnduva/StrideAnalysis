% written by John D'Uva (April 2020)
j=1; 
swing_frames = []; stance_frames = [];

% go through each frame and check if b/t min->max (swing) or max->min (stance)
% but first handle beginning edge cases before first min/max occur

for frame = 1:length(preX)
    % if: current frameIDX less than index of first minima, 
    %     AND current frameIDX less than index of first maxima, 
    %     AND the first min is less than the first max
    if (frame < minpkx{1,j}(1,1)) ...
            && (frame < maxpkx{1,j}(1,1)) ...
            && (minpkx{1,j}(1,1) < maxpkx{1,j}(1,1))
        % then that frame is a stance 
        stance_frames = [stance_frames + frame];
        
    elseif (frame < minpkx{1,j}(1,1)) ...
            && (frame < maxpkx{1,j}(1,1))...
            && (minpkx{1,j}(1,1) > maxpkx{1,j}(1,1)) % first max is less than the first min
        % then that frame is a swing
        swing_frames = [swing_frames + frame]; 
    
        
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
        
    % do we need an edge case at the end?
    else
end