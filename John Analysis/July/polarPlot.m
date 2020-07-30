thArray= [];
rArray = [];
for i = 1 : 1061
    cycle = maxpkx{1}(i+1,1) - maxpkx{1}(i,1);
    disp(i);
%     th = (maxpkx{1}(i,1) - maxpkx{1}(i,1)) / cycle * 360 * 2 * pi;
%     r = vel(maxpkx{1}(i,1));
%     polarscatter(th,r,2,'b')
%     hold on 
    
    for j = 1 : 1061
        if maxpkx{2}(j,1) < maxpkx{1}(i+1,1) && maxpkx{2}(j,1) > maxpkx{1}(i,1)
            
            th = deg2rad( (maxpkx{2}(i,1) - maxpkx{1}(i,1) ) / cycle * 360 ) ;
            thArray = [thArray; th];
            % distance from center = speed
            r = vel(maxpkx{1}(i,1));
            rArray = [rArray; r];
            polarscatter(th,r,2,'r')
            hold on 
            
        else
            continue
        end
    end
    
%     th = (maxpkx{3}(i,1) - maxpkx{1}(i,1)) / cycle * 360 * 2 * pi;
%     % distance from center = speed
%     r = vel(maxpkx{1}(i,1));
%     polarscatter(th,r,2,'g')
%     hold on 

    
%     th = deg2rad( (maxpkx{4}(i,1) - maxpkx{1}(i,1)) / cycle * 360);
%     if th > 2*pi
%         th = th - 2*pi;
%     end
%     % distance from center = speed
%     r = vel(maxpkx{1}(i,1));
%     polarscatter(th,r,2,'b')
%     hold on 
end






% %% Test
% th = maxpkx{1}(:,2)) 
% r = vel(maxpkx{2}(1:end-1,1));
% polarscatter(th,r,2)
% hold on
% 
% th = deg2rad(preY(maxpkx{3}(:,1), 3)/360);
% r = vel(maxpkx{3}(:,1));
% polarscatter(th,r,1)
% hold on
% 
% th = deg2rad(maxpkx{4}(:,2))+pi;
% r = vel(maxpkx{4}(:,1));
% polarscatter(th,r,1)
% hold on