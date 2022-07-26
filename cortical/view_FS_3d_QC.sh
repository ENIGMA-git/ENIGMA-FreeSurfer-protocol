#!/bin/bash
#$ -S /bin/bash

# Run script: ./view_FS_3d_QC.sh <subject_id>

SUBJECT=$1

export LD_PATH_LIBRARY=${LD_PATH_LIBRARY}:/usr/local/freesurfer-v7.1.0/lib/vtk/lib/vtk-5.6 # update to your FreeSurfer version
export FREESURFER_HOME="/usr/local/freesurfer-v7.1.0" # update to your FreeSurfer version
export SUBJECTS_DIR=/enigma/Parent_Folder/FreeSurfer/outputs/ #change directory to where the FreeSurfer outputs are
cd ${SUBJECTS_DIR}

freeview -v ${SUBJECT}/mri/orig.mgz \
  $SUBJECT/mri/aparc+aseg.mgz:colormap=lut:opacity=0.4

freeview -f  ${SUBJECT}/surf/lh.pial:annot=aparc.annot:name=pial_aparc:visible=0 \
  ${SUBJECT}/surf/rh.pial:annot=aparc.annot:name=pial_aparc:visible=0 \
  --viewport 3d 
