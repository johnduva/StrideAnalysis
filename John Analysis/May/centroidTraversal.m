% delete this later if dont need: 
% if keepersOnly{pORa{phe}(1,an),day}(maxpkx{1,k}(i)) ~= keepersOnly{pORa{phe}(1,an),day}(i+1), continue; end


%%
pORa = phenos;
Fs = 80;
phe = 1; % TscHet 
strideVelFinal = zeros(1, 2);
strideVelFront = zeros(1, 2);
strideVelRear = zeros(1, 2);
% Calculate body velocity from centroid coordinates:
for an = 1:1 %length(ASD_all{1,1}(1,:)) 
    for day = 1:2%length(  correctedTens5(pORa{phe}(1,an),:)   ) 
        allPaws = permute( correctedTens5{pORa{phe}(1,an),day}([5,6,9,10], : , :), [2 1 3]);
        % allPaws = permute( correctedTens5{ASD_all{phe}(1,an),day}([5,6,9,10], : , :), [2 1 3]);
        
        numLimbs = size(allPaws, 2);
        frames = (1:size(allPaws,3))';
        % x-values for all paws (correct for pixels to mm (for each pixel,
        % there are 1.97 millimeters)
        preX = squeeze(allPaws(2,:,:))'; %/ 1.927;
        
        % For each paw, calculate which frames are peaks/valleys
        for k = 1:numLimbs 
            [maxpkx{k}, minpkx{k}] = peakdet(preX(:,k), 15);
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
        % from pixels per frame to 
        %          mm per second
        vel = vel * 80 / 1.927 / 1000;
        
        % make scatterplot: stride length vs velocity:
        colors = {'r','r','k','k'};
        for k = 2:2 %numLimbs
            % zeros(641,2)
            strideVsVel = zeros( size(maxpkx{1,k},1), 2); 
            % if index of first min < index of first max...
            if minpkx{1,k}(1,1) <= maxpkx{1,k}(1,1)
                for i = 1:size(maxpkx{1, k},1)-1
                    % If the current peak and the previous peak are not in the same bout, 
                    % then do not consider their distance from each other
                    if keepersOnly{pORa{phe}(1,an),day}(maxpkx{1,k}(i+1)) - keepersOnly{pORa{phe}(1,an),day}(minpkx{1,k}(i)) ...
                            == maxpkx{1,k}(i+1) - minpkx{1,k}(i)
                        % stride length (max - min)
                        xdist = abs(centroidsF2(maxpkx{1,k}(i),1) - centroidsF2(minpkx{1,k}(i),1));
                        ydist = abs(centroidsF2(maxpkx{1,k}(i),2) - centroidsF2(minpkx{1,k}(i),2));
                        strideVsVel(i,1) = sqrt( xdist^2 + ydist^2);
                        % mean centroid velocity during that stride
                        strideVsVel(i,2) = mean( vel(minpkx{1,k}(i,1) : maxpkx{1,k}(i,1), 1));
                    else
                       continue
                    end
                end
            % if the first max < first min
            else % minpkx{1,k}(1,1) > maxpkx{1,k}(1,1)
                for i = 1:size(maxpkx{1, k},1)-1
                    % If the current peak and the previous peak are not in the same bout of locomotion, 
                    % then do not consider their distance from each other.
                    if keepersOnly{pORa{phe}(1,an),day}(maxpkx{1,k}(i+1)) - keepersOnly{pORa{phe}(1,an),day}(minpkx{1,k}(i)) ...
                        == maxpkx{1,k}(i+1) - minpkx{1,k}(i)
                        % stride length (max - min)
                        xdist = abs(centroidsF2(maxpkx{1,k}(i+1),1) - centroidsF2(minpkx{1,k}(i),1));
                        ydist = abs(centroidsF2(maxpkx{1,k}(i+1),2) - centroidsF2(minpkx{1,k}(i),2));
                        strideVsVel(i,1) = sqrt( xdist^2 + ydist^2);
                        % mean centroid velocity during that stride
                        strideVsVel(i,2) = mean( vel(minpkx{1,k}(i,1) : maxpkx{1,k}(i+1,1), 1));
                    else
                        continue
                    end
               end 
            end
            
            strideVelFinal = [strideVelFinal; strideVsVel];
%                 
%             figure(3)
%             xNow = strideVsVel(:,2)*1.927;
%             yNow = strideVsVel(:,1)*1.927;
%             scatter( xNow, yNow, 2, colors{k}, '+')
%             
%             ylabel('Stride length (mm)')
%             xlabel('Speed (m/sec)')
%             ylim([0 160])
%             xlim([0 .65])
%             title('Stride Length: Centroid Traversal')
%             
%             hold all

            figure(1)
            xNow = strideVsVel(:,2)*1.927;
            yNow = strideVsVel(:,1)*1.927;
%             c = cell2mat(weights_WT_ASD(pORa{phe}(1,an)));
%             disp(c);
%             c = repmat(c,1,length(xNow));
            
%             scatter( xNow(1:1:end), yNow(1:1:end),  1, c(1:1:end), 'o')      %colors{k}, '+')
%             scatter( xNow, yNow,  5, c, '+')      %colors{k}, '+')
            scatter( xNow, yNow,  5, colors{k}, '+')
% 
%             colorbar
%             colormap jet
%             h = colorbar;
%             ylabel(h, 'Weight (g)')
            
            ylabel('Centroid Traversal per Stride (mm)')
            xlabel('Speed (m/sec)')
            ylim([0 160])
            xlim([0 .6])
            title('Centroid Traversal (per Stride) vs Speed')
            hold all
        end
    end
end

strideVelFinal = strideVelFinal(2:end, :);

x = strideVelFinal(:,2)*1.927;
y = strideVelFinal(:,1)*1.927;

% plot linear model
% tbl = table(x, y);
% mdl = fitlm(tbl,'linear');
% hMDL = plot(mdl);
% delete(hMDL(1))
% hFIT = findobj(hMDL,'DisplayName','Fit');
% hFIT.LineWidth = 1;
% hFIT.Color = 'blue';
% legend('off')

% throw axis labels back on
% ylabel('Stride length (mm)')
% xlabel('Speed (m/sec)')
% ylim([0 180])
% xlim([0 .6])
% title('Stride Length: Centroid Traversal')
% legend('Rear Paws', 'Location','NorthWest')


% Use polynomial fit
[p, S] = polyfit(x,y,3);
x5 = linspace(.08,.55);
[y_fit,delta] = polyval(p,x5,S);
plot(x5, y_fit, 'b-', 'LineWidth', 2)
plot(x5,y_fit+2*delta,'b--', x5, y_fit-2*delta,'b--','LineWidth',2)
r_sqr = power(corr2(y_fit,x5),2);
 
% include r on plot
% R = corrcoef(x,y);
% R = R(1,2);
% str = sprintf( 'r= %1.2f', R);
% annotation('textbox', [0.7, 0.8, 0.1, 0.1], 'String', str)


% [p,S] = polyfit(x,y,n) returns the polynomial coefficients p and a structure S for use with polyval
%  to obtain error estimates or predictions. Structure S contains fields R, df, and normr, for the 
%  triangular factor from a QR decomposition of the Vandermonde matrix of x, the degrees of freedom,
%  and the norm of the residuals, respectively. If the data y are random, an estimate of the covariance
%  matrix of p is (Rinv*Rinv')*normr^2/df, where Rinv is the inverse of R. If the errors in the data y 
%  are independent normal with constant variance, polyval produces error bounds that contain at least 
%  50% of the predictions.



