#!/bin/bash

# 06/03/2022
# Wrapper written by Iyad Ba Gari and Sophia Thomopoulos (enigma@ini.usc.edu)
# This script is to be run on your subjects after you have run FreeSurfer on your T1 data

function Usage(){
    cat << USAGE

Usage:

`basename $0` --subjects <subject.txt> --fsdir </freesufer/path> --outdir <output/directory> --script <ENIGMA/scripts/path> --matlab <MATLAB/path> --step_N 1 <other options>

Mandatory arguments:
	--subjects	Provide a list of subjects stored in a text file
	--fsdir		FreeSurfer output path; absolute path
	--outdir	Output directory
	--script	Absolute path to ENIGMA dependency compiled scripts
	--mcrdir	MATLAB Runtime Path
	--fs7		Freesurfer v7 and above (e.g. --fs true or false)

N.B. --step_(1:5) choose at least one of these steps 

Optional arguments:   
	--help		Prints Usage
	--step_1	Extract Subcortical Measures (e.g. --step_1 true or false)
	--step_2	Extract Cortical Measures (e.g. --step_2 true or false)
	--step_3	Quality Checking Subcortical Measures (e.g. --step_3 true or false)
	--step_4	Quality Checking Cortical Measures - Internal Surface Method (e.g. --step_4 true or false)
	--step_5	Quality Checking Cortical Measures - External Surface Method (e.g. --step_5 true or false)

USAGE
    exit 1
}

if [[ $# -eq 0 ]]; then
    Usage >&2
fi

while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    --help)
        Usage >&2
        exit 0
        ;;
	--subjects)
		subjectIDs=${2}
        shift 
        shift
		;;
    --fsdir)
        fs_dir=${2}
        shift 
        shift 
        ;;
	--script)
        scripts_dir=${2}
        shift 
        shift 
        ;;
	--mcrdir)
        MCRROOT=${2}
        shift 
        shift 
        ;;
	--outdir)
        out_dir=${2}
        shift 
        shift 
        ;;
	--fs7)
        fs_version=${2}
        shift 
        shift 
		;;
	--step_1)
        step_val_1=${2}
        shift 
        shift 
		;;
	--step_2)
        step_val_2=${2}
        shift 
        shift 
		;;
	--step_3)
        step_val_3=${2}
        shift 
        shift 
		;;
	--step_4)
        step_val_4=${2}
        shift 
        shift 
		;;
	--step_5)
        step_val_5=${2}
        shift 
        shift 
		;;
    *) # Unexpected option
		Usage >&2
        ;;
esac
done


# Checking mandatory arguments
if [[ -z ${subjectIDs} || -z ${fs_dir} ||  -z ${scripts_dir} || -z ${MCRROOT} || -z ${out_dir} || -z ${fs_version} ]]; then
	echo "ERROR: --subjects --fsdir, --script, --matlab, --outdir are mandatory arguments. Please see usage: \n"
    Usage >&2
fi


#STEP 1: Extract Subcortical Volumes
if [[ "${step_val_1}" = true ]]; then 
	printf "\n+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\n"
	printf "STEP 1: Extracting Subcortical Measures \n"
	printf "+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\n"

	measures_dir=${out_dir}/measures && mkdir -p ${measures_dir}
	echo "SubjID,LLatVent,RLatVent,Lthal,Rthal,Lcaud,Rcaud,Lput,Rput,Lpal,Rpal,Lhippo,Rhippo,Lamyg,Ramyg,Laccumb,Raccumb,ICV" > ${measures_dir}/LandRvolumes.csv
	if [[ "${fs_version}" = true ]]
	then
		for subj_id in `cat $subjectIDs`; do
			printf "%s,"  "${subj_id}" >> ${measures_dir}/LandRvolumes.csv
			# using FreeSurfer v7 and above
			for x in Left-Lateral-Ventricle Right-Lateral-Ventricle Left-Thalamus Right-Thalamus  Left-Caudate Right-Caudate Left-Putamen Right-Putamen Left-Pallidum Right-Pallidum Left-Hippocampus Right-Hippocampus Left-Amygdala Right-Amygdala Left-Accumbens-area Right-Accumbens-area; do
				printf "%g," `grep  ${x} ${fs_dir}/${subj_id}/stats/aseg.stats | awk '{print $4}'` >> ${measures_dir}/LandRvolumes.csv
			done
			printf "%f" `cat ${fs_dir}/${subj_id}/stats/aseg.stats | grep IntraCranialVol | awk -F, '{print $4}'` >> ${measures_dir}/LandRvolumes.csv
			echo "" >> ${measures_dir}/LandRvolumes.csv
		done
	else
		for subj_id in `cat $subjectIDs`; do
			printf "%s,"  "${subj_id}" >> ${measures_dir}/LandRvolumes.csv
			for x in Left-Lateral-Ventricle Right-Lateral-Ventricle Left-Thalamus-Proper Right-Thalamus-Proper  Left-Caudate Right-Caudate Left-Putamen Right-Putamen Left-Pallidum Right-Pallidum Left-Hippocampus Right-Hippocampus Left-Amygdala Right-Amygdala Left-Accumbens-area Right-Accumbens-area; do
				printf "%g," `grep  ${x} ${fs_dir}/${subj_id}/stats/aseg.stats | awk '{print $4}'` >> ${measures_dir}/LandRvolumes.csv
			done
			printf "%f" `cat ${fs_dir}/${subj_id}/stats/aseg.stats | grep IntraCranialVol | awk -F, '{print $4}'` >> ${measures_dir}/LandRvolumes.csv
			echo "" >> ${measures_dir}/LandRvolumes.csv
		done
	fi
