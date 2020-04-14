% RETURNS:
% Start frames of identified swings and stances.
%
% NEEDS:
% - swing_stance_frames.m
% - StrideDetection_NewDataPoints()

% Uncomment to walk through a loop and debug:
% final_tracks_c = front_paws;
% Fs = 80;

function StrideData = StrideDetection_OG(final_tracks_c,Fs) 
    % extract second dimension from 3D dataset
    numLimbs = size(final_tracks_c, 2);
    % number of total frames
    frames = (1:size(final_tracks_c,3))';
    % x-values for all paws ("and snout"?)
    preX = squeeze(final_tracks_c(1,:,:))';
    
     % Calculate peaks and valleys for each paw
     for j=1:numLimbs 
        [maxpkx{j}, minpkx{j}] = peakdet(preX(:,j), 3); 
        %Do not consider first peak if frame of first peak < 1
        if maxpkx{j}(1,1) <= 5
            maxpkx{j} = cat(2,maxpkx{j}(2:end,1), maxpkx{j}(2:end,2));
        end
        if minpkx{j}(1,1)<=5
            minpkx{j} = cat(2,minpkx{j}(2:end,1), minpkx{j}(2:end,2));
        end
    end
    
  	[stance_frames, swing_frames]  =  swing_stance_frames(minpkx, maxpkx, numLimbs, frames);
    
    StrideData.swing = cell(1,numLimbs);
    StrideData.stance = cell(1,numLimbs);
    for j = 1:numLimbs
        StrideData.swing{j}  = frames(cell2mat(swing_frames(:,j)));
        StrideData.stance{j} = frames(cell2mat(stance_frames(:,j)));
    end
    
     StrideDetection_PlotOnTracks(final_tracks_c, StrideData, Fs, numLimbs);
     
end

