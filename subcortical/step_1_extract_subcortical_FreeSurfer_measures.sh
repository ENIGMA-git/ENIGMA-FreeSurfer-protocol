#!/bin/bash

## Updated 06/03/2022 - enigma.ini.usc.edu
# sh step_1_extract_subcortical_FreeSurfer_measures.sh --subjects 4308471 --fsdir /ifs/loni/faculty/njahansh/nerds/iyad/ENIGMA-FreeSurfer-protocol/FreeSurfer --outdir /ifs/loni/faculty/njahansh/nerds/iyad/ENIGMA-FreeSurfer-protocol/output --fs 6
function Usage(){
    cat << USAGE

Usage:

`basename $0` --subjects <subjectID> --fsdir </freesufer/path> --outdir <output/directory>  <other options>

Mandatory arguments:
	--subjects	Provide a list of subjects stored in a text file
	--fsdir		FreeSurfer output path; absolute path
	--outdir	Output directory

Optional arguments:   
	--help		Prints Usage
	--fs		Freesurfer v7 and above (fs=1, default)

USAGE
    exit 1
}

if [[ $# -eq 0 ]]; then
    Usage >&2
fi

while [[ $# -gt 0 ]]
do
key="$1"
# Default Values
fs_version=1

case $key in
    --help)
        Usage >&2
        exit 0
        ;;
	--subjects)
		subj_id=${2}
        shift 
        shift
		;;
    --fsdir)
        fs_dir=${2}
        shift 
        shift 
        ;;
    --outdir)
        out_dir=${2}
        shift 
        shift 
        ;;
	--fs)
        fs_version=${2}
        shift 
        shift 
		;;
    *) # Unexpected option
		Usage >&2
        ;;
esac
done


# Checking mandatory arguments
if [[ -z ${subj_id} || -z ${fs_dir} || -z ${out_dir} ]]; then
	echo "ERROR: --subjects --fsdir, --outdir are mandatory arguments. Please see usage: \n"
    Usage >&2
fi

printf "\n+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\n"
printf "Extracting Subcortical Measures \n"
printf "+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\n"

measures_dir=${out_dir}/measures 
mkdir -p ${measures_dir}

echo "SubjID,LLatVent,RLatVent,Lthal,Rthal,Lcaud,Rcaud,Lput,Rput,Lpal,Rpal,Lhippo,Rhippo,Lamyg,Ramyg,Laccumb,Raccumb,ICV" > ${measures_dir}/LandRvolumes.csv
printf "%s,"  "${subj_id}" >> ${measures_dir}/LandRvolumes.csv

if [[ ${fs_version} -eq 1 ]]
then
    # using FreeSurfer v7 and above
    for x in Left-Lateral-Ventricle Right-Lateral-Ventricle Left-Thalamus Right-Thalamus  Left-Caudate Right-Caudate Left-Putamen Right-Putamen Left-Pallidum Right-Pallidum Left-Hippocampus Right-Hippocampus Left-Amygdala Right-Amygdala Left-Accumbens-area Right-Accumbens-area; do
        printf "%g," `grep  ${x} ${fs_dir}/${subj_id}/stats/aseg.stats | awk '{print $4}'` >> ${measures_dir}/LandRvolumes.csv
    done
else
    for x in Left-Lateral-Ventricle Right-Lateral-Ventricle Left-Thalamus-Proper Right-Thalamus-Proper  Left-Caudate Right-Caudate Left-Putamen Right-Putamen Left-Pallidum Right-Pallidum Left-Hippocampus Right-Hippocampus Left-Amygdala Right-Amygdala Left-Accumbens-area Right-Accumbens-area; do
        printf "%g," `grep  ${x} ${fs_dir}/${subj_id}/stats/aseg.stats | awk '{print $4}'` >> ${measures_dir}/LandRvolumes.csv
    done
fi

printf "%f" `cat ${fs_dir}/${subj_id}/stats/aseg.stats | grep IntraCranialVol | awk -F, '{print $4}'` >> ${measures_dir}/LandRvolumes.csv
echo "" >> ${measures_dir}/LandRvolumes.csv