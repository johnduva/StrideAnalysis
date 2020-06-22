correctedTens5{198,1}()
allPaws = permute( correctedTens5{198,1}([5,6,9,10], : , :), [2 1 3]);


RT = squeeze(allPaws(2,1,:))';
LT=squeeze(LF)';

paws=[RT(:,1),LT(:,1)];
plot(paws)
colors={'r','b'};
for n=1:2
    plot(paws(:,n),'color',colors{n}); hold on; 
         [stance_pts{n}, swing_pts{n}] = peakdet(paws(:,n), 3);% if including index on x
          plot(stance_pts{n}(:,1),stance_pts{n}(:,2),'mo')
           plot(swing_pts{n}(:,1),swing_pts{n}(:,2),'gs'); hold on;
                
         
end