% clearvars -except allPaws allTracks an keepersOnly correctedTens5 phe phenos PointColors

pORa = phenos;
Fs = 80;
phe = 1; % TscHet 
strideVelFinal = zeros(1, 2);
strideVelFront = zeros(1, 2);
strideVelRear = zeros(1, 2);
% Calculate body velocity from centroid coordinates:
for an = 1:1 %length(ASD_all{1,1}(1,:)) 
    for day = 1:1%length( correctedTens5(pORa{phe}(1,an) , :) ) 
%         allPaws = permute( positions_pred_by_day{pORa{phe}(1,an),day}([5,6,12,13], : , :), [2 1 3]);
        clear allPaws numLimbs frames preX
        allPaws = permute( correctedTens5{pORa{phe}(1,an),day}([5,6,9,10], : , :), [2 1 3]);
        % OR allPaws = permute( correctedTens5{ASD_all{phe}(1,an),day}([5,6,9,10], : , :), [2 1 3]);
        numLimbs = size(allPaws, 2);
        frames = (1:size(allPaws,3))';
        % x-values for all paws (correct for pixels to mm (for each pixel,
        % there are 1.97 millimeters)
        preX = squeeze(allPaws(2,:,:))'; %/ 1.927;
        
        % For each paw, calculate which frames are peaks/valleys
        clearvars maxpkx minpkx
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
        
        clear centroidsF2
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
        
        % Get the animal's "files_by_day" ID
        num = num2str(files_by_day{pORa{phe}(1,an),day},'%04.f');
        % load translational info from real space to egocentric
        load(['/projects/SHAEVITZ/klibaite/mouseALIGNED/day1/OFT-',num,'-00_box_aligned_info.mat'],'tempinfo','tempJoints');
        
        tempJoints = positions_pred_by_day{pORa{phe}(1,an),day}([5,6,12,13], : , :);
        rotVal = rotation{pORa{phe}(1,an),day}; % this cell should be a vector of each frame's rotation?
        tempr = deg2rad(rotVal);
        
        tempCents = 200 * ones(4, 2, length(tempJoints));
        midJoints = double(tempJoints) - tempCents;


        jx = double(squeeze(midJoints(:,1,:)));
        jy = double(squeeze(midJoints(:,2,:)));
        ff = zeros(size(tempJoints));

        for i = 1:length(jx)

            [jp2j(:,i), jp2i(:,i)] = cart2pol(jx(:,i)',jy(:,i)');

            tjp(:,i) = jp2j(:,i) + repmat(tempr(i),[18 1]);

            [jp3j(:,i), jp3i(:,i)] = pol2cart(tjp(:,i),jp2i(:,i));

            ogc1(:,i) = jp3j(:,i) + centroidsF2(i,1);
            ogc2(:,i) = jp3i(:,i) + centroidsF2(i,2);
        end
        ff(:,1,:) = ogc1; 
        ff(:,2,:) = ogc2;

        % use 14 body parts from real space (all 95,000 frames)
        ff = ff([1:8 12:16 18],:,:);
        % only use the 14 body parts from boxed space (all 95,000 frames)
        tJ14 = tempJoints([1:8 12:16 18],:,:);
        
        
        
        % make scatterplot: stride length vs velocity:
        colors = {'r','r','k','k'};
        for k = 1:numLimbs
            % zeros(641,2)
            strideVsVel = zeros( size(maxpkx{1,k},1), 2); 
            % if index of first min < index of first max...
            if minpkx{1,k}(1,1) <= maxpkx{1,k}(1,1)
                for i = 1:size(maxpkx{1, k},1)-1
                    % stride length (max - min)
                    strideVsVel(i,1) = maxpkx{1,k}(i,2) - minpkx{1,k}(i,2);
                    % mean centroid velocity during that stride
                    strideVsVel(i,2) = mean( vel(minpkx{1,k}(i,1) : maxpkx{1,k}(i,1), 1));
                end
            % if the first max < first min
            else % minpkx{1,k}(1,1) > maxpkx{1,k}(1,1)
               for i = 1:size(maxpkx{1, k},1)-1
                    % stride length (max - min)
                    strideVsVel(i,1) = maxpkx{1,k}(i+1,2) - minpkx{1,k}(i,2);
                    % mean centroid velocity during that stride
                    strideVsVel(i,2) = mean( vel(minpkx{1,k}(i,1) : maxpkx{1,k}(i+1,1), 1));
               end 
            end
            
            strideVelFinal = [strideVelFinal; strideVsVel];
            
            if k == 1 || k == 2
                strideVelFront = [strideVelFront; strideVsVel];
            else % k = 3 || 4
                strideVelRear = [strideVelRear; strideVsVel];
            end
                
            figure(3)
            xNow = strideVsVel(:,2)*1.97;
            yNow = strideVsVel(:,1)*1.97;
            zNow = cell2mat(weights_WT_ASD(pORa{phe}(1,an)));
            scatter( xNow, yNow, 1, zNow, 'o')      %colors{k}, '+')
            colorbar
            hold all
        end
    end
end
strideVelFinal = strideVelFinal(2:end, :);

x = strideVelFinal(:,2);
y = strideVelFinal(:,1);

% % plot linear model
% tbl = table(x, y);
% mdl = fitlm(tbl,'linear');
% hMDL = plot(mdl);
% delete(hMDL(1))
% hFIT = findobj(hMDL,'DisplayName','Fit');
% hFIT.LineWidth = 2;
% hFIT.Color = 'blue';

% throw axis labels back on
ylabel('Stride length (mm)')
xlabel('Speed (mm/sec)')
% ylim([0 150])
% xlim([0 5])
title('Wild Type Mice')
legend('Rear Paws', 'Location','NorthWest')


% Use polynomial fit
[p, S] = polyfit(x,y,3);
x5 = linspace(1.2,14);
[y_fit,delta] = polyval(p,x5,S);
plot(x5, y_fit, 'b-', 'LineWidth', 2)
plot(x5,y_fit+2*delta,'b--', x5, y_fit-2*delta,'b--','LineWidth',2)
r_sqr = power(corr2(y_fit,x5),2);
 
% include r on plot
str = sprintf( 'r= %1.2f', r_sqr);
annotation('textbox', [0.8, 0.8, 0.1, 0.1], 'String', str)


% [p,S] = polyfit(x,y,n) returns the polynomial coefficients p and a structure S for use with polyval
%  to obtain error estimates or predictions. Structure S contains fields R, df, and normr, for the 
%  triangular factor from a QR decomposition of the Vandermonde matrix of x, the degrees of freedom,
%  and the norm of the residuals, respectively. If the data y are random, an estimate of the covariance
%  matrix of p is (Rinv*Rinv')*normr^2/df, where Rinv is the inverse of R. If the errors in the data y 
%  are independent normal with constant variance, polyval produces error bounds that contain at least 
%  50% of the predictions.



R = corrcoef(x,y);
R = R(1,2)
