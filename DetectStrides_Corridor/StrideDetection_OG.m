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

function StrideData = StrideDetection_OG(final_tracks_c,Fs)

    frames=(1:size(final_tracks_c,3))';
    preX=squeeze(final_tracks_c(1,:,:))'; % X-values for all paws and snout
       
	[minpkx,maxpkx,x_zero]      = StrideDetection_X(preX,frames);
  	[new_swings, new_stances]   = StrideDetection_NewDataPoints(x_zero, minpkx, maxpkx);
        
    StrideData.swing = cell(1,4);
    StrideData.stance = cell(1,4);
    for n = 1:4      
        StrideData.swing{n}  = frames(cell2mat(new_swings(:,n)));
        StrideData.stance{n} = frames(cell2mat(new_stances(:,n)));
    end
    
     StrideDetection_PlotOnTracks(final_tracks_c,StrideData,Fs);
     
end