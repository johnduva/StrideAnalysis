% clearvars -except allPaws allTracks an keepersOnly correctedTens5 phe phenos PointColors

% 1 2 3 4 5 6 7 8 12 13 14 15 16 18: pull from 18: 5,6,12,13
%                  9 10 11 12 13 14: pull from 14: 5,6,9,10

load('/Users/johnduva/iCloud Drive (Archive) - 1/Desktop/mkislin Files/correctedTens5.mat');
load('/Users/johnduva/iCloud Drive (Archive) - 1/Desktop/mkislin Files/allTracks.mat');
load('/Users/johnduva/iCloud Drive (Archive) - 1/Desktop/mkislin Files/keepersOnly.mat');
load('/Users/johnduva/iCloud Drive (Archive) - 1/Desktop/mkislin Files/filenames.mat') % files_by_day.mat
load('/Users/johnduva/iCloud Drive (Archive) - 1/Desktop/mkislin Files/weights.mat');

load('/Users/johnduva/Git/StrideAnalysis/John Analysis/Mat Files/phenosAll.mat')  % phenos
load('/Users/johnduva/Git/StrideAnalysis/John Analysis/Mat Files/ASD_all.mat')
load('/Users/johnduva/Git/StrideAnalysis/John Analysis/Mat Files/Cntnap2_all.mat')

load('/Users/johnduva/iCloud Drive (Archive) - 1/Desktop/mkislin Files/group_by_day.mat'); % phenotype
load('/Users/johnduva/iCloud Drive (Archive) - 1/Desktop/mkislin Files/zygosity.mat'); % zygosity