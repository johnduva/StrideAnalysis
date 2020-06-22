% script to swap x-pixel coordinate with y-pixel coordinates
% (used because Wang Lab videos taken from underneath the animal, 
% compared to Carey lab who takes videos from the side)

%skeleton = RT_fixed;
function output = flipXYpixels(skeleton)
input = zeros(size(skeleton));

for i=1:length(input)
        input(1,1,i) = skeleton(2,1,i);
        input(2,1,i) = skeleton(1,1,i);
        input(3,1,i) = skeleton(3,1,i);
end
output = input;
end