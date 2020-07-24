% implay('tscHet_Gait1_0014.mp4')

function VideoInCustomGUIExample()
    % Initialize the video reader.
    videoSrc = vision.VideoFileReader('tscHet_Gait2_0008.mp4', 'ImageColorSpace', 'Intensity');
    % Create a figure window and two axes to display the input video and the processed video.
    [hFig, hAxes] = createFigureAndAxes();
end