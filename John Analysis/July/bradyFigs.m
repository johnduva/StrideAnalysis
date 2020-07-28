tiledlayout(2,1)

nexttile
implay('tscHet_Gait2_0010.mp4')

nexttile
implay('tscHet_Gait2_0012.mp4')
% function VideoInCustomGUIExample()
% % Initialize the video reader.
% videoSrc = vision.VideoFileReader('tscHet_Gait2_0008.mp4', 'ImageColorSpace', 'Intensity');
% % Create a figure window and two axes to display the input video and the processed video.
% [hFig, hAxes] = createFigureAndAxes();
% insertButtons(hFig, hAxes, videoSrc);
% 
% % Initialize the display with the first frame of the video
% frame = getAndProcessFrame(videoSrc, 0);
% % Display input video frame on axis
% showFrameOnAxis(hAxes.axis1, frame);
% showFrameOnAxis(hAxes.axis2, zeros(size(frame)+60,'uint8'));
% end

