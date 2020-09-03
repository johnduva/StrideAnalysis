
v = VideoWriter('an15_test2.mp4', 'MPEG-4');
v.FrameRate = 10;
open(v);


% Generate a set of frames, get the frame from the figure, and then write each frame to the file.
for k = 1 : 200
    
    h1 = scatter(keepRealPaws(1,1,k), keepRealPaws(1,2,k), 'r'); % this is 5
    hold on;
    h2 = scatter(keepRealPaws(2,1,k), keepRealPaws(2,2,k), 'b'); % this is 6
    hold on;
    h3 = scatter(keepRealPaws(3,1,k), keepRealPaws(3,2,k), 'b'); % this is 9
    hold on;
    h4 = scatter(keepRealPaws(4,1,k), keepRealPaws(4,2,k), 'r'); % this is 10
    hold on;
%     h5 = scatter(keepCent(k,1), keepCent(k,2), 'k');
%     h6 = scatter(keepTTI(1,1,k), keepTTI(1,2,k), 'b');

    % legend('Hindpaws','Forepaws', 'Location','NorthWest')
    title('Miniscope Animal 15')
    xlim([0 1000])
    ylim([0 1200])
    frame = getframe(gcf);
    writeVideo(v,frame);

    hold off;
    delete(findall(gcf,'Tag','stream'));
    label1 = 'Vel = %f m/s';
    str = sprintf(label1, keepVel(k));
    annotation('textbox',[.7 .8 .1 .1],'string',str, 'Tag', 'stream')
    
%     delete(findall(gcf,'Tag','stream'));
    label1 = 'Frame = %d';
    str = sprintf(label1, k);
    annotation('textbox',[.15 .8 .1 .1],'string',str, 'Tag', 'stream')

%             delete(findall(gcf,'Tag','stream'));
%     label2 = 'Bout Lag = %f';
%     str = sprintf(label2, permaList(bout,2));
%     annotation('textbox',[.15 .1 .1 .1],'string',str, 'Tag', 'stream')
%     drawnow;
end

close(v);