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

## Cortical and Subcortical Measures Extraction and QC

The next step is to get each subject's subcortical volumes and cortical surface area and thickness average of each region of interst (ROI) after running FreeSurfer. This script will extract the values for each FreeSurfer region of interest (ROI) and generate PNG images to check your cortical and subcortical ROI images. It assumes that your FreeSurfer output are organized in a standard way: _/enigma/Parent_Folder/FreeSurfer/outputs/subject1/_

**SCRIPT: `enigma_fs_wrapper_script.sh`**

* _Step 1:_ Extract Subcortical Measures (volumes)
* _Step 2:_ Extract Cortical Measures (surface area and cortical thickness average)
* _Step 3:_ Quality Checking Subcortical Measures
* _Step 4:_ Quality Checking Cortical Measures - Internal Surface Method
* _Step 5:_ Quality Checking Cortical Measures - External Surface Method


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
				     --fs7 true 
      N.B. --step_(1:5) choose at least one of these steps 

Use `--help` to see all options.


Notes on the steps: 
* Overall, make sure your scripts are executable:

      chmod -R 777 _/enigma/Parent_Folder/scripts
* The extraction steps (i.e., Step 1 & 2) have been updated in April 2021 to correctly extract the full intracranial volume (ICV) value using %f to avoid rounding up of the values when the CSV is opened and edited. The result of these steps will be three comma-separated (CSV) files (“LandRvolumes.csv” for the subcortical measures, “CorticalMeasuresENIGMA_ThickAvg.csv” and “CorticalMeasuresENIGMA_SurfAvg.csv” for the cortical measures) that can be opened in your favorite spreadsheet application (i.e., Excel). After running the script, open the CSV files and make sure that only subjects are listed in the rows of the file. Sometimes if there are other folders in your parent directory those folders can sometimes become included in your final files, if that happens just delete those from your CSV files and save. [When you edit the files in Excel, be sure to keep them in CSV format when you save!] The first row in all csv's are headers describing the extracted regions and names for each column. Each row after the first gives the subcortical volumes (in mm3), cortical thickness average or total surface area measures respectively for each subject found in your FreeSurfer directory.  
* To make the visual QC process faster, this script will create webpages in the same folder as your respective QC outputs: multiple webpages (e.g. "ENIGMA_Amyg_volume_QC.html") and one per subcortical ROI and one called "ENIGMA_Subortical_QC.html" for the Subcortical PNGs, "ENIGMA_Cortical_QC.html" for the Cortical Internal PNGs, and "QC_external.html" for the Cortical External PNGs.
You can open these in any browser, just make sure all of the .png files are in the same folder if you decide to move the html file to a different location (like a local computer). Zoom in and out of the window to adjust the size of the images per row, or click on a subject’s file to see a larger version. To open the webpage in a browser in a Linux environment you can probably just type the following from the QC folder, e.g.,:

      firefox ENIGMA_Cortical_QC.html
      
* The Cortical External method has been updated in April 2021 and uses a Matlab function to plot cortical surface segmentations from different angles. These are updated scripts that will extract the cortical external view PNGs needed for QC in a faster way that does not rely on `tksurfer`. Instead, this script uses a Matlab function (`FS_external_QC.m`).

## Guide for Subcortical & Cortical Structure Visual QC 

I.	Use the ENIGMA Subcortical Control Guide to visually check your subcortical ROI images [Updated guide coming soon!]. Use the [ENIGMA Cortical Control Guide 2.0 (April 2017)](https://drive.google.com/file/d/1P4z42tNPRwwX3U7-L_wsPkxsatGLZaCJ/) to visually check your cortical ROI images.

Unsure of how to rate a segmentation from the PNG? Here is an additional quick code to help view the subject’s segmentation in more detail. This will open up a subject’s FreeSurfer outputs in `freeview`, first by opening the subject in the internal view and then external view.

**SCRIPT: `view_FS_3d_QC.sh`**

II.	Record your QC ratings in an Excel file, as provided in the sample Excel file: `template_Subcortical_QC_ENIGMA_dataset.xlsx` and `template_Cortical_QC_ENIGMA_dataset.xlsx`

III.	Automatically merge the extracted measures with your QC ratings: script coming soon!
<!--- edit_spreadsheet_subcortical.ipynb. This Jupyter Notebook will automatically replace the FreeSurfer measures with NA's if they have been failed by a QC user. You will need to edit the input and output CSV paths in the script. The input is a CSV containing FreeSurfer generated values and your QC sheet. Specifically, the user needs to append the following three CSV's into one, with the subject ID's listed in Column A: (1) Subcortical_QC_ENIGMA_dataset.xlsx, (2) LandRvolumes.csv. The QC notation must follow the rule outlined in the ENIGMA Subcortical QC guide (coming soon) where the QC user will note 1 under each ROI that needs to be failed. If a subject has failed completely, make sure the ICV is also NA’ed. Here is an example file: Subcortical_QC_ENIGMA_dataset_and measures_merged.csv --->
<!--- `edit_spreadsheet_cortical.ipynb`. This Jupyter Notebook will automatically replace the FreeSurfer measures with NA's if they have been failed by a QC user. You will need to edit the input and output CSV paths in the script. The input is a CSV containing FreeSurfer generated values and your QC sheet. Specifically, the user needs to append the following three CSV's into one, with the subject ID's listed in Column A: 1) CorticalMeasuresENIGMA_SurfAvg.csv, 2) CorticalMeasuresENIGMA_ThickAvg.csv, and 3) Cortical_QC_ENIGMA_dataset.xlsx. The QC notation must follow the rule outlined in the ENIGMA Cortical QC guide (upd. 2017) where the QC user will note R, L or R/L  under each ROI depending on if the right, left or both hemisphere ROI failed. e (i.e., R, L or R/L). Also note that columns LThickness, RThickness, LSurfArea, RSurfArea and ICV appear in both CorticalMeasuresENIGMA_ThickAvg.csv and CorticalMeasuresENIGMA_SurfAvg.csv, but you only need to include them once in the merged CSV. If a subject has failed completely, make sure the LThickness, RThickness, LSurfArea, RSurfArea and ICV are also NA’ed. Here is an example file: Cortical_QC_ENIGMA_dataset_and_measures_merged.csv --->

