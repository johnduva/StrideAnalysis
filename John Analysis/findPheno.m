% Loop through keepersOnly to group all animals with same phenotype together.
% Each row (column?) will be a phenotype, and within it will be a list of the 'keepersOnly' rows of that phenotype
phenos = {};
for an = 1:size(group_by_day,1)
    for day = 1:size(group_by_day,2)
        % if animal is a LobVI1D...
        if strcmp( group_by_day{an,day},'Cntnap2') 
            % get labels from all four paws of animal
            allPaws = correctedTens{an,day}([5,6,9,10],:,:);
            % set to proper format for LocoMouse analysis
            allPaws2 = permute(allPaws,[2,1,3]);
%             % get minpeakx and maxpeakx
%             StrideData = StrideDetection_OG(allPaws2,80);
        end
    end
end  

%% Create array of animal IDs that belong to desired phenotype

% get all of the sessions for [vehicle] animals...
Cntnap2_Het = [];
index = 1;
for an = 1:size(group_by_day,1)
    for day = 1:size(group_by_day,2)
        % if animal is a 'xxx'...
        if strcmp( group_by_day{an,day},'Cntnap2') && strcmp(zygosity{an,day},'heterozygote') && ~ismember(an,Cntnap2_Het)
            Cntnap2_Het(index) = an;
            index = index + 1;
        end
    end
end

