% Convert 100 behaviors to the 10 from sH1

% function allcGuesses = ACGfrom100to10(allcGuesses, sH1)
    for an = 1:size(allcGuesses,1)
        for day = 1:size(allcGuesses,2)
            for frame = 1: length(allcGuesses{an,day})
                for index = 1: length(sH1)

                    if allcGuesses{an,day}(frame,1) == index
                        allcGuesses3{an,day}(frame,1) = sH1(index);
%                         allcGuesses2{an,day}(frame,2) = allcGuesses{an,day}(frame,2);
                    end

                end
            end
        end
        disp('an: ');
        disp(an);
    end
    
% end