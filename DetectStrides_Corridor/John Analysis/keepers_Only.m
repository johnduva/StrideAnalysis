% Written by John D'Uva (April 2020)

% Walk through each cell of 'tensOnly' and determine if each frame is
% within a boout of 10s (locomotion).If it is a 10, then add it to the 
% temporary array 'holder.' If we're in a large enough bout of 10s, 
% and changing to other behavior,
% then check if 'holder' >= 10. If so, push 'holder' to 'keepersOnly.'

function keepersOnly = keepers_Only(allcGuesses3, tensOnly)
    % create skeleton of new matrix
    keepersOnly = num2cell(NaN(size(allcGuesses3)));
    % set threshold for minimum number of frames considered a bout
    minThresh = 10;
    % for each animal, for each session...
    for an = 1:size(tensOnly,1)
        for day = 1:size(tensOnly,2)
           % create temporary array for each new bout
           holder = [];
           % for each frame within a cell...
           for frame = 1: length(tensOnly{an,day})-1
               % if 289 == 290-1...
               if tensOnly{an,day}(frame) == tensOnly{an,day}(frame+1)-1
                   % add that frame to holder because it's part of a locomotion bout
                   holder = [holder, tensOnly{an,day}(frame)];
                   % if we've also reached the last frame of the session and 'holder' > 10...
                   if frame == length(tensOnly{an,day}) && length(holder) >= minThresh 
                       % then add 'holder' to 'keepersOnly' and empty 'holder'
                       keepersOnly{an,day} = [keepersOnly{an,day}, holder];
                       holder = [];
                   end
               % if not consecutive frames, then check 'holder'>10 and start new phase...
               else
                   % if holder >= 10...
                   if length(holder) >= minThresh 
                       keepersOnly{an,day} = [keepersOnly{an,day}, holder];
                       holder = [];
                   % if holder < 10...
                   else
                       holder = [];
                   end   
               end
           end
           % remove the first NaN in each cell
           keepersOnly{an,day} = keepersOnly{an,day}(2:end);

        end
        disp(an);
    end
end



% Determine what percentage of frames from 'tensOnly' that 'keepersOnly' kept. 
function prcnt = getPrcnt(tensOnly, keepersOnly)
    sum = 0;
    for an = 1:size(tensOnly,1)
        for day = 1:size(tensOnly,2)
            sum = sum + length(tensOnly{an,day});
        end
    end

    sum2 = 0;
    for an = 1:size(keepersOnly,1)
        for day = 1:size(keepersOnly,2)
            sum2 = sum2 + length(keepersOnly{an,day});
        end
    end
    prcnt = sum2/sum;
end
