%%


for frame = 223 : length(allPaws2)
    scatter( allPaws2(1,1,frame), allPaws2(2,1,frame), 10, 'red', 'filled')
    hold on
    scatter( allPaws2(1,2,frame), allPaws2(2,2,frame), 10, 'red', 'filled' )
    hold on
    scatter( allPaws2(1,3,frame), allPaws2(2,3,frame), 10, 'blue', 'filled'  )
    hold on
    scatter( allPaws2(1,4,frame), allPaws2(2,4,frame), 5, 'blue', 'filled' )
    hold on
    xlim([170 250])
    ylim([0 250])
    pause(1)
    disp(frame)
    if mod(frame,15) == 0
        hold off
    end
end



% %% ASD_all or phenos:
% pORa = phenos;
% phe = 1; 
% an = 1; day = 1;
% allPaws2 = permute( correctedTens5{pORa{phe}(1,an),day}([5,6,9,10], : , :), [2 1 3]);
% 
% plot( allPaws2(k,2, maxpkx{1,k}(i+1) - allPaws2(k, 1, maxpkx{1,k}(i)) )
% 
