% Plot sinusoidal timeseries of egocentric paw distance from centroid
% allPaws = permute( correctedTens5{198,1}([5,6,9,10], : , :), [2 1 3]);

pORa = ASD_all;
phe = 1;
an = 1; day = 1;
allPaws = permute( correctedTens5{pORa{phe}(1,an),day}([5,6,9,10], : , :), [2 1 3]);
RTfront = squeeze(allPaws(2,1,:));
RTrear = squeeze(allPaws(2,3,:));
paws = [ RTfront(:,1), RTrear(:,1) ];
clear RT LT

plot(paws)
colors={'r','b'};
for n=1:2 
    plot(paws(:,n),'color',colors{n}); 
    lgd = legend('Left Forepaw', 'Left Hindpaw', 'location', 'NorthWest');
    lgd.FontSize = 14;
    title('C57Bl Paw Synchrony')
    xlabel('Frame')
    ylabel('Paw Distance from Centroid')
    hold on; 
%     plot(vel*100); hold on;
%     [stance_pts{n}, swing_pts{n}] = peakdet(paws(:,n), 3);% if including index on x
%     
%     plot(stance_pts{n}(:,1),stance_pts{n}(:,2),'mo')
%     plot(swing_pts{n}(:,1),swing_pts{n}(:,2),'gs'); hold on;
                
         
end