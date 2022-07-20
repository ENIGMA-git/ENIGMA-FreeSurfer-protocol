# ENIGMA FreeSurfer Cortical & Subcortical Extraction and QC Protocol
Use these protocols for the analysis of subcortical volume, and cortical thickness and surface area data within FreeSurfer ROI's for ENIGMA working groups. If you have any questions or run into problems, please feel free to contact enigma@ini.usc.edu.

These protocols are offered with an unlimited license and without warranty. However, if you find these protocols useful in your research, please provide a link to the ENIGMA website in your work: www.enigma.ini.usc.edu

All scripts are in a for loop configuration and should be run from within your scripts folder; if you have a computing system which allows you to parallelize jobs, we highlight where you could edit the script in order to run through your subjects faster. 

#### Overview:
* [Run FreeSurfer](#run-freesurfer)
* [Cortical & Subcortical measures extraction and QC](#cortical-and-subcortical-measures-extraction-and-qc)

## Run FreeSurfer
The main step is to run [FreeSurfer](http://surfer.nmr.mgh.harvard.edu/fswiki/recon-all)’s `recon-all` command on your T1 weighted images. Before you want to work with FreeSurfer, configure your environment in your script. All information on how to set up and install FreeSurfer can be found on [FreeSurfer](https://surfer.nmr.mgh.harvard.edu/fswiki/QuickInstall)'s webpage. Make sure that you also [register](https://surfer.nmr.mgh.harvard.edu/registration.html) to obtain a license to use FreeSurfer.

**SCRIPT: `run_FreeSurfer_loop.sh`**
* _NB: This script can also be adjusted to be submitted to a computing cluster_

Edit the following in your script: 
* _line 5:_ `fs_dir` will be the output directory. Do NOT create the subject subfolders before running FreeSurfer. If FreeSurfer detects a subject folder already in your output directory, it will skip that subject. 
* _line 9-10:_ configure the correct FreeSurfer environment. `FREESURFER_HOME` is set so your computer knows where FreeSurfer is installed, `SUBJECTS_DIR` will point to where your FreeSurfer outputs will be saved, and finally source the FreeSurfer set up script must be sourced so FreeSurfer knows the location of everything it needs.
* _line 14:_ replace `subject1 subject2 subject3` with your subject list.
* _line 18:_ `input` should point to your T1 NIFTI images.

Run script: 

      sh run_FreeSurfer_loop.sh

Depending on the number of your scans and the processing speed of your computer, this script will take several days to finish (24 to 36 hours/subject for versions 6 and below, and about 8-12 hours/subjects for version 7) if run in a loop. When `recon-all` is done, you will see a folder for each subject in your output-folder, in which you will find 10 new folders (such as ‘mri’, ‘stats’, ‘surf’ etc). Check to see that all your subjects ran successfully by checking to see if they have a _subject/scripts/recon-all.done_ file outputted. Here is a sample code: 

      for subj in subject1 subject2 subject3;
      do
      ls /enigma/Parent_Folder/FreeSurfer/outputs/${subj}/scripts/recon-all.done
      done

If a subject has failed, there will (most likely) be a `recon-all.error` file in their subject's scripts subdirecoty. Check the subject's `recon-all.log` file to help with troubleshooting.   

## Cortical and Subcortical measures extraction and QC

This script will extract the values for each FreeSurfer region of interest (ROI) and generate PNG images to check your cortical and subcortical ROI images.

* _step1:_ Extract subcortical volumes.
* _step2:_ Extract cortical measures (surface area and thickness Average)
* _step3:_ Quality Checking Subcortical Measures
* _step4:_ Quality Checking Cortical Measures - Internal Surface Method
* _step5:_ Quality Checking Cortical Measures - External Surface Method


Run script:

      sh enigma_fs_wrapper_script.sh --subjects /.../subjectIDs.txt \
						 --fsdir /../FreeSurfer_output_path/ \
						 --outdir /.../Output_directory \
						 --script /.../ENIGMA_dependency_scripts \
						 --matlab /.../local/MATLAB_path \
						 --step_1 true \
						 --step_2 true \
						 --step_3 false \
						 --step_4 true \
						 --step_5 true \
						 --fs7 true or false
      N.B. --step_(1:5) choose at least one of these steps 

Use `--help` to see all options.






