%% Bring weights from Jess' spreadsheet ('WT.mat') into our 382x5 'group_by_day' matrix. 

clear weights;
count = 0;
for i = 1:length(files_by_day)
    for ii = 1:92
        % Get the 'OFT-xxxx' name from WT
        A = cell2mat(WT(ii,3));
        % Extract the xxxx, turn it from cell to str, then str to num
        B = str2num(cell2mat(regexp(A,'\d*','Match')));
        % Do it again for the next column to make certain they're the same animal
        A2 = cell2mat(WT(ii,4));
        % Extract the xxxx, turn it from cell to str, then str to num
        B2 = str2num(cell2mat(regexp(A2,'\d*','Match')));
        
        % if that num == files_by_day(i,1) && 
        if B == cell2mat(files_by_day(i,1))  &&  B2 == cell2mat(files_by_day(i,2)) 
            weights(i,1) = cell2mat(WT(ii,2));
            count = count + 1;
        end
    end
end
disp(count);


%% Loop through the WT mice to see which of them now have a weight

for i = 1:length(group_by_day)
    if convertCharsToStrings(cell2mat(group_by_day(i,1))) == convertCharsToStrings(cell2mat({'C57Bl'}))
        group_by_day(i,6) = {weights(i)};
    end
end

% all 60 of the WT mice have a weight. we have ignored the "C57Blfemale"s


