#!/bin/bash
#$ -S /bin/bash

# Where your FreeSurfer outputs are saved
fs_dir=/enigma/Parent_Folder/FreeSurfer/outputs/
# Where your csv will be saved
dir=/enigma/Parent_Folder/FreeSurfer/measures/

mkdir $dir

cd ${fs_dir}

echo 'SubjID,L_bankssts_thickavg,L_caudalanteriorcingulate_thickavg,L_caudalmiddlefrontal_thickavg,L_cuneus_thickavg,L_entorhinal_thickavg,L_fusiform_thickavg,L_inferiorparietal_thickavg,L_inferiortemporal_thickavg,L_isthmuscingulate_thickavg,L_lateraloccipital_thickavg,L_lateralorbitofrontal_thickavg,L_lingual_thickavg,L_medialorbitofrontal_thickavg,L_middletemporal_thickavg,L_parahippocampal_thickavg,L_paracentral_thickavg,L_parsopercularis_thickavg,L_parsorbitalis_thickavg,L_parstriangularis_thickavg,L_pericalcarine_thickavg,L_postcentral_thickavg,L_posteriorcingulate_thickavg,L_precentral_thickavg,L_precuneus_thickavg,L_rostralanteriorcingulate_thickavg,L_rostralmiddlefrontal_thickavg,L_superiorfrontal_thickavg,L_superiorparietal_thickavg,L_superiortemporal_thickavg,L_supramarginal_thickavg,L_frontalpole_thickavg,L_temporalpole_thickavg,L_transversetemporal_thickavg,L_insula_thickavg,R_bankssts_thickavg,R_caudalanteriorcingulate_thickavg,R_caudalmiddlefrontal_thickavg,R_cuneus_thickavg,R_entorhinal_thickavg,R_fusiform_thickavg,R_inferiorparietal_thickavg,R_inferiortemporal_thickavg,R_isthmuscingulate_thickavg,R_lateraloccipital_thickavg,R_lateralorbitofrontal_thickavg,R_lingual_thickavg,R_medialorbitofrontal_thickavg,R_middletemporal_thickavg,R_parahippocampal_thickavg,R_paracentral_thickavg,R_parsopercularis_thickavg,R_parsorbitalis_thickavg,R_parstriangularis_thickavg,R_pericalcarine_thickavg,R_postcentral_thickavg,R_posteriorcingulate_thickavg,R_precentral_thickavg,R_precuneus_thickavg,R_rostralanteriorcingulate_thickavg,R_rostralmiddlefrontal_thickavg,R_superiorfrontal_thickavg,R_superiorparietal_thickavg,R_superiortemporal_thickavg,R_supramarginal_thickavg,R_frontalpole_thickavg,R_temporalpole_thickavg,R_transversetemporal_thickavg,R_insula_thickavg,LThickness,RThickness,LSurfArea,RSurfArea,ICV' > ${dir}CorticalMeasuresENIGMA_ThickAvg.csv
echo 'SubjID,L_bankssts_surfavg,L_caudalanteriorcingulate_surfavg,L_caudalmiddlefrontal_surfavg,L_cuneus_surfavg,L_entorhinal_surfavg,L_fusiform_surfavg,L_inferiorparietal_surfavg,L_inferiortemporal_surfavg,L_isthmuscingulate_surfavg,L_lateraloccipital_surfavg,L_lateralorbitofrontal_surfavg,L_lingual_surfavg,L_medialorbitofrontal_surfavg,L_middletemporal_surfavg,L_parahippocampal_surfavg,L_paracentral_surfavg,L_parsopercularis_surfavg,L_parsorbitalis_surfavg,L_parstriangularis_surfavg,L_pericalcarine_surfavg,L_postcentral_surfavg,L_posteriorcingulate_surfavg,L_precentral_surfavg,L_precuneus_surfavg,L_rostralanteriorcingulate_surfavg,L_rostralmiddlefrontal_surfavg,L_superiorfrontal_surfavg,L_superiorparietal_surfavg,L_superiortemporal_surfavg,L_supramarginal_surfavg,L_frontalpole_surfavg,L_temporalpole_surfavg,L_transversetemporal_surfavg,L_insula_surfavg,R_bankssts_surfavg,R_caudalanteriorcingulate_surfavg,R_caudalmiddlefrontal_surfavg,R_cuneus_surfavg,R_entorhinal_surfavg,R_fusiform_surfavg,R_inferiorparietal_surfavg,R_inferiortemporal_surfavg,R_isthmuscingulate_surfavg,R_lateraloccipital_surfavg,R_lateralorbitofrontal_surfavg,R_lingual_surfavg,R_medialorbitofrontal_surfavg,R_middletemporal_surfavg,R_parahippocampal_surfavg,R_paracentral_surfavg,R_parsopercularis_surfavg,R_parsorbitalis_surfavg,R_parstriangularis_surfavg,R_pericalcarine_surfavg,R_postcentral_surfavg,R_posteriorcingulate_surfavg,R_precentral_surfavg,R_precuneus_surfavg,R_rostralanteriorcingulate_surfavg,R_rostralmiddlefrontal_surfavg,R_superiorfrontal_surfavg,R_superiorparietal_surfavg,R_superiortemporal_surfavg,R_supramarginal_surfavg,R_frontalpole_surfavg,R_temporalpole_surfavg,R_transversetemporal_surfavg,R_insula_surfavg,LThickness,RThickness,LSurfArea,RSurfArea,ICV' > ${dir}CorticalMeasuresENIGMA_SurfAvg.csv

