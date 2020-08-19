function [] = getDataPerStrideLocomotion(jointsCON,C1CON,tracksCON,idxv2,sH,save_path)

%% STEP 1: get data of interest for longer locomotion bouts only
juse = [7 8 14 15 16 17 18]; % joints of interest: LF toes, RF toes, LH toes, RH toes, tti, point on tail, tail end
jusexy = [juse juse+18];
% just locomotion sorting
n_groups = length(jointsCON);
MCLCON = cell(1,n_groups);
for con = 1:n_groups
    [mN, dN] = size(jointsCON{con}); % mN: number of mice, dN: number of days
    MCL = cell(mN, dN);
    for m = 1:mN
        fprintf(1,['Processing mouse # ' num2str(m) '\n']);
        for d = 1:dN
            %try
            % get joints for specific mouse and day
            ja20 = jointsCON{con}{m,d}; % 18x2xn_frames
            % get behavioral predictions (in 1:M)
            c100 = C1CON{con}{m,d};
            r100 = sH(idxv2(c100)); % r100 = sortid8(c100);
            % sort runs through the center and edges?
            % consider locomotion (slow / medium / fast) only
            % NOTE: the behavioral classes that correspond to locomotion
            % might be different for different M!!!
            cc = bwconncomp(r100 == 6 | r100 == 7 | r100 == 8);
            
            % get length of locomotion bouts
            cl = zeros(length(cc.PixelIdxList),1);
            for i = 1:length(cl)
                cl(i) = length(cc.PixelIdxList{i});
            end
            
            % take only bouts with more or equal than 80 frames
            c2.PixelIdxList = cc.PixelIdxList(cl >= 80);
            lc2 = length(c2.PixelIdxList); % number of bouts longer than 80 frames
            
            % center, rotate and smooth the data
            p1Center = findP1Center(ja20); % 36 x n_frames (18 x-pos + 18 y-pos)
            
%             % plot data for first 5 frames
%             C = parula(18);
%             figure()
%             for i=1:5
%                 scatter(p1Center(1:18,i),p1Center(19:end,i),[],C)
%                 hold on
%             end
%             axis equal
%             xline(0);
%             yline(0);
            
            i = 9; % point on body of animal
            jt1 = double(squeeze(ja20(i,:,:)));
            jt1(1,:) = smooth(medfilt1(jt1(1,:),4),40); % x-coordinate
            jt1(2,:) = smooth(medfilt1(jt1(2,:),4),40); % y-coordinate
            i = 16; % tti
            jt2 = double(squeeze(ja20(i,:,:)));
            jt2(1,:) = smooth(medfilt1(jt2(1,:),4),40);
            jt2(2,:) = smooth(medfilt1(jt2(2,:),4),40);
            
            n = size(jt1,2); % number of frames (was not defined)
            centpt = zeros(n,2);  % center position (between point on body and tti)
            heada = zeros(n,1); % angle of direction
            centpt(:,1) = (jt1(1,:)+jt2(1,:))./2;
            centpt(:,2) = (jt1(2,:)+jt2(2,:))./2;
            dir = jt2-jt1; % vector from point 9 to tti
            for i = 1:n
                heada(i) = atan2d(dir(2,i),dir(1,i));
            end
            h2a = smooth(unwrap(heada),20);
            headav = [0; diff(h2a)]; % angular velocity (by frame)
            
            % calculate center velocity
            vt = [0 0; diff(centpt)];
            vt = sqrt(sum(vt.^2,2));
            % cent = vt;
            
            % replace large velocities by linear approximation and
            % smooth data
            vt(vt>10) = nan;
            vt = fillmissing(vt,'linear');
            vt = smooth(vt,20);
            
            % get center velocity based on track data
            tracks = tracksCON{con}{m,d};
            vtracks = [0 0; diff(tracks)];
            vtracks = sqrt(sum(vtracks.^2,2));
            
            % replace large velocities by linear approximation and
            % smooth data
            % vtracks(vtracks > 25) = nan;
            % vtracks = fillmissing(vtracks,'linear');
            vtracks = smooth(vtracks,20);
            
            % for each bout, save all infos
            linfo = cell(lc2,6); % lc2: number of bouts to consider
            clear pt ptc ptmid dtrav dd ts cvel avel acfrac
            for i = 1:lc2
                pt = ja20(:,:,c2.PixelIdxList{i}); % joint positions
                ptc = p1Center(jusexy,c2.PixelIdxList{i}); % centered and aligned joint positions
                cvel = vt(c2.PixelIdxList{i}); % center velocity of mouse
                tvel = vtracks(c2.PixelIdxList{i}); % velocity of mouse using 'track' position 
                linfo{i,1} = ptc;
                linfo{i,2} = pt;
                linfo{i,3} = tvel; %cvel;
                linfo{i,4} = centpt(c2.PixelIdxList{i},:); % center positions (midpoint between tti and pos 9)
                linfo{i,5} = heada(c2.PixelIdxList{i}); % orientations of the mouse
                linfo{i,6} = headav(c2.PixelIdxList{i}); % angular velocities
            end
            MCL{m,d} = linfo;
            %catch MExc
            %end
        end
    end
    MCLCON{con} = MCL;
end
% save - all packaged info per snippet
save([save_path 'MCLCON_allinfo.mat'],'MCLCON','-v7.3')

%% STEP2:
% have locoCONall - now collect data for each stride in each snippet

