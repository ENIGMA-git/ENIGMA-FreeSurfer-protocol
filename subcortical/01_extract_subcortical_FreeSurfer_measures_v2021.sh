#!/bin/bash
#$ -S /bin/bash

# Input directory, i.e. Freeurfer outputs
fs_dir=/enigma/Parent_Folder/FreeSurfer/outputs/
# Output directory, i.e. where your csv's will be saved
dir=/enigma/Parent_Folder/FreeSurfer/measures/

mkdir -p ${dir}

cd ${fs_dir} 
echo "SubjID,LLatVent,RLatVent,Lthal,Rthal,Lcaud,Rcaud,Lput,Rput,Lpal,Rpal,Lhippo,Rhippo,Lamyg,Ramyg,Laccumb,Raccumb,ICV" > ${dir}LandRvolumes.csv

for subj_id in `ls -d Subj*`
do 
printf "%s,"  "${subj_id}" >> ${dir}LandRvolumes.csv
for x in Left-Lateral-Ventricle Right-Lateral-Ventricle Left-Thalamus-Proper Right-Thalamus-Proper  Left-Caudate Right-Caudate Left-Putamen Right-Putamen Left-Pallidum Right-Pallidum Left-Hippocampus Right-Hippocampus Left-Amygdala Right-Amygdala Left-Accumbens-area Right-Accumbens-area; do
printf "%g," `grep  ${x} ${subj_id}/stats/aseg.stats | awk '{print $4}'` >> ${dir}LandRvolumes.csv
done
printf "%f" `cat ${subj_id}/stats/aseg.stats | grep IntraCranialVol | awk -F, '{print $4}'` >> ${dir}LandRvolumes.csv
echo "" >> ${dir}LandRvolumes.csv
done

# NB: if you are using FreeSurfer v7 and above, replace Left-Thalamus-Proper and Right-Thalamus-Proper with Left-Thalamus and Right-Thalamus, respectively.