fi

#STEP 2: Extract Cortical Volumes
if [[ "${step_val_2}" = true ]]; then
	printf "\n+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\n"
	printf "STEP 2: Extracting Cortical Measures \n"
	printf "+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\n"

	measures_dir=${out_dir}/measures && mkdir -p ${measures_dir}

	echo 'SubjID,L_bankssts_thickavg,L_caudalanteriorcingulate_thickavg,L_caudalmiddlefrontal_thickavg,L_cuneus_thickavg,L_entorhinal_thickavg,L_fusiform_thickavg,L_inferiorparietal_thickavg,L_inferiortemporal_thickavg,L_isthmuscingulate_thickavg,L_lateraloccipital_thickavg,L_lateralorbitofrontal_thickavg,L_lingual_thickavg,L_medialorbitofrontal_thickavg,L_middletemporal_thickavg,L_parahippocampal_thickavg,L_paracentral_thickavg,L_parsopercularis_thickavg,L_parsorbitalis_thickavg,L_parstriangularis_thickavg,L_pericalcarine_thickavg,L_postcentral_thickavg,L_posteriorcingulate_thickavg,L_precentral_thickavg,L_precuneus_thickavg,L_rostralanteriorcingulate_thickavg,L_rostralmiddlefrontal_thickavg,L_superiorfrontal_thickavg,L_superiorparietal_thickavg,L_superiortemporal_thickavg,L_supramarginal_thickavg,L_frontalpole_thickavg,L_temporalpole_thickavg,L_transversetemporal_thickavg,L_insula_thickavg,R_bankssts_thickavg,R_caudalanteriorcingulate_thickavg,R_caudalmiddlefrontal_thickavg,R_cuneus_thickavg,R_entorhinal_thickavg,R_fusiform_thickavg,R_inferiorparietal_thickavg,R_inferiortemporal_thickavg,R_isthmuscingulate_thickavg,R_lateraloccipital_thickavg,R_lateralorbitofrontal_thickavg,R_lingual_thickavg,R_medialorbitofrontal_thickavg,R_middletemporal_thickavg,R_parahippocampal_thickavg,R_paracentral_thickavg,R_parsopercularis_thickavg,R_parsorbitalis_thickavg,R_parstriangularis_thickavg,R_pericalcarine_thickavg,R_postcentral_thickavg,R_posteriorcingulate_thickavg,R_precentral_thickavg,R_precuneus_thickavg,R_rostralanteriorcingulate_thickavg,R_rostralmiddlefrontal_thickavg,R_superiorfrontal_thickavg,R_superiorparietal_thickavg,R_superiortemporal_thickavg,R_supramarginal_thickavg,R_frontalpole_thickavg,R_temporalpole_thickavg,R_transversetemporal_thickavg,R_insula_thickavg,LThickness,RThickness,LSurfArea,RSurfArea,ICV' > ${measures_dir}/CorticalMeasuresENIGMA_ThickAvg.csv
	echo 'SubjID,L_bankssts_surfavg,L_caudalanteriorcingulate_surfavg,L_caudalmiddlefrontal_surfavg,L_cuneus_surfavg,L_entorhinal_surfavg,L_fusiform_surfavg,L_inferiorparietal_surfavg,L_inferiortemporal_surfavg,L_isthmuscingulate_surfavg,L_lateraloccipital_surfavg,L_lateralorbitofrontal_surfavg,L_lingual_surfavg,L_medialorbitofrontal_surfavg,L_middletemporal_surfavg,L_parahippocampal_surfavg,L_paracentral_surfavg,L_parsopercularis_surfavg,L_parsorbitalis_surfavg,L_parstriangularis_surfavg,L_pericalcarine_surfavg,L_postcentral_surfavg,L_posteriorcingulate_surfavg,L_precentral_surfavg,L_precuneus_surfavg,L_rostralanteriorcingulate_surfavg,L_rostralmiddlefrontal_surfavg,L_superiorfrontal_surfavg,L_superiorparietal_surfavg,L_superiortemporal_surfavg,L_supramarginal_surfavg,L_frontalpole_surfavg,L_temporalpole_surfavg,L_transversetemporal_surfavg,L_insula_surfavg,R_bankssts_surfavg,R_caudalanteriorcingulate_surfavg,R_caudalmiddlefrontal_surfavg,R_cuneus_surfavg,R_entorhinal_surfavg,R_fusiform_surfavg,R_inferiorparietal_surfavg,R_inferiortemporal_surfavg,R_isthmuscingulate_surfavg,R_lateraloccipital_surfavg,R_lateralorbitofrontal_surfavg,R_lingual_surfavg,R_medialorbitofrontal_surfavg,R_middletemporal_surfavg,R_parahippocampal_surfavg,R_paracentral_surfavg,R_parsopercularis_surfavg,R_parsorbitalis_surfavg,R_parstriangularis_surfavg,R_pericalcarine_surfavg,R_postcentral_surfavg,R_posteriorcingulate_surfavg,R_precentral_surfavg,R_precuneus_surfavg,R_rostralanteriorcingulate_surfavg,R_rostralmiddlefrontal_surfavg,R_superiorfrontal_surfavg,R_superiorparietal_surfavg,R_superiortemporal_surfavg,R_supramarginal_surfavg,R_frontalpole_surfavg,R_temporalpole_surfavg,R_transversetemporal_surfavg,R_insula_surfavg,LThickness,RThickness,LSurfArea,RSurfArea,ICV' > ${measures_dir}/CorticalMeasuresENIGMA_SurfAvg.csv
	
	for subj_id in `cat $subjectIDs`; do
		printf "%s,"  "${subj_id}" >> ${measures_dir}/CorticalMeasuresENIGMA_ThickAvg.csv
		printf "%s,"  "${subj_id}" >> ${measures_dir}/CorticalMeasuresENIGMA_SurfAvg.csv

		for side in lh.aparc.stats rh.aparc.stats; do
			for x in bankssts caudalanteriorcingulate caudalmiddlefrontal cuneus entorhinal fusiform inferiorparietal inferiortemporal isthmuscingulate lateraloccipital lateralorbitofrontal lingual medialorbitofrontal middletemporal parahippocampal paracentral parsopercularis parsorbitalis parstriangularis pericalcarine postcentral posteriorcingulate precentral precuneus rostralanteriorcingulate rostralmiddlefrontal superiorfrontal superiorparietal superiortemporal supramarginal frontalpole temporalpole transversetemporal insula; do
			printf "%g," `grep -w ${x} ${fs_dir}/${subj_id}/stats/${side} | awk '{print $5}'` >> ${measures_dir}/CorticalMeasuresENIGMA_ThickAvg.csv
			printf "%g," `grep -w ${x} ${fs_dir}/${subj_id}/stats/${side} | awk '{print $3}'` >> ${measures_dir}/CorticalMeasuresENIGMA_SurfAvg.csv
			done
		done

		printf "%g," `cat ${fs_dir}/${subj_id}/stats/lh.aparc.stats | grep MeanThickness | awk -F, '{print $4}'` >> ${measures_dir}/CorticalMeasuresENIGMA_ThickAvg.csv
		printf "%g," `cat ${fs_dir}/${subj_id}/stats/rh.aparc.stats | grep MeanThickness | awk -F, '{print $4}'` >> ${measures_dir}/CorticalMeasuresENIGMA_ThickAvg.csv
		printf "%g," `cat ${fs_dir}/${subj_id}/stats/lh.aparc.stats | grep MeanThickness | awk -F, '{print $4}'` >> ${measures_dir}/CorticalMeasuresENIGMA_SurfAvg.csv
		printf "%g," `cat ${fs_dir}/${subj_id}/stats/rh.aparc.stats | grep MeanThickness | awk -F, '{print $4}'` >> ${measures_dir}/CorticalMeasuresENIGMA_SurfAvg.csv
		printf "%g," `cat ${fs_dir}/${subj_id}/stats/lh.aparc.stats | grep WhiteSurfArea | awk -F, '{print $4}'` >> ${measures_dir}/CorticalMeasuresENIGMA_ThickAvg.csv
		printf "%g," `cat ${fs_dir}/${subj_id}/stats/rh.aparc.stats | grep WhiteSurfArea | awk -F, '{print $4}'` >> ${measures_dir}/CorticalMeasuresENIGMA_ThickAvg.csv
		printf "%g," `cat ${fs_dir}/${subj_id}/stats/lh.aparc.stats | grep WhiteSurfArea | awk -F, '{print $4}'` >> ${measures_dir}/CorticalMeasuresENIGMA_SurfAvg.csv
		printf "%g," `cat ${fs_dir}/${subj_id}/stats/rh.aparc.stats | grep WhiteSurfArea | awk -F, '{print $4}'` >> ${measures_dir}/CorticalMeasuresENIGMA_SurfAvg.csv
		printf "%f" `cat ${fs_dir}/${subj_id}/stats/aseg.stats | grep IntraCranialVol | awk -F, '{print $4}'` >> ${measures_dir}/CorticalMeasuresENIGMA_ThickAvg.csv
		printf "%f" `cat ${fs_dir}/${subj_id}/stats/aseg.stats | grep IntraCranialVol | awk -F, '{print $4}'` >> ${measures_dir}/CorticalMeasuresENIGMA_SurfAvg.csv
		echo "" >> ${measures_dir}/CorticalMeasuresENIGMA_ThickAvg.csv
		echo "" >> ${measures_dir}/CorticalMeasuresENIGMA_SurfAvg.csv
	done
