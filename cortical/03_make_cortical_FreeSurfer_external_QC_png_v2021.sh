#!/bin/bash
#$ -S /bin/bash

printf "\n+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\n"
printf "Running External FreeSurfer \n"
printf "written by Iyad Ba Gari (IGC USC) - Apr 2021\n"
printf "+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\n"

# Input directory, i.e. Freeurfer outputs
fs_dir=/enigma/Parent_Folder/Freesurfer/outputs/
# QC output directory, i.e. where your PNGs will be saved
qc_dir=/enigma/Parent_Folder/FreeSurfer/QC_cortical_external
mkdir -p ${qc_dir}

# Define where your script and matlab functions are saved from the zip file 
scripts=/enigma/Parent_Folder/scripts/ENIGMA_QC/
cd ${scripts}

for subj in subject1 subject2 subject3;
do
# Define where matlab is located on your system
/usr/local/matlab/bin/matlab -nodisplay -batch "FS_external_QC('${fs_dir}', '${qc_dir}', '${subj}')"
done
