function [avgStrideDist] = avgStrideDist(minpkx, maxpkx)
    minIDX = minpkx{1}(:,1); 
    maxIDX = maxpkx{1}(:,1); 
    dist = 0;

    for i = 1:min(length(minIDX),length(maxIDX))
        dist = dist + maxIDX(i)-minIDX(i);
    end
    
    avgStrideDist = dist / min(length(minIDX),length(maxIDX));
end