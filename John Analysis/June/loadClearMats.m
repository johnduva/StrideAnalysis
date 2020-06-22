% clearvars -except allPaws allTracks an keepersOnly correctedTens5 phe phenos PointColors

% 1 2 3 4 5 6 7 8 12 13 14 15 16 18: pull from 18: 5,6,12,13
%                  9 10 11 12 13 14: pull from 14: 5,6,9,10


load('/Users/johnduva/iCloud Drive (Archive) - 1/Desktop/mkislin Files/allTracks.mat');
load('/Users/johnduva/iCloud Drive (Archive) - 1/Desktop/mkislin Files/correctedTens5.mat');
load('/Users/johnduva/iCloud Drive (Archive) - 1/Desktop/mkislin Files/keepersOnly.mat');
load('/Users/johnduva/iCloud Drive (Archive) - 1/Desktop/mkislin Files/filenames.mat') % files_by_day.mat
load('/Users/johnduva/iCloud Drive (Archive) - 1/Desktop/mkislin Files/weights.mat');

load('/Users/johnduva/Git/StrideAnalysis/John Analysis/phenosAll.mat')
load('/Users/johnduva/Git/StrideAnalysis/John Analysis/ASD_all.mat') 