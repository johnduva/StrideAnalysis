% Get the frames showing locomotion from 'allcGuesses' 
% function tensOnly = getTensOnly(allcGuesses2)
    behavior = 10;
    tensOnly = num2cell(NaN(size(allcGuesses3)));
    for an = 1:size(allcGuesses3,1)
        for day = 1:size(allcGuesses3,2)
            index = 1;
            for frame = 1: length(allcGuesses3{an,day})
                if allcGuesses3{an,day}(frame,1) == behavior 
                    tensOnly{an,day}(index,1) = frame;
                    index = index + 1;
                end
            end
        end
%         disp(an);
    end
    
% end

% mode filter across sets of 9 frames
% for an = 1:size(allcGuesses,1)
%     for day = 1:size(allcGuesses,2)
%         image = allcGuesses{an,day};
%         modefilt(image,[5 5]);
% %         colfilt(image, [8 2], 'sliding', @mode);
%     end
% end





