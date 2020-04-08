function StrideDetection_PlotOnTracks(final_tracks_c, SwiSta, Fs, numLimbs)
    
    % load colorscheme.mat
    load([fileparts(which('StrideDetection_PlotOnTracks')) filesep 'colorscheme.mat'])
    % determine number of frames in file
    total_frames = size(final_tracks_c,3);
    
    % when comparing two front paws with each other (or two back paws),
    % y-pixels should intersect each other once per phase (like sin(x) vs. -sin(x))
    % but x-pixels should maintain a steady distance from each other (stance dist)
    
    % create figure for x pixel
    figure('Name','x-Coordinate','NumberTitle','off')
    for paw_i = 1:numLimbs
        % w/in StrideData, compare num of swing instances to num stance instances - then take the minimum
        total_strides = min( [size(SwiSta.stance{paw_i},1) size(SwiSta.swing{paw_i},1)] );
        % plot each frame on x-axis, each x-coordinate on y-axis
        plot( (1:total_frames)/Fs, squeeze(final_tracks_c(1,paw_i,:)),'LineWidth',2,'Color',PointColors(paw_i,:))
        hold on
        
        % distinguish the swings in white
        for swing_i = 1:total_strides
            idx = SwiSta.swing{paw_i}(swing_i) : SwiSta.stance{paw_i}(swing_i);
            plot( idx/Fs, squeeze(final_tracks_c(1,paw_i,idx)),'w','LineWidth',1) % 'w' = white
        end
        
        % distinguish the stances in black
        for stance_i = 1:total_strides-1 
            idx = SwiSta.stance{paw_i}(stance_i):SwiSta.swing{paw_i}(stance_i+1);
            plot(idx/Fs,squeeze(final_tracks_c(1,paw_i,idx)),'k','LineWidth',1) % 'k' = black
        end
        
    end
    axis tight
    xlabel('time [s]', 'FontSize', 18)
    ylabel('X pixel','FontSize', 18)
    legend('Right Forepaw', 'Left Forepaw', 'FontSize', 14)
%     L(1) = plot(nan, nan, 'k-');
%     L(2) = plot(nan, nan, 'w--');
%     legend(L, {'Stride', 'Stance'})
    title('Mouse 26 - Wildtype (X-Pixel vs Time)', 'FontSize', 18)
    %savefig('M26_xCompare.png')
    
    % create figure for y-pixel
    figure('Name','y-Coordinate','NumberTitle','off')
    for paw_i = 1:numLimbs
        total_strides = min([size(SwiSta.stance{paw_i},1) size(SwiSta.swing{paw_i},1)]);
        plot( (1:total_frames)/Fs, squeeze(final_tracks_c(2,paw_i,:)),'LineWidth',2,'Color', PointColors(paw_i,:) )
        hold on
        
        for swing_i = 1:total_strides
            idx = SwiSta.swing{paw_i}(swing_i):SwiSta.stance{paw_i}(swing_i);
            plot(idx/Fs,squeeze(final_tracks_c(2,paw_i,idx)),'w','LineWidth',1)
        end

        for stance_i = 1:total_strides-1 
            idx = SwiSta.stance{paw_i}(stance_i):SwiSta.swing{paw_i}(stance_i+1);
            plot(idx/Fs,squeeze(final_tracks_c(2,paw_i,idx)),'k','LineWidth',1)
        end
    end
    set(gca, 'Ydir', 'reverse')
    axis tight
    xlabel('time [s]', 'FontSize', 18)
    ylabel('Y pixel','FontSize', 18)
    legend('Right Forepaw', 'Left Forepaw', 'FontSize', 14)
    title('Y-Pixel vs Time', 'FontSize', 18)
    %savefig('Y pixel')
end