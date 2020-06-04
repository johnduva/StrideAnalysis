% clearvars -except allPaws allTracks an keepersOnly correctedTens5 phe phenos PointColors

pORa = phenos;
Fs = 80;
phe = 1; % C57Bl 
swingVelFinal = zeros(1, 2);
swingVelFront = zeros(1, 2);
swingVelRear = zeros(1, 2);
for an = 1:1 %length(ASD_all{1,1}(1,:)) % for each animal in the first row of LobVI1D_ans
    for day = 1:4%length( correctedTens5(pORa{phe}(1,an) , :) ) % correctedTens2(198,:) 
                                  % correctedTens{phenos{1}(1,198), 1}  (4limbs, all xy coords, all frames
        allPaws = permute( correctedTens5{pORa{phe}(1,an),day}([5,6,9,10], : , :), [2 1 3]);
        % OR allPaws = permute( correctedTens5{ASD_all{phe}(1,an),day}([5,6,9,10], : , :), [2 1 3]);
        numLimbs = size(allPaws, 2);
        frames = (1:size(allPaws,3))';
        % x-values for all paws
        preX = squeeze(allPaws(2,:,:))';
        
        % For each paw, calculate which frames are peaks/valleys
        for k = 1:numLimbs 
            [maxpkx{k}, minpkx{k}] = peakdet(preX(:,k), 11); 
            %Do not consider first peak if frame of first peak < 1
            if maxpkx{k}(1,1) <= 5
                maxpkx{k} = cat(2,maxpkx{k}(2:end,1), maxpkx{k}(2:end,2));
            end
            if minpkx{k}(1,1)<=5
                minpkx{k} = cat(2,minpkx{k}(2:end,1), minpkx{k}(2:end,2));
            end
        end
        
        index = 1;
        for frame = 1: length(allTracks{pORa{phe}(1,an),day})
            if ismember(frame, keepersOnly{pORa{phe}(1,an),day})
                centroidsF2(index,1) = allTracks{pORa{phe}(1,an),day}(frame,1); 
                centroidsF2(index,2) = allTracks{pORa{phe}(1,an),day}(frame,2);
                index = index + 1;
            end
        end

        % get change in x-coordinate per frame (negative just means a change to the left)
        vx = gradient(centroidsF2(:,1));
        % get the change in y-coordinate per frame
        vy = gradient(centroidsF2(:,2));
        % velocity 
        vel = ((sqrt(vx.^2 + vy.^2)));
        clear vx vy;
        vel = fillmissing(vel,'linear');
        vel = movmedian(vel,Fs/2);
        
        
        % make scatterplot: swing velocity vs speed:
        colors = {'r','r','k','k'};
        for k = 1:numLimbs
            % zeros(641,2)
            swingVel = zeros( size(maxpkx{1,k},1), 2); 
            % if index of first min < index of first max...
            if minpkx{1,k}(1,1) <= maxpkx{1,k}(1,1)
                for i = 1:size(maxpkx{1, k},1)-1
                    % calculate y-pixels traveled per frame (mm/sec)
                    swingVel(i,1) = (maxpkx{1,k}(i,2) - minpkx{1,k}(i,2)) / (maxpkx{1,k}(i,1) - minpkx{1,k}(i,1));
                    % mean centroid velocity during that stride
                    swingVel(i,2) = mean( vel(minpkx{1,k}(i,1) : maxpkx{1,k}(i,1), 1));
                end
            % if the first max < first min
            else % minpkx{1,k}(1,1) > maxpkx{1,k}(1,1)
               for i = 1:size(maxpkx{1, k},1)-1
                    % calculate y-pixels traveled per frame (mm/sec)
                    swingVel(i,1) = (maxpkx{1,k}(i+1,2) - minpkx{1,k}(i,2)) / (maxpkx{1,k}(i+1,1) - minpkx{1,k}(i,1));
                    % mean centroid velocity during that stride
                    swingVel(i,2) = mean( vel(minpkx{1,k}(i,1) : maxpkx{1,k}(i+1,1), 1));
               end 
            end
            
            swingVelFinal = [swingVelFinal; swingVel];
            
            if k == 1 || 2
                swingVelFront = [swingVelFront; swingVel];
            else % k = 3 || 4
                swingVelRear = [swingVelRear; swingVel];
            end
                
            figure(3)
            xNow = swingVel(:,2)*1.97;
            yNow = swingVel(:,1)*1.97;
            scatter( xNow, yNow, 1, colors{k}, '+')
            hold all
        end
    end
end

x = swingVelFinal(:,2)*1.97;
y = swingVelFinal(:,1)*1.97;



% bins = {1,20};
% for eachSwingVel = 2:length(y)
%    for speed = 1:20
%        index = 1;
%        if y(eachSwingVel) >= speed-1 && y(eachSwingVel) < speed
%            bins{1,speed}(index,1) = s
%            bins{1,speed}(index,2) = 
%            index = index + 1;
%            
%        end
%    end   
% end

% plot linear model
% tbl = table(x, y);
% mdl = fitlm(tbl,'linear');
% hMDL = plot(mdl);
% delete(hMDL(1))
% hFIT = findobj(hMDL,'DisplayName','Fit');
% hFIT.LineWidth = 2;
% hFIT.Color = 'blue';

% throw axis labels back on
ylabel('Swing Velocity (mm/sec)')
xlabel('Centroid Speed (mm/sec)')
ylim([0 16])
% xlim([0 5])
title('Wild Type Mice')
legend('Front Paws', 'Rear Paws', 'Location','NorthWest')

% include r on plot
% tmp = corrcoef(x,y);
% str = sprintf( 'r= %1.2f', tmp(1,2) );
% annotation('textbox', [0.8, 0.8, 0.1, 0.1], 'String', str)




