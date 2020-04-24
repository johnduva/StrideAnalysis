% Find all of the chunks of locomotion (allcGuesses{an,day}(frame,1) = 10) 
% in each of the (382*5=) 1910 cells within 'allcGuesses'.

% get the frames showing locomotion from 'allcGuesses' 
function tensOnly = getTensOnly(allcGuesses)
    minThresh = 10;
    tensOnly = num2cell(NaN(size(allcGuesses)));
    for an = 1:size(allcGuesses,1)
        for day = 1:size(allcGuesses,2)
            index = 1;
            for frame = 1: length(allcGuesses{an,day})
                if allcGuesses{an,day}(frame,1) == minThresh 
                    tensOnly{an,day}(index,1) = frame;
                    index = index + 1;
                end
            end
        end
    end
end

% mode filter across sets of 9 frames
% for an = 1:size(allcGuesses,1)
%     for day = 1:size(allcGuesses,2)
%         image = allcGuesses{an,day};
%         modefilt(image,[5 5]);
% %         colfilt(image, [8 2], 'sliding', @mode);
%     end
% end





