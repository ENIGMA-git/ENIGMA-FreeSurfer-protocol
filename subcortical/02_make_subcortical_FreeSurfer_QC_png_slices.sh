#!/bin/bash
#$ -S /bin/bash

# Edit your subject list
for subj in subject1 subject2 subject3;
do
echo $subj

# Input directory, i.e. Freeurfer outputs
fs_dir=/enigma/Parent_Folder/FreeSurfer/outputs/
# QC output directory, i.e. where your PNGs will be saved
qc_dir=/enigma/Parent_Folder/FreeSurfer/QC_subcortical/

mkdir $qc_dir

b=${subj} #subject folder
imageF=${fs_dir}/${b}/mri/orig.mgz
overlay=${fs_dir}/${b}/mri/aparc+aseg.mgz

# Define where your script and matlab functions are saved from the zip file 
scripts=/enigma/Parent_Folder/scripts/ENIGMA_QC/
cd ${scripts}
dirs

if [ -f ${imageF} ]
then

matlabcall="func_make_subcorticalFS_ENIGMA_QC('${qc_dir}','${b}','${imageF}','${overlay}')"
/usr/local/matlab/bin/matlab -nodisplay -nosplash -singleCompThread -r "${matlabcall};quit"
echo 'Done with subject: ' ${subj}

else

echo 'Freesurfer files not found'

fi

done
