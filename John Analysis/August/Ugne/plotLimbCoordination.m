function [] = plotLimbCoordination(groups,labels,out_path,fig_path,idxv2,sH,pixel_size)
%% locomotion analysis from tracked joints
% version 1 - 2020-07-28, Klibaite
% skeleton used ->
% load('/home/ugne/Dropbox/MARCH_2020/mouseSkeletonSimple_400.mat')


% joints are saved in variable jointsCON ->
% load('/Users/ugne/Dropbox/manuscriptMOUSE/jointsCON.mat');
% this is a 1x8 cell array corresponding to each condition (cntnap2(1,2,3),
% L7-tsc1(4,5,6), Black6 males (7) and Black6 females (8)
% each cell holds a [numMouse x numDay] cell array corresponding to mouse
% and day for each trial in that condition
% jointsCON{condition}{mouseNum,dayNum} -> 18x2xt array of joint positions
% corresponding to skeleton

% NOTE: at the moment it only works for C57Bl, day = 1, mouse = 1 because I
% downloaded only this mouseInfo file

if ~exist(fig_path,'dir')
    mkdir(fig_path)
end

n_groups = length(groups);

%% load data for the group
jointsCON = cell(1,n_groups);
C1CON = cell(1,n_groups);
tracksCON = cell(1,n_groups);
%load('/Users/bergeler/Documents/Mouse Behavior/Data/mouseAligned/OFT-0064-00_box_aligned_info.mat','mouseInfo');

% load joint data
for g = 1:n_groups
    StatesPath = [out_path 'k100/' groups{g} '.mat'];
    load(StatesPath,'dataLEAPout','dataDC','dataTracks');
    % only consider first day and mouse (can be deleted later, when we have all mouseInfo files)
    % dataLEAPout = dataLEAPout{1,1};
    % dataDC = dataDC{1,1};
    % joints = convertToRealCoordinates(dataLEAPout, mouseInfo);
    % jointsCON{g} = {dataLEAPout}; 
    % C1CON{g} = {dataDC};
    jointsCON{g} = dataLEAPout;
    C1CON{g} = dataDC;
    tracksCON{g} = dataTracks;
end

%% calculate measures of interest
if ~exist([fig_path 'locoCONall.mat'],'file')
    getDataPerStrideLocomotion(jointsCON,C1CON,tracksCON,idxv2,sH,fig_path)
end

% load data
load([fig_path 'locoCONall.mat'],'locoCONall')

%% sort through snippets to find info and phase matches for matched time points

if ~exist([fig_path 'locoCONall_step2_infoAndSteps.mat'],'file')
    stepsCON = cell(1,n_groups); % info about data
    phaseCON = cell(1,n_groups); % phases of paws (in radiant)
    for con = 1:n_groups
        tcon = locoCONall{con};
        ni = length(tcon.cv); % number of snippets for all mice and days
        paw1 = [];
        paw2 = [];
        paw3 = [];
        paw4 = [];
        day = [];
        mouse = [];
        vv = [];
        place = [];
        headv = [];
        ssnum = [];
        % check here for offsets
        for i = 1:ni
            cv = tcon.cv{i}.*(80*pixel_size/1000); % 80fps, factor 1000 to get from mm to m; I added the pixel_size!
            %jv = tcon.jv{i};
            %trace = tcon.trace{i};
            rose = tcon.rose{i}; % phases of paws
            idx = tcon.idx{i}+1; % Why +1?
            d = tcon.day{i};
            cent = tcon.place{i};
            m = tcon.mouse{i};
            hv = tcon.turn{i}(idx); % heading angular velocity at phase = 0
            
            ss = size(rose,2);
            paw1 = [paw1; deg2rad(rose(1,:))'];
            paw2 = [paw2; deg2rad(rose(2,:))'];
            paw3 = [paw3; deg2rad(rose(3,:))'];
            paw4 = [paw4; deg2rad(rose(4,:))'];
            day = [day; repmat(d,[ss 1])];
            mouse = [mouse; repmat(m,[ss 1])];
            vv = [vv; cv(idx)];
            place = [place; cent];
            headv = [headv; hv];
            ssnum = [ssnum; [1:ss]'];
        end
        infoCON = [mouse day ssnum vv headv place];
        specs =  [paw1 paw2 paw3 paw4];
        stepsCON{con} = infoCON;
        phaseCON{con} = specs;
    end
    
    save([fig_path 'locoCONall_step2_infoAndSteps.mat'],'stepsCON','phaseCON','-v7.3');
else
    load([fig_path 'locoCONall_step2_infoAndSteps.mat'],'stepsCON','phaseCON');
end

%% specify bin sizes here for centroid velocity and angular velocity
abins = [-pi,pi];%[-3 -1 1 3]; % angular velocity bins
al = length(abins)-1;
hx = 0:.05:1;
infoCON = cell(al,n_groups); % median / std / number of samples of paw phases for each bin ('al' angular bins and 20 centroid velocity bins) 
roseCON = cell(al,n_groups); % median of paw phases for each bin ('al' angular bins and 20 centroid velocity bins) 
% NOTE: roseCON not needed!?

for con = 1:n_groups
    consteps = stepsCON{con};
    conphase = phaseCON{con};
    
    for ai = 1:al
        % only consider data with specific values for angular velocity
        tempa = consteps(:,5); % headv
        ax = find(tempa > abins(ai) & tempa < abins(ai+1));
        vsort = consteps(ax,4); % centroid velocity
        
        % get median / number of samples / std of phases
        tsa = nan(length(hx)-1,4); % median of paw phases for each centroid velocity bin 
        nsa = zeros(length(hx)-1,1); % number of samples 
        vsa = nan(length(hx)-1,4); % standard deviation of paw phases for each centroid velocity bin
        for j = 1:(length(hx)-1)
            useic = find(hx(j) <= vsort & vsort <= hx(j+1));
            % temps = consteps(ax(useic),:);
            tphase = conphase(ax(useic),:); % phases for specific angular and centroid velocity range
            tsa(j,:) = median(tphase,1); 
            nsa(j) = size(tphase,1); 
            vsa(j,:) = std(tphase,1);
        end
        
        allsa = [tsa nsa vsa];
        infoCON{ai,con} = allsa;
        roseCON{ai,con} = tsa;
    end 
end

%% plot all angle bins 

for g = 1:n_groups
    figure('Position',[500,500,500,1000])
    for ai = 1:3 % angular velocity bins
        subplot(3,1,ai);
        allsa = infoCON{ai,g};
        sz = allsa(:,5); % number of samples
        sz(sz==0) = nan;
        mz = sum(sz,'omitnan'); % total number of samples
        
        sz = 300*sz./mz; % use number of samples as size of scatter points
        % scatter plot of median phase values
        polarscatter(allsa(:,1),hx(2:end),sz,'red','filled'); hold on; % better: mean([hx(2:end) hx(1:end-1)])?
        polarscatter(allsa(:,2),hx(2:end),sz,'blue','filled'); hold on;
        polarscatter(allsa(:,3),hx(2:end),sz,[152 78 163]./255,'filled'); hold on;
        polarscatter(allsa(:,4),hx(2:end),sz,'cyan','filled'); hold on;
        rlim([0 0.5])
    end
    sgtitle(labels{g})
    saveas(gcf,[fig_path groups{g} '_loc.png']);
    close(gcf)
end

%% one plot with all groups
figure('Position',[500,500,1000,1000])
for g = 1:n_groups
    subplot(2,3,g);
    allsa = infoCON{1,g};
    sz = allsa(:,5); % number of samples
    sz(sz==0) = nan;
    mz = sum(sz,'omitnan'); % total number of samples
    
    sz = 300*sz./mz; % use number of samples as size of scatter points
    % scatter plot of median phase values
    polarscatter(allsa(:,1),hx(2:end),sz,'red','filled'); hold on; % better: mean([hx(2:end) hx(1:end-1)])?
    polarscatter(allsa(:,2),hx(2:end),sz,'blue','filled'); hold on;
    polarscatter(allsa(:,3),hx(2:end),sz,[152 78 163]./255,'filled'); hold on;
    polarscatter(allsa(:,4),hx(2:end),sz,'cyan','filled'); hold on;
    rlim([0 0.9])
    title(labels{g})
end
saveas(gcf,[fig_path 'all_groups_loc.png']);
close(gcf)

end