fi


#STEP 3: Quality Checking Subcortical Measures
if [[ "${step_val_3}" = true ]]; then
	printf "\n+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\n"
	printf "Running STEP 3: Subcortical FreeSurfer QC \n"
	printf "+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\n"

	qc_dir_subcort=${out_dir}/qc/subcortical && mkdir -p ${qc_dir_subcort}

	for subj_id in `cat $subjectIDs`; do
		sh ${scripts_dir}/run_func_make_subcorticalFS_ENIGMA_QC.sh ${MCRROOT} ${qc_dir_subcort} ${subj_id} ${fs_dir}/${subj_id}/mri/orig_nu.mgz ${fs_dir}/${subj_id}/mri/aparc+aseg.mgz
		echo 'Done with subject: ' ${subj_id}
	done

	#Create QC webpage
	cd ${qc_dir_subcort}

	echo "<html>" 						>  ENIGMA_Subcortical_QC.html
	echo "<head>"                       >> ENIGMA_Subcortical_QC.html
	echo "<style type=\"text/css\">"	>> ENIGMA_Subcortical_QC.html
	echo "*"                            >> ENIGMA_Subcortical_QC.html
	echo "{"							>> ENIGMA_Subcortical_QC.html
	echo "margin: 0px;"					>> ENIGMA_Subcortical_QC.html
	echo "padding: 0px;"				>> ENIGMA_Subcortical_QC.html
	echo "}"							>> ENIGMA_Subcortical_QC.html
	echo "html, body"					>> ENIGMA_Subcortical_QC.html
	echo "{"							>> ENIGMA_Subcortical_QC.html
	echo "height: 100%;"				>> ENIGMA_Subcortical_QC.html
	echo "}"							>> ENIGMA_Subcortical_QC.html
	echo "</style>"						>> ENIGMA_Subcortical_QC.html
	echo "</head>"						>> ENIGMA_Subcortical_QC.html
	echo "<body>" 						>> ENIGMA_Subcortical_QC.html

	for roi in Thal Caud Put Pall Hip Amyg NAcc; do 
	cp ENIGMA_Subcortical_QC.html ENIGMA_${roi}_volume_QC.html
	done

	for subj_id in `cat $subjectIDs`; do

		echo "<table cellspacing=\"1\" style=\"width:100%;background-color:#000;\">"				>> ENIGMA_Subcortical_QC.html
		echo "<tr>"																					>> ENIGMA_Subcortical_QC.html
		echo "<td> <FONT COLOR=WHITE FACE=\"Geneva, Arial\" SIZE=5> $subj_id </FONT> </td>"         >> ENIGMA_Subcortical_QC.html
		echo "</tr>"                                                                                >> ENIGMA_Subcortical_QC.html
		echo "<tr>"                                                                                 >> ENIGMA_Subcortical_QC.html
		echo "<td><a href=\"file:"$subj_id"/Subcortical_set_Axial_20.png\"><img src=\""$subj_id"/Subcortical_set_Axial_70_20.png\" width=\"100%\" ></a></td>"		>> ENIGMA_Subcortical_QC.html
		echo "<td><a href=\"file:"$subj_id"/Subcortical_set_Axial_40.png\"><img src=\""$subj_id"/Subcortical_set_Axial_70_40.png\" width=\"100%\" ></a></td>"		>> ENIGMA_Subcortical_QC.html
		echo "<td><a href=\"file:"$subj_id"/Subcortical_set_Axial_60.png\"><img src=\""$subj_id"/Subcortical_set_Axial_70_60.png\" width=\"100%\" ></a></td>"		>> ENIGMA_Subcortical_QC.html
		echo "<td><a href=\"file:"$subj_id"/Subcortical_set_Axial_80.png\"><img src=\""$subj_id"/Subcortical_set_Axial_70_80.png\" width=\"100%\" ></a></td>"		>> ENIGMA_Subcortical_QC.html
		echo "</tr>"																				>> ENIGMA_Subcortical_QC.html
		echo "<tr>"																					>> ENIGMA_Subcortical_QC.html
		echo "<td><a href=\"file:"$subj_id"/Subcortical_set_Coronal_20.png\"><img src=\""$subj_id"/Subcortical_set_Coronal_70_20.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Subcortical_QC.html
		echo "<td><a href=\"file:"$subj_id"/Subcortical_set_Coronal_40.png\"><img src=\""$subj_id"/Subcortical_set_Coronal_70_40.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Subcortical_QC.html
		echo "<td><a href=\"file:"$subj_id"/Subcortical_set_Coronal_60.png\"><img src=\""$subj_id"/Subcortical_set_Coronal_70_60.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Subcortical_QC.html
		echo "<td><a href=\"file:"$subj_id"/Subcortical_set_Coronal_80.png\"><img src=\""$subj_id"/Subcortical_set_Coronal_70_80.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Subcortical_QC.html
		echo "</tr>"																				>> ENIGMA_Subcortical_QC.html
		echo "<tr>"																					>> ENIGMA_Subcortical_QC.html
		echo "<td><a href=\"file:"$subj_id"/Subcortical_set_Sagittal_20.png\"><img src=\""$subj_id"/Subcortical_set_Sagittal_70_20.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Subcortical_QC.html
		echo "<td><a href=\"file:"$subj_id"/Subcortical_set_Sagittal_40.png\"><img src=\""$subj_id"/Subcortical_set_Sagittal_70_40.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Subcortical_QC.html
		echo "<td><a href=\"file:"$subj_id"/Subcortical_set_Sagittal_60.png\"><img src=\""$subj_id"/Subcortical_set_Sagittal_70_60.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Subcortical_QC.html
		echo "<td><a href=\"file:"$subj_id"/Subcortical_set_Sagittal_80.png\"><img src=\""$subj_id"/Subcortical_set_Sagittal_70_80.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Subcortical_QC.html
		echo "</tr>"																				>> ENIGMA_Subcortical_QC.html	
		echo "</table>"                                                         					>> ENIGMA_Subcortical_QC.html
	done;
	echo "</body>"                                                             						>> ENIGMA_Subcortical_QC.html
	echo "</html>"                                                             						>> ENIGMA_Subcortical_QC.html

	for roi in Thal Caud Put Pall Hip Amyg NAcc; do 
	echo $roi
	for subj_id in `cat $subjectIDs`; do
		echo "<table cellspacing=\"1\" style=\"width:100%;background-color:#000;\">"				>> ENIGMA_${roi}_volume_QC.html
		echo "<tr>"																					>> ENIGMA_${roi}_volume_QC.html
		echo "<td> <FONT COLOR=WHITE FACE=\"Geneva, Arial\" SIZE=5> $subj_id </FONT> </td>"         >> ENIGMA_${roi}_volume_QC.html
		echo "</tr>"                                                                                >> ENIGMA_${roi}_volume_QC.html
		echo "<tr>"                                                                                 >> ENIGMA_${roi}_volume_QC.html
		echo "<td><a href=\"file:"$subj_id"/${roi}_Axial_25.png\"><img src=\""$subj_id"/${roi}_Axial_70_25.png\" width=\"100%\" ></a></td>"			>> ENIGMA_${roi}_volume_QC.html
		echo "<td><a href=\"file:"$subj_id"/${roi}_Axial_50.png\"><img src=\""$subj_id"/${roi}_Axial_70_50.png\" width=\"100%\" ></a></td>"			>> ENIGMA_${roi}_volume_QC.html
		echo "<td><a href=\"file:"$subj_id"/${roi}_Axial_75.png\"><img src=\""$subj_id"/${roi}_Axial_70_75.png\" width=\"100%\" ></a></td>"			>> ENIGMA_${roi}_volume_QC.html
		echo "</tr>"																				>> ENIGMA_${roi}_volume_QC.html
		echo "<tr>"																					>> ENIGMA_${roi}_volume_QC.html
		echo "<td><a href=\"file:"$subj_id"/${roi}_Coronal_25.png\"><img src=\""$subj_id"/${roi}_Coronal_70_25.png\" width=\"100%\" ></a></td>"		>> ENIGMA_${roi}_volume_QC.html
		echo "<td><a href=\"file:"$subj_id"/${roi}_Coronal_50.png\"><img src=\""$subj_id"/${roi}_Coronal_70_50.png\" width=\"100%\" ></a></td>"		>> ENIGMA_${roi}_volume_QC.html
		echo "<td><a href=\"file:"$subj_id"/${roi}_Coronal_75.png\"><img src=\""$subj_id"/${roi}_Coronal_70_75.png\" width=\"100%\" ></a></td>"		>> ENIGMA_${roi}_volume_QC.html
		echo "</tr>"																				>> ENIGMA_${roi}_volume_QC.html
		echo "<tr>"																					>> ENIGMA_${roi}_volume_QC.html
		echo "<td><a href=\"file:"$subj_id"/${roi}_Sagittal_25.png\"><img src=\""$subj_id"/${roi}_Sagittal_70_25.png\" width=\"100%\" ></a></td>"	>> ENIGMA_${roi}_volume_QC.html
		echo "<td><a href=\"file:"$subj_id"/${roi}_Sagittal_50.png\"><img src=\""$subj_id"/${roi}_Sagittal_70_50.png\" width=\"100%\" ></a></td>"	>> ENIGMA_${roi}_volume_QC.html
		echo "<td><a href=\"file:"$subj_id"/${roi}_Sagittal_75.png\"><img src=\""$subj_id"/${roi}_Sagittal_70_75.png\" width=\"100%\" ></a></td>"	>> ENIGMA_${roi}_volume_QC.html
		echo "</tr>"																				>> ENIGMA_${roi}_volume_QC.html	
		echo "</table>"                                                         					>> ENIGMA_${roi}_volume_QC.html
	done;
	echo "</body>"                                                             						>> ENIGMA_${roi}_volume_QC.html
	echo "</html>"                                                             						>> ENIGMA_${roi}_volume_QC.html
	done
