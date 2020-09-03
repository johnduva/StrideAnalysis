% clearvars -except allPaws allTracks an keepersOnly correctedTens5 phe phenos PointColors

% 1 2 3 4 5 6 7 8 12 13 14 15 16 18: pull from 18: 5,6,12,13
%                  9 10 11 12 13 14: pull from 14: 5,6,9,10

% corrected to only include 10th behavior
load('/Users/johnduva/iCloud Drive (Archive) - 1/Desktop/mkislin Files/correctedTens5.mat'); 
% centroid tracks
load('/Users/johnduva/iCloud Drive (Archive) - 1/Desktop/mkislin Files/allTracks.mat'); 
% indices of frames that we want to keep for locomotion
load('/Users/johnduva/iCloud Drive (Archive) - 1/Desktop/mkislin Files/keepersOnly.mat');
% unique identifier for each individual video
load('/Users/johnduva/iCloud Drive (Archive) - 1/Desktop/mkislin Files/filenames.mat') % variable is called 'files_by_day.mat'
% animal weights (but maybe determine animal length instead)
load('/Users/johnduva/iCloud Drive (Archive) - 1/Desktop/mkislin Files/weights.mat');


% Jess' animals with injections: the first column is 60 wildtype animals, second is CNO only...
load('/Users/johnduva/Git/StrideAnalysis/John Analysis/Mat Files/phenosAll.mat')  % variable is called 'phenos'
% Three TSC groups: Hets, Homos, and Negatives
load('/Users/johnduva/Git/StrideAnalysis/John Analysis/Mat Files/ASD_all.mat')
% Three Cntnap groups: Hets, Homos, and Negatives
load('/Users/johnduva/Git/StrideAnalysis/John Analysis/Mat Files/Cntnap2_all.mat')


% this identifies each animal's phenotype
load('/Users/johnduva/iCloud Drive (Archive) - 1/Desktop/mkislin Files/group_by_day.mat'); 
% this identifies each animal's phenotype
load('/Users/johnduva/iCloud Drive (Archive) - 1/Desktop/mkislin Files/zygosity.mat'); % zygosity