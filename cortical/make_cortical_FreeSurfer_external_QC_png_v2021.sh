#!/bin/bash
#$ -S /bin/bash

printf "\n+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\n"
printf "Running External FreeSurfer \n"
printf "written by Iyad Ba Gari (IGC USC) - Apr 2021\n"
printf "+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\n"

# Input directory, ie Freeurfer outputs
fs_dir=/enigma/Parent_Folder/Freesurfer/outputs/
# Output directory, ie where your PNGs will be saved
qc_dir=/enigma/Parent_Folder/Freesurfer/QC_cortical_external
mkdir ${qc_dir}

# Define where your script and matlab functions are saved from the ENIGMA_QC_cortical_updApril2021.zip zip file 
scripts=/enigma/Parent_Folder/scripts/ENIGMA_QC/
cd ${scripts}

for subject in subject1 subject2 subject3;
do
# Define where matlab is located on your server
/usr/local/matlab/bin/matlab -nodisplay -batch "FS_external_QC('${fs_dir}', '${qc_dir}', '${subject}')"
done