fi

#STEP 4: Quality Checking Cortical Measures - Internal Surface Method
if [[ "${step_val_4}" = true ]]; then
	printf "\n+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\n"
	printf "Running STEP 4: Internal Cortical FreeSurfer QC \n"
	printf "+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\n"

	qc_dir_cort_int=${out_dir}/qc/cortical_internal && mkdir -p ${qc_dir_cort_int}

	for subj_id in `cat $subjectIDs`; do
		sh ${scripts_dir}/run_func_make_corticalpngs_ENIGMA_QC.sh ${MCRROOT} ${qc_dir_cort_int} ${subj_id} ${fs_dir}/${subj_id}/mri/orig_nu.mgz ${fs_dir}/${subj_id}/mri/aparc+aseg.mgz
		echo 'Done with subject: ' ${subj_id}
	done
	
	#Create QC webpage
	cd ${qc_dir_cort_int}

	echo "<html>" 						>  ENIGMA_Cortical_QC.html
	echo "<head>"                       >> ENIGMA_Cortical_QC.html
	echo "<style type=\"text/css\">"	>> ENIGMA_Cortical_QC.html
	echo "*"                            >> ENIGMA_Cortical_QC.html
	echo "{"							>> ENIGMA_Cortical_QC.html
	echo "margin: 0px;"					>> ENIGMA_Cortical_QC.html
	echo "padding: 0px;"				>> ENIGMA_Cortical_QC.html
	echo "}"							>> ENIGMA_Cortical_QC.html
	echo "html, body"					>> ENIGMA_Cortical_QC.html
	echo "{"							>> ENIGMA_Cortical_QC.html
	echo "height: 100%;"				>> ENIGMA_Cortical_QC.html
	echo "}"							>> ENIGMA_Cortical_QC.html
	echo "</style>"						>> ENIGMA_Cortical_QC.html
	echo "</head>"						>> ENIGMA_Cortical_QC.html
	echo "<body>" 						>>  ENIGMA_Cortical_QC.html

	for subj_id in `cat $subjectIDs`; do
		echo "<table cellspacing=\"1\" style=\"width:100%;background-color:#000;\">"				>> ENIGMA_Cortical_QC.html
		echo "<tr>"																					>> ENIGMA_Cortical_QC.html
		echo "<td> <FONT COLOR=WHITE FACE=\"Geneva, Arial\" SIZE=5> $subj_id </FONT> </td>"         >> ENIGMA_Cortical_QC.html
		echo "</tr>"                                                                                >> ENIGMA_Cortical_QC.html
		echo "<tr>"                                                                                 >> ENIGMA_Cortical_QC.html
		echo "<td><a href=\"file:"$subj_id"/Cortical_set_Axial_10.png\"><img src=\""$subj_id"/Cortical_set_Axial_70_10.png\" width=\"100%\" ></a></td>"		>> ENIGMA_Cortical_QC.html
		echo "<td><a href=\"file:"$subj_id"/Cortical_set_Axial_20.png\"><img src=\""$subj_id"/Cortical_set_Axial_70_20.png\" width=\"100%\" ></a></td>"		>> ENIGMA_Cortical_QC.html
		echo "<td><a href=\"file:"$subj_id"/Cortical_set_Axial_40.png\"><img src=\""$subj_id"/Cortical_set_Axial_70_40.png\" width=\"100%\" ></a></td>"		>> ENIGMA_Cortical_QC.html
		echo "<td><a href=\"file:"$subj_id"/Cortical_set_Axial_50.png\"><img src=\""$subj_id"/Cortical_set_Axial_70_50.png\" width=\"100%\" ></a></td>"		>> ENIGMA_Cortical_QC.html
		echo "</tr>"																				>> ENIGMA_Cortical_QC.html
		echo "<tr>"																					>> ENIGMA_Cortical_QC.html
		echo "<td><a href=\"file:"$subj_id"/Cortical_set_Axial_60.png\"><img src=\""$subj_id"/Cortical_set_Axial_70_60.png\" width=\"100%\" ></a></td>"		>> ENIGMA_Cortical_QC.html
		echo "<td><a href=\"file:"$subj_id"/Cortical_set_Axial_80.png\"><img src=\""$subj_id"/Cortical_set_Axial_70_80.png\" width=\"100%\" ></a></td>"		>> ENIGMA_Cortical_QC.html
		echo "<td><a href=\"file:"$subj_id"/Cortical_set_Axial_85.png\"><img src=\""$subj_id"/Cortical_set_Axial_70_85.png\" width=\"100%\" ></a></td>"		>> ENIGMA_Cortical_QC.html
		echo "<td><a href=\"file:"$subj_id"/Cortical_set_Axial_90.png\"><img src=\""$subj_id"/Cortical_set_Axial_70_90.png\" width=\"100%\" ></a></td>"		>> ENIGMA_Cortical_QC.html
		echo "</tr>"																				>> ENIGMA_Cortical_QC.html
		echo "<tr>"																					>> ENIGMA_Cortical_QC.html
		echo "<td><a href=\"file:"$subj_id"/Cortical_set_Coronal_10.png\"><img src=\""$subj_id"/Cortical_set_Coronal_70_10.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Cortical_QC.html
		echo "<td><a href=\"file:"$subj_id"/Cortical_set_Coronal_20.png\"><img src=\""$subj_id"/Cortical_set_Coronal_70_20.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Cortical_QC.html
		echo "<td><a href=\"file:"$subj_id"/Cortical_set_Coronal_40.png\"><img src=\""$subj_id"/Cortical_set_Coronal_70_40.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Cortical_QC.html
		echo "<td><a href=\"file:"$subj_id"/Cortical_set_Coronal_50.png\"><img src=\""$subj_id"/Cortical_set_Coronal_70_50.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Cortical_QC.html
		echo "</tr>"																				>> ENIGMA_Cortical_QC.html
		echo "<tr>"																					>> ENIGMA_Cortical_QC.html
		echo "<td><a href=\"file:"$subj_id"/Cortical_set_Coronal_60.png\"><img src=\""$subj_id"/Cortical_set_Coronal_70_60.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Cortical_QC.html
		echo "<td><a href=\"file:"$subj_id"/Cortical_set_Coronal_80.png\"><img src=\""$subj_id"/Cortical_set_Coronal_70_80.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Cortical_QC.html
		echo "<td><a href=\"file:"$subj_id"/Cortical_set_Coronal_85.png\"><img src=\""$subj_id"/Cortical_set_Coronal_70_85.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Cortical_QC.html
		echo "<td><a href=\"file:"$subj_id"/Cortical_set_Coronal_90.png\"><img src=\""$subj_id"/Cortical_set_Coronal_70_90.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Cortical_QC.html
		echo "</tr>"																				>> ENIGMA_Cortical_QC.html
		echo "</table>"                                                                             >> ENIGMA_Cortical_QC.html
	done;

	echo "</body>"                                                                              	>> ENIGMA_Cortical_QC.html
	echo "</html>"                                                                              	>> ENIGMA_Cortical_QC.html
