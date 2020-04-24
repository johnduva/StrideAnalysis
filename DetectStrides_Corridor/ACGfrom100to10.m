
for an = 1:size(allcGuesses,1)
    for day = 1:size(allcGuesses,2)
        for frame = 1: length(allcGuesses{an,day})
            for index = 1: length(sH1)
                
                if allcGuesses{an,day}(frame,1) == index
                    allcGuesses{an,day}(frame,1) = sH1(index);
                end
                
            end
        end
    end
end