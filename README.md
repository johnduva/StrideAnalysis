This repo is a collection of analysis scripts that intake LEAP coordinate locations and output (1) minimum and maximum peaks (euclidean distances from centroid) for all paws, (2) data structures for analyzing features of locomotion (i.e. stride length, animal velocity, stance width, paw synchrony, etc), (3) existing figures for comparing the aforementioned features, and (3) movies for analyzing degree of diagonal paw lag.

The 'John Analysis' directory is comprised of:
 - .mat files == filtered data structs from 
 - .m files   == data preprocessing and analysis
 - .png files == figures
 - .avi files == mouse videos (four paws only)

The 'LocoMouse' directory was originally pulled from Prof. Megan Carey's laboratory at Champalimaud Foundation. The remaining scripts have been significantly altered to handle the Wang Lab's LEAP tracking data, while the rest were removed since they were not applicable. 

The most important files in this repo are the following:
- /John Analysis/Mat files/: These contain the indices for identifying which of the 382 animals are TSC, Cntnap, Wildtype, or injection. ASD_all.mat and Cntnap2_all.mat are broken up into three different cells: hets, homos, and negative respectively. The identifiers in the first row within each cell reference the row in the 382x5 matrix (and thereby reference individual mice of that phenotype and zygosity).