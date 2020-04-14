% Returns:
%   - Total number of swing seconds ('totalSwingSecs')
%   - Number of stance seconds ('totalStanceSecs')
%   - Proportion of stance to swing seconds ('stanceProportion')
%   - All of the above information across n (10) bins ('stance_tenths')
%       * includes n columns for each bin
%       * Row 1: stance frames
%       * Row 2: num of stance seconds per column (per bin)
%       * Row 3: num of swing seconds per column (per bin)
%       * Row 4: proportion of stance to swing seconds per column (per bin)

function [totalSwingSecs, totalStanceSecs, stancePorportion, stance_tenths] = swingVsStanceSecs(swing_frames, stance_frames, Fs)
    % determine how many seconds are considered a state of swing or stance
    totalSwingSecs = length(swing_frames{1}) / Fs;
    totalStanceSecs = length(stance_frames{1}) / Fs;
    
    % determine proportion of video that animal is in stance state
    totalSecs = totalSwingSecs + totalStanceSecs;
    stancePorportion = totalStanceSecs / totalSecs;
    
    % break it up into time bins to see how swingSecs/stanceSecs change over time
    numIncrements = 10;
    incrementSize = floor((length(swing_frames{1})+length(stance_frames{1})) / numIncrements); %350
    full = incrementSize * numIncrements; %3,500
    stance_tenths = cell(1,numIncrements);
    
    % 1 through 3,500
    for frame = 1:full 
        % check if current frame is NOT a stance frame
        if ~ismember(frame, stance_frames{1})
            continue
        
        % now that you know it is a stance frame...
        else
            % 1st increment (1 through 350)
            if frame <= (incrementSize * 1) 
                if frame == 1
                    stance_tenths{1} = {frame};        
                else
                    stance_tenths{1} = [stance_tenths{1}, frame];        
                end
                
            
            else % if frame > 350...
                for inc = 2:numIncrements
                    if  (incrementSize * (inc-1) < frame) && (frame <= incrementSize * inc)
                        if (frame == incrementSize * (inc-1)+1) 
                            stance_tenths{inc} = {frame};
                        else
                            stance_tenths{inc} = [stance_tenths{inc}, frame];
                        end

                    else
                        % if not in proper range, ignore frame & continue
                        continue
                    end

                end
            end
            
            
        end
    end
    
    % Row 2: num of stance seconds per column (per bin)
    for tenth = 1:length(stance_tenths)
        stance_tenths(2,tenth) = num2cell(length(stance_tenths{1, tenth}) / incrementSize);
    end
    
    % Row 3: num of swing seconds per column (per bin)
    for tenth = 1:length(stance_tenths)
        stance_tenths(3,tenth) = num2cell(1 - cell2mat(stance_tenths(2,tenth)));
    end
    
    % Row 4: proportion of stance to swing seconds per column (per bin)
    for tenth = 1:length(stance_tenths)
         stance_tenths(4,tenth) = num2cell( cell2mat( stance_tenths(2,tenth)) / cell2mat(stance_tenths(3,tenth)));
    end
    
    
end

     