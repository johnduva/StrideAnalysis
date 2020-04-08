%[SwiSta] = DE_SwingStanceDetection(labels)
% 
% TAKES: 
% final_tracks_c from the LocoMouse_Track results.
% Fs - framerate
%
% RETURNS:
% Start frames of identified swings and stances.
%
% NEEDS:
% - inpaint_nans()
% - StrideDetection_X() [original code outsourced into different function files]
% - StrideDetection_NewDataPoints() [original code outsourced into different function files]

% Dennis Eckmeier, 2015
% Based on correcmatfinal_wild_400_04_018_mutant.m by Carey lab
final_tracks_c = front_paws;
Fs = 80;

function StrideData = StrideDetection_OG(final_tracks_c,Fs) 
    % extract second dimension from 3D dataset
    numLimbs = size(final_tracks_c, 2);
    % number of total frames
    frames = (1:size(final_tracks_c,3))';
    % X-values for all paws and snout
    preX = squeeze(final_tracks_c(1,:,:))';
    
	[minpkx,maxpkx,x_zero]      = StrideDetection_X(preX, frames, numLimbs);
  	[new_swings, new_stances]   = StrideDetection_NewDataPoints(x_zero, minpkx, maxpkx, numLimbs);
        
    StrideData.swing = cell(1,numLimbs);
    StrideData.stance = cell(1,numLimbs);
    for n = 1:numLimbs
        StrideData.swing{n}  = frames(cell2mat(new_swings(:,n)));
        StrideData.stance{n} = frames(cell2mat(new_stances(:,n)));
    end
    
     StrideDetection_PlotOnTracks(final_tracks_c, StrideData, Fs, numLimbs);
     
end

