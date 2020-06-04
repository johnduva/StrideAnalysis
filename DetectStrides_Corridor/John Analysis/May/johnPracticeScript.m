
load('/Users/johnduva/Desktop/tempJointPractice.mat','tempinfo','tempJoints');

tempc = tempinfo.centroidsF;
% tempt = tempinfo.translationF;
tempr = deg2rad(tempinfo.rotVal);
tempCents = 200 * ones(18,2,length(tempJoints));
midJoints = double(tempJoints) - tempCents;

jx = double(squeeze(midJoints(:,1,:)));
jy = double(squeeze(midJoints(:,2,:)));
ff = zeros(size(tempJoints));

for i = 1:length(jx)
    
    [jp2j(:,i), jp2i(:,i)] = cart2pol(jx(:,i)',jy(:,i)');
    
    tjp(:,i) = jp2j(:,i) + repmat(tempr(i),[18 1]);
    
    [jp3j(:,i), jp3i(:,i)] = pol2cart(tjp(:,i),jp2i(:,i));
    
    ogc1(:,i) = jp3j(:,i) + tempc(i,1);
    ogc2(:,i) = jp3i(:,i) + tempc(i,2);
end
ff(:,1,:) = ogc1; 
ff(:,2,:) = ogc2;
% clearvars tempc, tempt, tempr, tempCents,midJoints,jx,jy, 
% use 14 body parts from real space (all 95,000 frames)
ff = ff([1:8 12:16 18],:,:);
% only use the 14 body parts from boxed space (all 95,000 frames)
% tJ14 = tempJoints([1:8 12:16 18],:,:);

%%

% an 198

% get all of the tracks for LF palm
x5 = squeeze(ff(5,1,:))';
y5 = squeeze(ff(5,2,:))';

% get all of the tracks for LF toes
x7 = squeeze(ff(7,1,:))';
y7 = squeeze(ff(7,2,:))';

% right front palm
x6 = squeeze(ff(6,1,:))';
y6 = squeeze(ff(6,2,:))';

% right front toes
x8 = squeeze(ff(8,1,:))';
y8 = squeeze(ff(8,2,:))';

maxIndex = maxpkx{1,1}(:, 1);

% scatter joints in real frame
figure(1)
frm = 13:20;
% plot centroid
plot(tempc(maxIndex(frm),1), tempc(maxIndex(frm),2), '-o', 'Color', 'black')
hold on

% plot left palm
plot(x5(maxIndex(frm)), y5(maxIndex(frm)), '-o', 'Color', 'red')
hold on
% % plot left toes
% plot(x7(maxIndex(frm)), y7(maxIndex(frm)), '-o', 'Color', 'green')
% hold on
% % plot right palm
% plot(x6(maxIndex(frm)), y6(maxIndex(frm)), '-o', 'Color', 'cyan')
% hold on
% % plot right toes
% plot(x8(maxIndex(frm)), y8(maxIndex(frm)), '-o', 'Color', 'magenta')
% hold on

xlim([0 1.0743e+03])
ylim([200 1.0743e+03])
xlabel('Pixels')
ylabel('Pixels')
title('Real Space: Forepaw Traversal')
legend({'Centroid Location at Right Forepaw Touchdown','Right Forepaw Touchdown'}, 'Location','northwest')
% 
%         % scatter joints in aligned frame
%         figure(2)
%         scatter(tJ14(:,1,frame), tJ14(:,2,frame))
%         title('Aligned')


% plot centroid and limb positions over some short stretch of time during locomotion
% plot lines showing stance in real space for sample data
% plot lines showing length of steps in real space for sample data

% useful functions: scatter(), plot(), axis(), hold on, 
% set colors to specify the different measures, add legend
% save as image file