for subj_id in $(ls -d Subj*); do #may need to change this so that it selects subjects with FS output 

printf "%s,"  "${subj_id}" >> ${dir}CorticalMeasuresENIGMA_ThickAvg.csv
printf "%s,"  "${subj_id}" >> ${dir}CorticalMeasuresENIGMA_SurfAvg.csv

for side in lh.aparc.stats rh.aparc.stats; do

for x in bankssts caudalanteriorcingulate caudalmiddlefrontal cuneus entorhinal fusiform inferiorparietal inferiortemporal isthmuscingulate lateraloccipital lateralorbitofrontal lingual medialorbitofrontal middletemporal parahippocampal paracentral parsopercularis parsorbitalis parstriangularis pericalcarine postcentral posteriorcingulate precentral precuneus rostralanteriorcingulate rostralmiddlefrontal superiorfrontal superiorparietal superiortemporal supramarginal frontalpole temporalpole transversetemporal insula; do

printf "%g," `grep -w ${x} ${subj_id}/stats/${side} | awk '{print $5}'` >> ${dir}CorticalMeasuresENIGMA_ThickAvg.csv
printf "%g," `grep -w ${x} ${subj_id}/stats/${side} | awk '{print $3}'` >> ${dir}CorticalMeasuresENIGMA_SurfAvg.csv

done
done

printf "%g," `cat ${subj_id}/stats/lh.aparc.stats | grep MeanThickness | awk -F, '{print $4}'` >> ${dir}CorticalMeasuresENIGMA_ThickAvg.csv
printf "%g," `cat ${subj_id}/stats/rh.aparc.stats | grep MeanThickness | awk -F, '{print $4}'` >> ${dir}CorticalMeasuresENIGMA_ThickAvg.csv
printf "%g," `cat ${subj_id}/stats/lh.aparc.stats | grep MeanThickness | awk -F, '{print $4}'` >> ${dir}CorticalMeasuresENIGMA_SurfAvg.csv
printf "%g," `cat ${subj_id}/stats/rh.aparc.stats | grep MeanThickness | awk -F, '{print $4}'` >> ${dir}CorticalMeasuresENIGMA_SurfAvg.csv
printf "%g," `cat ${subj_id}/stats/lh.aparc.stats | grep WhiteSurfArea | awk -F, '{print $4}'` >> ${dir}CorticalMeasuresENIGMA_ThickAvg.csv
printf "%g," `cat ${subj_id}/stats/rh.aparc.stats | grep WhiteSurfArea | awk -F, '{print $4}'` >> ${dir}CorticalMeasuresENIGMA_ThickAvg.csv
printf "%g," `cat ${subj_id}/stats/lh.aparc.stats | grep WhiteSurfArea | awk -F, '{print $4}'` >> ${dir}CorticalMeasuresENIGMA_SurfAvg.csv
printf "%g," `cat ${subj_id}/stats/rh.aparc.stats | grep WhiteSurfArea | awk -F, '{print $4}'` >> ${dir}CorticalMeasuresENIGMA_SurfAvg.csv
printf "%f" `cat ${subj_id}/stats/aseg.stats | grep IntraCranialVol | awk -F, '{print $4}'` >> ${dir}CorticalMeasuresENIGMA_ThickAvg.csv
printf "%f" `cat ${subj_id}/stats/aseg.stats | grep IntraCranialVol | awk -F, '{print $4}'` >> ${dir}CorticalMeasuresENIGMA_SurfAvg.csv


echo "" >> ${dir}CorticalMeasuresENIGMA_ThickAvg.csv
echo "" >> ${dir}CorticalMeasuresENIGMA_SurfAvg.csv

done
