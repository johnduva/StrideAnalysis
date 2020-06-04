% Paws:
%     - 1: Left front   (red)
%     - 2: Right front  (green)
%     - 3: Left hind    (blue)
%     - 4: Right hind   (black)

function StrideDetection_PlotOnTracks(final_tracks_c, minpkx, maxpkx, Fs, numLimbs)
    % load colorscheme.mat
%     load([fileparts(which('StrideDetection_PlotOnTracks')) filesep 'colorscheme.mat'])
%     % determine number of frames in file
%     total_frames = size(final_tracks_c,3);
%     
%     % create figure for x pixel
%     figure('Name','Stance Width (x-Coordinate)','NumberTitle','off')
%     for paw_i = 1:2%:numLimbs
%         % w/in StrideData, compare num of swing instances to num stance instances - then take the minimum
%         total_strides = min( [size(StrideData.stance{paw_i},1) size(StrideData.swing{paw_i},1)] );
%         % plot each frame on x-axis, each x-coordinate on y-axis
%         plot( (1:total_frames), squeeze(final_tracks_c(1,paw_i,:)),'LineWidth',2,'Color',PointColors(paw_i,:))
%         hold on
%         %...this is where those for swing/stance loops belong
%     end
%     axis tight
%     xlabel('time [s]', 'FontSize', 18)
%     ylabel('X pixel','FontSize', 18)
%     legend('Left Front', 'Right Front', 'Left Hind', 'Right Hind','FontSize', 14)
%     title('Type of Mouse? (X-Pixel vs Time)', 'FontSize', 18)
%     %savefig('M26_xCompare.png')
%     
    
    %%
    % create figure for y-pixel
    figure('Name','Stride Length (y-Coordinate)','NumberTitle','off')
    for paw_i = 1:1 %numLimbs
        total_strides = min([size(minpkx{paw_i},1) size(maxpkx{paw_i},1)]);
%         %plot( (1:total_frames), squeeze(final_tracks_c(2,paw_i,:)),'LineWidth',1,'Color', PointColors(paw_i,:) )
%         plot( (1:500), squeeze(final_tracks_c(2,paw_i,1:500)),'LineWidth',1,'Color', PointColors(paw_i,:) )
%         hold on

        % plot the 'swing' states in bold
        if minpkx{paw_i}(1) < maxpkx{paw_i}(1)
            for swing_i = 1:25 %total_strides
                idx = minpkx{paw_i}(swing_i) : maxpkx{paw_i}(swing_i);
                plot(idx, squeeze(allPaws(2,paw_i,idx)), 'LineWidth',2, 'Color', PointColors(paw_i,:))
                hold on
            end
        else % minpkx{paw_i}(1) > maxpkx{paw_i}(1)
             for swing_i = 1:25 %total_strides
                idx = minpkx{paw_i}(swing_i) : maxpkx{paw_i}(swing_i+1);
                plot(idx, squeeze(allPaws(2,paw_i,idx)), 'LineWidth',2, 'Color', PointColors(paw_i,:))
                hold on
            end
        end
        
        % plot the 'stance' states in dashed lines
        if maxpkx{paw_i}(1) < minpkx{paw_i}(1)
            for stance_i = 1:25 %total_strides-1 
                idx = maxpkx{paw_i}(stance_i) : minpkx{paw_i}(stance_i);
                plot(idx, squeeze(allPaws(2,paw_i,idx)), 'LineWidth',1, 'Color', PointColors(paw_i,:), 'LineStyle', '--')
                hold on
            end
        else % maxpkx{paw_i}(stance_i) > minpkx{paw_i}(stance_i)
            for stance_i = 1:25 %total_strides-1 
                idx = maxpkx{paw_i}(stance_i) : minpkx{paw_i}(stance_i+1);
                plot(idx, squeeze(allPaws(2,paw_i,idx)), 'LineWidth',1, 'Color', PointColors(paw_i,:), 'LineStyle', '--')
                hold on
            end
        end
        
    end
    axis tight
    xlabel('time [frames]', 'FontSize', 18)
    ylabel('Y pixel','FontSize', 18)
    legend({'Right Forepaw', 'Left Forepaw','Right Hind', 'Left Hind'},'FontSize', 14)
%     lgd = legend({'Line 1','Line 2','Line 3','Line 4'},'FontSize',12,'TextColor','blue')
    title('Y-Pixel vs Time', 'FontSize', 18)
    %savefig('Y pixel')
end