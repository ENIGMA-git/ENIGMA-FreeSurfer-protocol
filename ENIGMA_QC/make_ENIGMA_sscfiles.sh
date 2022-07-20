#!/bin/bash
#$ -S /bin/bash

imageDir=${1}
subjectlist_txtfile=${2}

cd ${imageDir}

file=All_ROIS.ssc

echo 'Root:' > ${file}
echo ${imageDir} >> ${file} 
echo 'Files:' >> ${file}
echo 'ROIset_Axial_20.png' >> ${file}
echo 'ROIset_Axial_40.png' >> ${file}
echo 'ROIset_Axial_60.png' >> ${file}
echo 'ROIset_Axial_80.png' >> ${file}
echo 'ROIset_Coronal_20.png' >> ${file}
echo 'ROIset_Coronal_40.png' >> ${file}
echo 'ROIset_Coronal_60.png' >> ${file}
echo 'ROIset_Coronal_80.png' >> ${file}
echo 'ROIset_Sagittal_20.png' >> ${file}
echo 'ROIset_Sagittal_40.png' >> ${file}
echo 'ROIset_Sagittal_60.png' >> ${file}
echo 'ROIset_Sagittal_80.png' >> ${file}
echo 'Directories:' >> ${file}
cat ${subjectlist_txtfile} >> ${file}


ROIs=(Accumbens Amygdala Caudate Hippocampus Pallidum Putamen Thalamus)
abbrev=(NAcc Amyg Caud Hip Pall Put Thal)

for i in 0 1 2 3 4 5 6
do
file=${ROIs[$i]}.ssc
echo 'Root:' > ${file}
echo ${imageDir} >> ${file} 
echo 'Files:' >> ${file}
echo ${abbrev[$i]}'_Axial_25.png'  >> ${file}
echo ${abbrev[$i]}'_Axial_50.png'  >> ${file}
echo ${abbrev[$i]}'_Axial_75.png'  >> ${file}
echo ${abbrev[$i]}'_Coronal_25.png'  >> ${file}
echo ${abbrev[$i]}'_Coronal_50.png'  >> ${file}
echo ${abbrev[$i]}'_Coronal_75.png'  >> ${file}
echo ${abbrev[$i]}'_Sagittal_25.png'  >> ${file}
echo ${abbrev[$i]}'_Sagittal_50.png'  >> ${file}
echo ${abbrev[$i]}'_Sagittal_75.png'  >> ${file}
echo 'Directories:' >> ${file}
cat ${subjectlist_txtfile} >> ${file}
done


