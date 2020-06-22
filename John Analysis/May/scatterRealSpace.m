
% load('tempJointPractice.mat','tempinfo','tempJoints');
tJ14 = tempJoints([1:8 12:16 18],:,:);
tempc = tempinfo.centroidsF;

% an 198

% get all of the tracks for LF palm
x1 = squeeze(tJ14(1,1,:))';
y1 = squeeze(tJ14(1,2,:))';

x2 = squeeze(tJ14(2,1,:))';
y2 = squeeze(tJ14(2,2,:))';

x3 = squeeze(tJ14(3,1,:))';
y3 = squeeze(tJ14(3,2,:))';

x4 = squeeze(tJ14(4,1,:))';
y4 = squeeze(tJ14(4,2,:))';

x5 = squeeze(tJ14(5,1,:))';
y5 = squeeze(tJ14(5,2,:))';

% right front palm
x6 = squeeze(tJ14(6,1,:))';
y6 = squeeze(tJ14(6,2,:))';

% get all of the tracks for LF toes
x7 = squeeze(tJ14(7,1,:))';
y7 = squeeze(tJ14(7,2,:))';

x8 = squeeze(tJ14(8,1,:))';
y8 = squeeze(tJ14(8,2,:))';

x9 = squeeze(tJ14(9,1,:))';
y9 = squeeze(tJ14(9,2,:))';

x10 = squeeze(tJ14(10,1,:))';
y10 = squeeze(tJ14(10,2,:))';

x11 = squeeze(tJ14(11,1,:))';
y11 = squeeze(tJ14(11,2,:))';

x12 = squeeze(tJ14(12,1,:))';
y12 = squeeze(tJ14(12,2,:))';

x13 = squeeze(tJ14(13,1,:))';
y13 = squeeze(tJ14(13,2,:))';

x14 = squeeze(tJ14(14,1,:))';
y14 = squeeze(tJ14(14,2,:))';

maxIndex = maxpkx{1,1}(:, 1);

% scatter joints in real frame
figure(1)
color = {'blue','red','green'};
frm = 2:4s; %:20;
% plot centroid
% plot(tempc(maxIndex(frm),1), tempc(maxIndex(frm),2), '-o', 'Color', 'red')
% hold on

plot(x1(maxIndex(frm)), y1(maxIndex(frm)), '-o', 'Color', 'blue')
hold on
plot(x2(maxIndex(frm)), y2(maxIndex(frm)), '-o', 'Color', 'blue')
hold on
plot(x3(maxIndex(frm)), y3(maxIndex(frm)), '-o', 'Color', 'blue')
hold on
plot(x4(maxIndex(frm)), y4(maxIndex(frm)), '-o', 'Color', 'blue')
hold on
% plot left palm
plot(x5(maxIndex(frm)), y5(maxIndex(frm)), '-o', 'Color', 'red')
hold on
plot(x6(maxIndex(frm)), y6(maxIndex(frm)), '-o', 'Color', 'black')
hold on
% plot left toes
plot(x7(maxIndex(frm)), y7(maxIndex(frm)), '-o', 'Color', 'magenta')
hold on
% plot right palm
plot(x8(maxIndex(frm)), y8(maxIndex(frm)), '-o', 'Color', 'black')
hold on
plot(x9(maxIndex(frm)), y9(maxIndex(frm)), '-o', 'Color', 'blue')
hold on
plot(x10(maxIndex(frm)), y10(maxIndex(frm)), '-o', 'Color', 'blue')
hold on
plot(x11(maxIndex(frm)), y11(maxIndex(frm)), '-o', 'Color', 'blue')
hold on
plot(x12(maxIndex(frm)), y12(maxIndex(frm)), '-o', 'Color', 'blue')
hold on
plot(x13(maxIndex(frm)), y13(maxIndex(frm)), '-o', 'Color', 'blue')
hold on
plot(x14(maxIndex(frm)), y14(maxIndex(frm)), '-o', 'Color', 'blue')
hold on

xlim([0 450])
% ylim([0 225])
xlabel('Pixels')
ylabel('Pixels')
title('Real Space: Forepaw Traversal')
% legend({'Centroid Location at Right Forepaw Touchdown','Right Forepaw Touchdown'}, 'Location','northwest')
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
