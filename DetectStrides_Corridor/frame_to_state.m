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
        minIndex = 1; % frame=17 right now...
        maxIndex = 1; % frame=26 right now...
        % then determine if frame between min->max or max->min
        if (frame > minpkx{1,j}(minIndex,1))  &&  (frame < maxpkx{1,j}(maxIndex,1))
            % it's swinging
            swing_frames = [swing_frames + frame]; 
        end
                %add frame to swing array
                stance_frames = [stance_frames + frame];
            else 
                swing_frames = [swing_frames + frame];
            end
        end
        
    end
    
            
end       
            
        
    
    for index = 1:length(minpkx{1,j})    
            
            
        % if frame > 1 % frame <= 17
        if frame >= 1 && frame < minpkx{1,j}(index,1) 
            stance_frames = [stance_frames + frame];
        % if frame >= 17 and frame < 26
        elseif frame >= minpkx{1,j}(index,frame) && frame < maxpkx{1,j}(maximaIDX,1)
            
            
            
            < minpkx{1,j}(minimaIDX,1) 
            stance_frames = [stance_frames + frame];
        else if minpkx{1,j}(frame,1) <= frames  < maxpkx{1,j}(1,1)
            %then frame == swing
        swing_frames = [swing_frames + frame];
        
        end
    end
    end
    end
end

% 
if expression
    statements
elseif expression
    statements
else
    statements
end