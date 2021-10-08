#!/bin/bash
#$ -S /bin/bash

# Edit your subject list
for subj in subject1 subject2 subject3;
do
echo $subj

# freesurfer parent directory
fs_dir=/enigma/Parent_Folder/FreeSurfer/outputs/
# QC output directory
qc_dir=/enigma/Parent_Folder/FreeSurfer/QC_subcortical/

mkdir $qc_dir

b=${subj} #subject folder
imageF=${fs_dir}/${b}/mri/orig.mgz
overlay=${fs_dir}/${b}/mri/aparc+aseg.mgz

#where your ENIGMA_QC folder is copied
cd /enigma/Parent_Folder/scripts/ENIGMA_QC/
dirs

if [ -f ${imageF} ]
then

matlabcall="func_make_subcorticalFS_ENIGMA_QC('${qc_dir}','${b}','${imageF}','${overlay}')"
/usr/local/MATLAB/R2014b/bin/matlab -nodisplay -nosplash -singleCompThread -r "${matlabcall};quit"
echo 'Done with subject: ' ${subj}

else

echo 'Freesurfer files not found'

fi

done
