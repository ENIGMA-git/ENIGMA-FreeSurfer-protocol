#!/bin/bash
#$ -S /bin/bash

# Change fs_dir to the directory where you want your freesurfer outputs to be saved. Do not create the subject folders - just this parent directory. We recommend adding your FS version to your directory name, eg Freesurfer_v7.1.0 instead of just Freesurfer
fs_dir=/enigma/Parent_Folder/FreeSurfer/outputs/
mkdir -p $fs_dir

# Set the environment and select the FreeSurfer version your working group is working with, i.e., 5.3, 6.0, 7.1. 
export FREESURFER_HOME="/usr/local/freesurfer-v7.1.1"
export SUBJECTS_DIR=$fs_dir
source $FREESURFER_HOME/SetUpFreeSurfer.sh

# List your subject IDs
for subj in subject1 subject2 subject3;
do

# Edit the pathway for your T1w images
input=/enigma/Parent_Folder/T1/${subj}_T1.nii.gz

$FREESURFER_HOME/bin/recon-all -autorecon-all -i ${input} -s ${subj} -3T -no-isrunning 

done
