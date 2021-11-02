#!/bin/bash
#$ -S /bin/bash

# Edit your subject list
for subj in subject1 subject2 subject3;
do
echo $subj

# freesurfer parent directory
fs_dir=/enigma/Parent_Folder/FreeSurfer/outputs/
# QC output directory
qc_dir=/enigma/Parent_Folder/FreeSurfer/QC_cortical_internal/

mkdir ${qc_dir}

b=${subj} #subject folder
imageF=${fs_dir}/${b}/mri/orig_nu.mgz
overlay=${fs_dir}/${b}/mri/aparc+aseg.mgz

#where your ENIGMA_QC folder is copied
cd /enigma/Parent_Folder/scripts/ENIGMA_QC/
dirs

if [ -f ${imageF} ]
then

matlabcall="func_make_corticalpngs_ENIGMA_QC('${qc_dir}','${b}','${imageF}','${overlay}')"
# Point to where your matlab is saved
/usr/local/matlab/bin/matlab -nodisplay -nosplash -singleCompThread -r "${matlabcall};quit"
echo 'Done with subject: ' ${subj}

else
echo 'Freesurfer files not found'

fi

done