% cv - centroid velocity
% jv - joint velocities
% trace - all joint traces - real space
% rose - phase angle of each paw at timepoint captured
% idx - frame index for timepoints used
% day - recording day number
% mouse - mouse number within condition
% place - centroid coord @ phase 0
% placeA - centroid coordinates for entire snippet
% mtj - centered/rotated coordinates of joints used (juse)
% heada - heading
% shape - path traveled
% turn - heading angular velocity

locoCONall = cell(1,n_groups);
for con = 1:n_groups
    % create struct to save the info
    locoCON.cv = [];
    locoCON.jv = [];
    locoCON.trace = [];
    locoCON.rose = [];
    locoCON.idx = [];
    locoCON.day = [];
    locoCON.mouse = [];
    locoCON.place = [];
    locoCON.placeA = [];
    locoCON.mtj = [];
    locoCON.heada = [];
    locoCON.shape = [];
    locoCON.turn = [];
    ccount = 1;
    
    mclcon = MCLCON{con};
    [mN, dN] = size(mclcon);
    for m = 1:mN % for all mice
        fprintf(1,['Processing mouse # ' num2str(m) '\n']);
        for d = 1:dN % for all days
            mt = mclcon{m,d};
            jN = size(mt,1); % number of frames of this snippet
            for j = 1:jN
                mtj = mt{j,1}; % centered and aligned joint positions of interest (7 8 14 15 16 17 18, x and y)
                
                % resample data at higher rate using lowpass interpolation
                mtji = zeros(size(mtj,1),size(mtj,2)*100);
                for x = 1:size(mtj,1)
                    mtji(x,:) = interp(mtj(x,:),100);
                end
                
                % get velocities of joints in real space
                mt5 = double(mt{j,2}); % joint positions
                vt5 = zeros(7,size(mt5,3));
                vt5(1,:) = [0; sqrt(diff(squeeze(mt5(7,1,:))).^2 + diff(squeeze(mt5(7,2,:))).^2)];
                vt5(2,:) = [0; sqrt(diff(squeeze(mt5(8,1,:))).^2 + diff(squeeze(mt5(8,2,:))).^2)];
                vt5(3,:) = [0; sqrt(diff(squeeze(mt5(14,1,:))).^2 + diff(squeeze(mt5(14,2,:))).^2)];
                vt5(4,:) = [0; sqrt(diff(squeeze(mt5(15,1,:))).^2 + diff(squeeze(mt5(15,2,:))).^2)];
                vt5(5,:) = [0; sqrt(diff(squeeze(mt5(16,1,:))).^2 + diff(squeeze(mt5(16,2,:))).^2)];
                vt5(6,:) = [0; sqrt(diff(squeeze(mt5(17,1,:))).^2 + diff(squeeze(mt5(17,2,:))).^2)];
                vt5(7,:) = [0; sqrt(diff(squeeze(mt5(18,1,:))).^2 + diff(squeeze(mt5(18,2,:))).^2)];
                
                % find peaks in the z-scores of centered and aligned
                % y-positions of the toes to get strides (8: LF, 9: RF, 10:
                % LH, 11: RH)
                ztj = zscore(mtji')';
                [~, id1] = findpeaks(ztj(8,:),'MinPeakProminence',.5); % peaks with vertical drop of at least half a peak
                [~, id2] = findpeaks(ztj(9,:),'MinPeakProminence',.5);
                [~, id3] = findpeaks(ztj(10,:),'MinPeakProminence',.5);
                [~, id4] = findpeaks(ztj(11,:),'MinPeakProminence',.5);
                
                % rewrite phase-getting to check between 0-2pi for paw1
                % sl = size(mtji,2);
                % nid = length(id1)-1;
                % for i = 1:nid
                %     set = id1(i):id1(i+1);
                % end
                
                % calculate phases of paw motions
                phase = nan(4,length(id1)-1);
                use1 = zeros(1,length(id1)-1); % 1 if stride is used, otherwise 0
                for i = 1:length(id1)-1
                    set = id1(i):id1(i+1);
                    is2 = intersect(set,id2);
                    is3 = intersect(set,id3);
                    is4 = intersect(set,id4);
                    p1s = linspace(0,360,length(set));
                    % only if peaks for all paws are found in the interval
                    % between 2 peaks of the left front toe, the stride is
                    % considered
                    if length(is2)==1 && length(is3)==1 && length(is4)==1
                        p2 = p1s(set==is2);
                        p3 = p1s(set==is3);
                        p4 = p1s(set==is4);
                        use1(i) = 1;
                        phase(1,i) = 0;
                        phase(2,i) = p2;
                        phase(3,i) = p3;
                        phase(4,i) = p4;
                    end
                end
                pn1 = round(id1(find(use1==1))./100); % frame indices for timepoints used (start)
                pcon = phase(:,find(use1==1)); % phase info of time intervals used
                locoCON.day{ccount} = d;
                locoCON.mouse{ccount} = m;
                locoCON.cv{ccount} = mt{j,3};
                locoCON.jv{ccount} = vt5;
                locoCON.trace{ccount} = mt5;
                locoCON.rose{ccount} = pcon;
                locoCON.idx{ccount} = pn1;
                locoCON.place{ccount} = mt{j,4}(pn1,:);
                locoCON.placeA{ccount} = mt{j,4};
                locoCON.mtj{ccount} = mtj;
                locoCON.heada{ccount} = mt{j,5};
                locoCON.turn{ccount} = mt{j,6};
                locoCON.shape{ccount} = mt{j,4}-mt{j,4}(1,:);
                ccount = ccount+1;
            end
        end
    end
    locoCONall{con} = locoCON;
end

save([save_path 'locoCONall.mat'],'locoCONall','-v7.3');

end