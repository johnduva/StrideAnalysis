% if the current frame is the first or last in a series, don't consider it 
% if keepersOnly{pORa{phe}(1,an),day}

pORa = phenos;
Fs = 80;
phe = 1; % C57Bl
strideVelFinal = zeros(1, 5);
% strideVelFront = zeros(1, 2);
% strideVelRear = zeros(1, 2);
for an = 1:1%length(phenos{1,1}(1,:)) 
    for day = 1:1%length( correctedTens5(pORa{phe}(1,an),:) )
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % 1. Get session's four paw locations from 'correctedTens5' and isolate the y-vals into four vectors of 'preY'
        allPaws = permute( correctedTens5{pORa{phe}(1,an),day}([5,6,9,10], : , :), [2 1 3]);
        numLimbs = size(allPaws, 2);
        % y-values for all paws (correct for pixels to mm (for each pixel, there are 1.97 millimeters)
        preY = squeeze(allPaws(2,:,:))'; %/ 1.927;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % For each paw, calculate which frames are peaks/valleys
        for k = 1:numLimbs                 
            [maxpkx{k}, minpkx{k}] = peakdet(preY(:,k), 11);
            % Do not consider first peak if frame of first peak < 1 
            if maxpkx{k}(1,1) <= 5
                maxpkx{k} = cat(2,maxpkx{k}(2:end,1), maxpkx{k}(2:end,2));
            end
            if minpkx{k}(1,1)<=5
                minpkx{k} = cat(2,minpkx{k}(2:end,1), minpkx{k}(2:end,2));
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Get the centroid locations from 'keepersOnly' (only 27,525 instead of 95k)
        index = 1;
        for frame = 1: length(allTracks{pORa{phe}(1,an),day})
            if ismember(frame, keepersOnly{pORa{phe}(1,an),day}) % && frame == blank + 1
                centroidsF2(index,1) = allTracks{pORa{phe}(1,an),day}(frame,1); 
                centroidsF2(index,2) = allTracks{pORa{phe}(1,an),day}(frame,2);
                index = index + 1;
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Extract the name of the file by day for the session, and zero pad it
        vid = sprintf('%04d',cell2mat(files_by_day(pORa{phe}(1,an),day)));
        % Load rotVal from proper file
        load(['/Users/johnduva/Desktop/temp/OFT-', vid, '-00_box_aligned_info.mat'], 'mouseInfo')
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Change coordinates to real space
%         allPaws2 = permute(allPaws,[2 1 3]);
%         tempr = deg2rad(mouseInfo.rotVal);
%         tempr = tempr(keepersOnly{pORa{phe}(1,an),day});
%         midJoints = double(allPaws2) - 200;
% 
%         jx = double(squeeze(midJoints(:,1,:)));
%         jy = double(squeeze(midJoints(:,2,:)));
%         ff = zeros(size(allPaws2));
% 
%         for i = 1:length(jx)
% 
%             [jp2j(:,i), jp2i(:,i)] = cart2pol(jx(:,i)',jy(:,i)');
% 
%             tjp(:,i) = jp2j(:,i) + repmat(tempr(i),[4 1]);
% 
%             [jp3j(:,i), jp3i(:,i)] = pol2cart(tjp(:,i),jp2i(:,i));
% 
%             ogc1(:,i) = jp3j(:,i) + centroidsF2(i,1);
%             ogc2(:,i) = jp3i(:,i) + centroidsF2(i,2);
%         end
%         ff(:,1,:) = ogc1; 
%         ff(:,2,:) = ogc2;
%         clearvars tempt tempr tempCents midJoints jx jy jp2j jp2i tjp jp2j jp3j jp3i ogc1 ogc2;
       
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Get change in x-coordinate per frame (negative just means a change to the left)
        vx = gradient(centroidsF2(:,1));
        % get the change in y-coordinate per frame
        vy = gradient(centroidsF2(:,2));
        % velocity 
        vel = ((sqrt(vx.^2 + vy.^2)));
        clear vx vy;
        vel = fillmissing(vel,'linear');
        vel = movmedian(vel,Fs/2);
        % from pixels per frame to 
        %          mm per second
        vel = vel * 80 * .51 / 1000;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Make scatterplot for each limb: stride length vs velocity:
        colors = {'r','b','g','k'};
        for k = 1:numLimbs
            strideVsVel = zeros( size(maxpkx{1,k},1), 2);
            % if index of first min < index of first max...
            if minpkx{1,k}(1,1) <= maxpkx{1,k}(1,1)
                % For each of the maxpkx's
                for i = 1:size(maxpkx{1, k},1)-1
                    % If the current max and the previous min are not in the same bout of locomotion, 
                    % then do not consider their distance from each other.
                    if keepersOnly{pORa{phe}(1,an),day}(maxpkx{1, k}(i)) - keepersOnly{pORa{phe}(1,an),day}(minpkx{1, k}(i)) ~= maxpkx{1, k}(i) - minpkx{1, k}(i)
                        continue
                    else
                        % stride length (max - min)
                        xdist = abs( ff(k, 1, maxpkx{1, k}(i)) - ff(k, 1, minpkx{1, k}(i)) );
                        ydist = abs( ff(k, 2, maxpkx{1, k}(i)) - ff(k, 2, minpkx{1, k}(i)) );
                        strideVsVel(i,1) = sqrt( xdist^2 + ydist^2);
                        % mean centroid velocity during that stride
                        strideVsVel(i,2) = mean( vel(minpkx{1,k}(i,1) : maxpkx{1,k}(i,1), 1));
                    end
                end
                
            % if the first max < first min
            else % minpkx{1,k}(1,1) > maxpkx{1,k}(1,1)
               for i = 1:size(maxpkx{1, k},1)-1
                    % If the current peak and the previous peak are not in the same bout of locomotion, 
                    % then do not consider their distance from each other.
                    if keepersOnly{pORa{phe}(1,an),day}(maxpkx{1, k}(i+1)) - keepersOnly{pORa{phe}(1,an),day}(minpkx{1, k}(i)) ~= maxpkx{1, k}(i+1) - minpkx{1, k}(i)
                        continue
                    else
                        % stride length (max - min)
                        xdist = abs( ff(k, 1, maxpkx{1,k}(i+1)) - ff(k, 1, minpkx{1,k}(i)) );
                        ydist = abs( ff(k, 2, maxpkx{1,k}(i+1)) - ff(k, 2, minpkx{1,k}(i)) );
                        strideVsVel(i,1) = sqrt( xdist^2 + ydist^2);
                        % mean centroid velocity during that stride
                        strideVsVel(i,2) = mean( vel(minpkx{1,k}(i,1) : maxpkx{1,k}(i+1,1), 1));
                    end
               end 
            end
            
            
            strideVelFinal = [strideVelFinal; strideVsVel];

            figure(1)
            
            
            xNow = strideVsVel(:,2)*1.927;
            yNow = strideVsVel(:,1)*1.927;
          
            scatter( xNow, yNow,  2, colors{k}, '+')
            
            ylabel('Stride Length (mm)')
            xlabel('Speed (m/sec)')
            ylim([0 150])
            xlim([0 .65])
            title('Real Space (n=1)')
            hold all
        end
    end
end

% strideVelFinal = strideVelFinal(2:end, :);
% 
% x = strideVelFinal(:,2);
% y = strideVelFinal(:,1);
% 
% 
% % Use polynomial fit
% [p, S] = polyfit(xNow,yNow,3);
% x5 = linspace(.1,.55);
% [y_fit,delta] = polyval(p,x5,S);
% plot(x5, y_fit, 'b-', 'LineWidth', 2)
% plot(x5,y_fit+2*delta,'b--', x5, y_fit-2*delta,'b--','LineWidth',2)
% r_sqr = power(corr2(y_fit,x5),2);
% 
% % include r on plot
% str = sprintf( 'r= %1.2f', r_sqr);
% annotation('textbox', [0.8, 0.8, 0.1, 0.1], 'String', str)