fi

#STEP 5: Quality Checking Cortical Measures - External Surface Method
if [[ "${step_val_5}" = true ]]; then
	printf "\n+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\n"
	printf "Running STEP 5: External Cortical FreeSurfer QC \n"
	printf "+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\n"

	qc_dir_cort_ext=${out_dir}/qc/cortical_external && mkdir -p ${qc_dir_cort_ext}

	for subj_id in `cat $subjectIDs`; do
		sh ${scripts_dir}/run_FS_external_QC.sh ${MCRROOT} ${fs_dir} ${qc_dir_cort_ext} ${subj_id}
		echo 'Done with subject: ' ${subj_id}
	done

	#Create QC webpage
	cd ${qc_dir_cort_ext}
	
	echo "<html>" 						>  ENIGMA_External_QC.html
	echo "<head>"                       >> ENIGMA_External_QC.html
	echo "<style type=\"text/css\">"	>> ENIGMA_External_QC.html
	echo "*"                            >> ENIGMA_External_QC.html
	echo "{"							>> ENIGMA_External_QC.html
	echo "margin: 0px;"					>> ENIGMA_External_QC.html
	echo "padding: 0px;"				>> ENIGMA_External_QC.html
	echo "}"							>> ENIGMA_External_QC.html
	echo "html, body"					>> ENIGMA_External_QC.html
	echo "{"							>> ENIGMA_External_QC.html
	echo "height: 100%;"				>> ENIGMA_External_QC.html
	echo "}"							>> ENIGMA_External_QC.html
	echo "</style>"						>> ENIGMA_External_QC.html
	echo "</head>"						>> ENIGMA_External_QC.html
	echo "<body>" 						>> ENIGMA_External_QC.html
	for subj_id in `cat $subjectIDs`; do
		echo "<table cellspacing=\"1\" style=\"width:100%;background-color:black;\">"									>> ENIGMA_External_QC.html
		echo "<tr>" 																									>> ENIGMA_External_QC.html
		echo "<td> <FONT COLOR=white FACE=\"Geneva, Arial\" SIZE=5> $subj_id </FONT> </td>" 							>> ENIGMA_External_QC.html
		echo "</tr>" 																									>> ENIGMA_External_QC.html                                                                        
		echo "<tr>" 																									>> ENIGMA_External_QC.html 
		echo "<td><a href=\"file:"$subj_id".lh.lat.png\"><img src=\""$subj_id".lh.lat.png\" width=\"100%\" ></a></td>"	>> ENIGMA_External_QC.html
		echo "<td><a href=\"file:"$subj_id".lh.med.png\"><img src=\""$subj_id".lh.med.png\" width=\"100%\" ></a></td>"	>> ENIGMA_External_QC.html
		echo "<td><a href=\"file:"$subj_id".rh.lat.png\"><img src=\""$subj_id".rh.lat.png\" width=\"100%\" ></a></td>"	>> ENIGMA_External_QC.html
		echo "<td><a href=\"file:"$subj_id".rh.med.png\"><img src=\""$subj_id".rh.med.png\" width=\"100%\" ></a></td>"	>> ENIGMA_External_QC.html
		echo "</tr>" 																									>> ENIGMA_External_QC.html  
		echo "</table>" 																								>> ENIGMA_External_QC.html 
	done;
	echo "</body>" 																										>> ENIGMA_External_QC.html
	echo "</html>" 																										>> ENIGMA_External_QC.html
fi
