function [minpkx, maxpkx] = StrideDetection_X(preX, numLimbs)

    for j=1:numLimbs % For each paw...
        %Calculate peaks and valleys for each paw
        [maxpkx{j}, minpkx{j}] = peakdet(preX(:,j), 3); 
    
        %Do not consider first peak if frame of first peak < 1
        if maxpkx{j}(1,1) <= 5
            maxpkx{j} = cat(2,maxpkx{j}(2:end,1), maxpkx{j}(2:end,2));
        end
        
        if minpkx{j}(1,1)<=5
            minpkx{j} = cat(2,minpkx{j}(2:end,1), minpkx{j}(2:end,2));
        end
    end
    
end