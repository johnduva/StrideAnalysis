
% reminder: label right paw and left on the figure

% Average distance between two paws
function avg_dist = avg_dist(final_tracks_c, paw1, paw2)
    total_frames = size(final_tracks_c,3);
    c = 0;
    
    % get Euclidean distances
    for frame = 1:total_frames
        c = c + sqrt( (final_tracks_c(1,paw1,frame) - final_tracks_c(1,paw2,frame)).^2  ...
                    + (final_tracks_c(2,paw1,frame) - final_tracks_c(2,paw2,frame)).^2 );
    end  
    avg_dist = c / total_frames;
end


% how fast they walk (avg speed)
% figure 3 and 5 in 2019 paper


%     sqrt( (x-x)^2 + (y-y)^2 )
    (x2-x1)