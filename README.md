# ENIGMA FreeSurfer cortical and subcortical extraction and QC
Use these protocols for the analysis of subcortical volume, and cortical thickness and surface area data within FreeSurfer ROI's for ENIGMA working groups. If you have any questions or run into problems, please feel free to contact enigma@ini.usc.edu.

These protocols are offered with an unlimited license and without warranty. However, if you find these protocols useful in your research, please provide a link to the ENIGMA website in your work: www.enigma.ini.usc.edu

In all template scripts, we assume the following main path set-up which you will need to replace if different: _/enigma/Parent_Folder/_. Save all scripts in a folder as follows: _/enigma/Parent_Folder/scripts/_. In addition to the scripts provided, download the collection of Matlab scripts called `ENIGMA_QC_3.0.zip`, unzip the directory, and change directories to that folder with the required Matlab `.m` scripts. For simplicity, we assume you are working on a Linux machine with the base directory _/enigma/Parent_Folder/scripts/ENIGMA_QC/_. 

All scripts are in a for loop configuration, but if you have a computing system which allows you to parallelize jobs, we highlight where you could edit the script in order to run through your subjects faster. 

#### Outline:
- [FreeSurfer](#freesurfer)
- [Cortical extraction and QC](#cortical-extraction-and-qc)
- [Subcortical extraction and QC](#subcortical-extraction-and-qc)

### FreeSurfer
The first step is to run [FreeSurfer](http://surfer.nmr.mgh.harvard.edu/fswiki/recon-all)’s `recon-all` on your T1 weighted images.  

Before you want to work with FreeSurfer, configure your environment in your script. All information on how to set up and install FreeSurfer can be found on [FreeSurfer](https://surfer.nmr.mgh.harvard.edu/fswiki/QuickInstall)'s webpage. Make sure that you also [register](https://surfer.nmr.mgh.harvard.edu/registration.html) to obtain a license to use FreeSurfer.

SCRIPT: `run_FreeSurfer_loop.sh`
_NB: this script can also be adjusted to be submitted to a computing cluster_

In your script you will need to edit: 

-	_line 5:_ `fs_dir` will be the output directory. Do NOT make the subject subfolders as FreeSurfer does this when it runs. If it detects a subject folder already in your output directory, it assumes that FreeSurfer has already been run and it will skip that subject. 
-	_line 9-10:_ configure the correct FreeSurfer environment. `FREESURFER_HOME` is set so your computer knows where FreeSurfer is installed, SUBJECTS_DIR will point to where your FreeSurfer outputs will be saved, and finally source the FreeSurfer set up script must be sourced so FreeSurfer knows the location of everything it needs,
-	_line 14:_ replace `subject1 subject2 subject3` with your subject list.
-	_line 20:_ `input` should point to your T1 NIFTI images.

Run in your terminal (while in your scripts folder): `sh FreeSurfer_loop.sh`

Depending on the number of your scans and the processing speed of your computer, this script will take several days to finish (24 to 36 hours/subject for versions 6 and below, and about 8-12 hours/subjects for version 7) if run in a loop. When `recon-all` is done, you will see a folder for each subject in your output-folder, in which you will find 10 new folders (such as ‘mri’, ‘stats’, ‘surf’ etc). Check to see that all your subjects ran successfully by checking to see if they have a _subject/scripts/recon-all.done_ file outputted. Here is a sample code: 

        for subj in subject1 subject2 subject3;
        do
        ls /enigma/Parent_Folder/FreeSurfer/outputs/${subj}/scripts/recon-all.done
        done

If a subject has failed, there will (most likely) be a `recon-all.error` file in their subject scripts folder. Check the `recon-all.log` file to help with troubleshooting.   

### Cortical extraction and QC

Follow the scripts and instructions in the [cortical](https://github.com/ENIGMA-git/ENIGMA-FreeSurfer-extraction-and-QC/tree/main/cortical) branch.

### Subcortical extraction and QC

Follow the scripts and instructions in the [subcortical](https://github.com/ENIGMA-git/ENIGMA-FreeSurfer-extraction-and-QC/tree/main/subcortical) branch.


