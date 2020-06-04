% Go through each cell in 'corrected' and only keep the frames that we have
% determined are within a bout of 10 (locomotion).

% function correctedTens(corrected, allcGuesses, keepersOnly)
    % create new 382x5 matrix of NaNs
    correctedTens5 = num2cell(NaN(382,5));
    % for each animal/day in 'corrected'...
    for an = 1:size(keepersOnly,1)
        for day = 1:size(keepersOnly,2)            
            % set the new frame index (frame 308 becames frame 1, 309 frame 2...)
            i = 1; 
            % if that session is empty, skip.
            if isempty(keepersOnly{an,day})
                correctedTens5{an,day} = [];
            % if the animal/day cell does have data...
            else
                % make sure each frame has 18 body parts, 2 coordinates, and a frame 
                correctedTens5{an,day} = NaN(14,2,1);

                % for each frame in each 'corrected' cell...
                for frame = 1:size(positions_pred_by_day{an,day},3)
                    % if frame is in a bout of 10...
                    if ismember( frame, keepersOnly{an,day} )
                        % add all limbs and both coordinates of that frame to equivalent animal/day cell in 'correctedTens'
                        correctedTens5{an,day}(:,:,i) = positions_pred_by_day{an,day}([1:8 12:16 18],:,frame);
                        i = i+1;
                    end
                end
                
            end
        end
        disp(an);
    end
% end
