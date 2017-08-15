function StrideDetection_PlotOnTracks(final_tracks_c,SwiSta,Fs)

    load([fileparts(which('StrideDetection_PlotOnTracks')) filesep 'colorscheme.mat'])
    total_frames = size(final_tracks_c,3);
    figure()
    for paw_i = 1:4
        total_strides = min([size(SwiSta.stance{paw_i},1) size(SwiSta.swing{paw_i},1)]);
        plot([1:total_frames]/Fs,squeeze(final_tracks_c(1,paw_i,:)),'LineWidth',5,'Color',PointColors(paw_i,:))
        hold on
        for swing_i = 1:total_strides
            idx = SwiSta.swing{paw_i}(swing_i):SwiSta.stance{paw_i}(swing_i);
            plot(idx/Fs,squeeze(final_tracks_c(1,paw_i,idx)),'w','LineWidth',2)
        end


        for stance_i = 1:total_strides-1 
            idx = SwiSta.stance{paw_i}(stance_i):SwiSta.swing{paw_i}(stance_i+1);
            plot(idx/Fs,squeeze(final_tracks_c(1,paw_i,idx)),'k','LineWidth',2)
        end
    end
    plot([1:total_frames]/Fs,squeeze(final_tracks_c(1,5,:)),'LineWidth',5,'Color',PointColors(5,:))
    axis tight
    xlabel('time [s]')
    ylabel('X pixel')

    figure()
    for paw_i = 1:4
        total_strides = min([size(SwiSta.stance{paw_i},1) size(SwiSta.swing{paw_i},1)]);
        plot([1:total_frames]/Fs,squeeze(final_tracks_c(2,paw_i,:)),'LineWidth',5,'Color',PointColors(paw_i,:))
        hold on
        for swing_i = 1:total_strides
            idx = SwiSta.swing{paw_i}(swing_i):SwiSta.stance{paw_i}(swing_i);
            plot(idx/Fs,squeeze(final_tracks_c(2,paw_i,idx)),'w','LineWidth',2)
        end


        for stance_i = 1:total_strides-1 
            idx = SwiSta.stance{paw_i}(stance_i):SwiSta.swing{paw_i}(stance_i+1);
            plot(idx/Fs,squeeze(final_tracks_c(2,paw_i,idx)),'k','LineWidth',2)
        end

    end
    set(gca, 'Ydir', 'reverse')
    plot([1:total_frames]/Fs,squeeze(final_tracks_c(2,5,:)),'LineWidth',5,'Color',PointColors(5,:))
    axis tight

    xlabel('time [s]')
    ylabel('Y pixel')


    figure()
    for paw_i = 1:4
        total_strides = min([size(SwiSta.stance{paw_i},1) size(SwiSta.swing{paw_i},1)]);
        plot([1:total_frames]/Fs,squeeze(final_tracks_c(3,paw_i,:)),'LineWidth',5,'Color',PointColors(paw_i,:))
        hold on
        for swing_i = 1:total_strides
            idx = SwiSta.swing{paw_i}(swing_i):SwiSta.stance{paw_i}(swing_i);
            plot(idx/Fs,squeeze(final_tracks_c(3,paw_i,idx)),'w','LineWidth',2)
        end


        for stance_i = 1:total_strides-1 
            idx = SwiSta.stance{paw_i}(stance_i):SwiSta.swing{paw_i}(stance_i+1);
            plot(idx/Fs,squeeze(final_tracks_c(3,paw_i,idx)),'k','LineWidth',2)
        end
    end
    plot([1:total_frames]/Fs,squeeze(final_tracks_c(3,5,:)),'LineWidth',5,'Color',PointColors(5,:))
    axis tight
    set(gca, 'Ydir', 'reverse')
    xlabel('time [s]')
    ylabel('Z pixel')
end