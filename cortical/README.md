#### Steps Overview
* [Extract Cortical Measures](#extract-cortical-measures)
* [Prep for Visual Quality Check of Cortical Structures](#prep-for-visual-quality-check-of-cortical-structures)
  * [The Internal Surface Method](#the-internal-surface-method)
  * [The External Surface Method](#the-external-surface-method)
* [Visual QC Cortical Structures](#visual-qc-cortical-structures)
* [Outlier Detection of Cortical Measures](#outlier-detection-of-cortical-measures)

## Extract Cortical Measures

First, we want to get each subject's cortical Surface Area and Thickness Average of each region of interst (ROI) after running FreeSurfer. In this first step, extract and organize each of the values for each FreeSurfer ROI. The script assumes that your FreeSurfer output are organized in a standard way:
_/enigma/Parent_Folder/FreeSurfer/outputs/subject1/_

**SCRIPT: `01_extract_cortical_FreeSurfer_measures.sh`** 
* _NB: This is an updated script version from April 2021 which correctly extracts the full intracranial volume (ICV) value using %f to avoid rounding up of the values when the CSV is opened and edited._

Edit the following in your script: 
*	_line 7:_ `fs_dir` to where your FreeSurfer outputs are.
*	_line 9:_ `dir` to where your CSV’s will be saved.
*	_line 18:_ edit the for loop so that the `ls` command selects the subject folder naming scheme used in your study.
 
Run script:    

      sh 01_extract_cortical_FreeSurfer_measures.sh

The result of this step will be two comma-separated (CSV) files (“CorticalMeasuresENIGMA_ThickAvg.csv” and “CorticalMeasuresENIGMA_SurfAvg.csv”) that can be opened in your favorite spreadsheet application (i.e. Excel). The first row is a header describing the extracted regions and names for each column. Each row after the first gives the cortical thickness average (or total surface area) measures for each subject found in your FreeSurfer directory. In the next step, you will do a QC of the segmentation quality.

_Note 1:_ After running `extract.sh`, open both of the CSV files (“CorticalMeasuresENIGMA_ThickAvg.csv” and “CorticalMeasuresENIGMA_SurfAvg.csv”) and make sure that only subjects are listed in the rows of the file. Sometimes if there are other folders in your parent directory those folders can sometimes become included in your final files, if that happens just delete those from your CSV files and save. 

_Note 2:_ When you edit the files in Excel, be sure to keep them in CSV format when you save them!

## Prep for Visual Quality Check of Cortical Structures

There are two steps for visually quality checking the cortical segmentations outputted from FreeSurfer:

### The Internal Surface Method:
This method uses a Matlab function to plot cortical surface segmentations directly on a subject’s scan and collates snapshots from internal slices of the brain into a webpage for easy checking. First create the QC PNGs:

**SCRIPT: `02_make_cortical_FreeSurfer_internal_QC_png_slices.sh`**
* _NB: this script can also be adjusted to be submitted to a computing cluster_

Edit the following in your script: 
* _line 5:_ replace `subject1 subject2 subject3` with your subject list.
* _line 10:_ `fs_dir` to where your FreeSurfer outputs are.
* _line 12:_ `qc_dir` to where your internal view QC outputs will be saved.
* _line 21:_ _/enigma/Parent_Folder/scripts/ENIGMA_QC/_ to where you saved your Matlab scripts from the `ENIGMA_QC_3.0.zip` file, as this script will call on the `func_make_corticalpngs_ENIGMA_QC.m` function and its dependencies.
* _line 30:_ `/usr/local/matlab/bin/matlab` should point to your Matlab directory.

Run script: 

      sh 02_make_cortical_FreeSurfer_internal_QC_png_slices.sh
 
_Note 1:_ The `func_make_corticalpngs_ENIGMA_QC.m` function should take approximately 7 seconds/subject and will output a series of .png image files separated by individual subject folders.

_Note 2:_ If you run into problems with this Matlab loop try removing the last “/” in the qc_dir variable. So, `qc_dir=/enigma/Parent_Folder/FreeSurfer/QC_cortical_internal/` would become `qc_dir=/enigma/Parent_Folder/FreeSurfer/QC_cortical_internal`.

Then, create a webpage for easy viewing of the internal QC PNGs:

**SCRIPT: `make_ENIGMA_QC_cortical_internal_webpage.sh`**

This script is found in your _/enigma/Parent_Folder/scripts/ENIGMA_QC/_ directory. There is no need to edit this script, but first make sure it is executable: 

      chmod 777 make_ENIGMA_QC_cortical_internal_webpage.sh

Run the bash script (while in your _/scripts/ENIGMA_QC/_ folder) by giving the script the full path to the directory where you stored the subcortical QC output PNG files: 

      ./make_ENIGMA_QC_cortical_internal_webpage.sh /enigma/Parent_Folder/FreeSurfer/QC_cortical_internal/

This script will create a webpage called "ENIGMA_Cortical_QC.html" in the same folder as your QC outputs. You can open the html file in any browser, just make sure all of the .png files are in the same folder if you decide to move the "ENIGMA_Cortical_QC.html" file to a different location (like a local computer). Zoom in and out of the window to adjust the size of the images per row, or click on a subject’s file to see a larger version. To open the webpage in a browser in a Linux environment you can probably just type the following from the _/QC_cortical_internal/_ folder:

      firefox ENIGMA_Cortical_QC.html

_Note 1:_ If you have trouble running this script, it’s possible that you need to fix the line endings in the script before running. You can do this by running this command: 

      sed -i -e 's/\r$//' make_ENIGMA_QC_cortical_internal_webpage.sh

_Note 2:_ You can use the legend.jpg file found in the _/enigma/Parent_Folder/scripts/ENIGMA_QC/_ folder as a colored coded reference of each FreeSurfer ROI (split by left/right). 

### The External Surface Method:
This method has been updated in April 2021 and uses a Matlab function to plot cortical surface segmentations from different angles. These are updated scripts that will extract the cortical external view PNGs needed for QC in a faster way that does not rely on `tksurfer`. Instead, this script uses a Matlab function (`FS_external_QC.m`) found in the `ENIGMA_QC_3.0.zip` file. First, create the PNGs:

**SCRIPT: `03_make_cortical_FreeSurfer_external_QC_png.sh`**
* _NB: This script can also be adjusted to be submitted to a computing cluster_

Edit the following in your script: 
*	_line 10:_ `fs_dir` to where your FreeSurfer outputs are.
*	_line 12:_ `qc_dir` to where your external view QC outputs will be saved.
*	_line 16:_ _/enigma/Parent_Folder/scripts/ENIGMA_QC/_ to where you saved your Matlab scripts from the `ENIGMA _QC_3.0.zip` file, as this script will call on `FS_external_QC.m` and its dependencies.
*	_line 19:_ replace `subject1 subject2 subject3` with your subject list. 
*	_line 22:_ `/usr/local/matlab/bin/matlab` should point to your Matlab directory.
* You will also need to edit the `FS_external_QC.m` Matlab function file in your text editor (_line 6_ `addpath(genpath('/enigma/Parent_Folder/scripts/ENIGMA_QC/'));`) to lead to your scripts folder. 

Run script: 

      sh 03_make_cortical_FreeSurfer_external_QC_png.sh

Then, create a webpage for easy viewing of the external QC PNGs using the updated script from April 2021. This script is found in your _/enigma/Parent_Folder/scripts/ENIGMA_QC/_ directory.

**SCRIPT: `make_ENIGMA_QC_cortical_external_webpage_v2021.sh`**

Edit the following in your script: 
-	_line 29:_ replace `subject1 subject2 subject3` with your subject list

Run the bash script by giving the script the full path to the directory where you stored the external view cortical QC output files:

      sh ./make_ENIGMA_QC_cortical_external_webpage_v2021.sh /enigma/Parent_Folder/Freesurfer/QC_cortical_external/

This script will create a webpage called "QC_external.html" in the same folder as your QC outputs. You can open the html file in any browser, just make sure all of the .png files are in the same folder if you decide to move the "QC_external.html" file to a different location (like a local computer). Zoom in and out of the window to adjust the size of the images, or click on a subject’s file to see a larger version. To open the webpage in a browser in a Linux environment you can probably just type the following from the _/QC_cortical_external/_ folder:

      firefox QC_external.html

## Visual QC Cortical Structures
I.	Use the [ENIGMA Cortical Control Guide 2.0 (April 2017)](https://drive.google.com/file/d/1P4z42tNPRwwX3U7-L_wsPkxsatGLZaCJ/) to visually check your cortical ROI images.

Unsure of how to rate a segmentation from the PNG? Here is an additional quick code to help view the subject’s segmentation in more detail. This will open up a subject’s FreeSurfer outputs in `freeview`, first by opening the subject in the internal view and then external view.

**SCRIPT: `view_FS_3d_QC.sh`**

Edit the following in your script: 
*	_line 6-7:_ configure the correct FreeSurfer environment like in your `run_FreeSurfer_loop.sh` script.
*	_line 8:_ `SUBJECTS_DIR` to where your FreeSurfer outputs are.

Run script by providing the subject ID after the script: 

      sh ./view_FS_3d_QC.sh subjectID

II.	Record your QC ratings in an Excel file, as provided in the sample Excel file: `Cortical_QC_ENIGMA_dataset.xlsx`

III.	Merge the extracted measures with your QC ratings: jupyter notebook coming soon!
<!--- `edit_spreadsheet_cortical.ipynb`. This Jupyter Notebook will automatically replace the FreeSurfer measures with NA's if they have been failed by a QC user. You will need to edit the input and output CSV paths in the script. The input is a CSV containing FreeSurfer generated values and your QC sheet. Specifically, the user needs to append the following three CSV's into one, with the subject ID's listed in Column A: 1) CorticalMeasuresENIGMA_SurfAvg.csv, 2) CorticalMeasuresENIGMA_ThickAvg.csv, and 3) Cortical_QC_ENIGMA_dataset.xlsx. The QC notation must follow the rule outlined in the ENIGMA Cortical QC guide (upd. 2017) where the QC user will note R, L or R/L  under each ROI depending on if the right, left or both hemisphere ROI failed. e (i.e., R, L or R/L). Also note that columns LThickness, RThickness, LSurfArea, RSurfArea and ICV appear in both CorticalMeasuresENIGMA_ThickAvg.csv and CorticalMeasuresENIGMA_SurfAvg.csv, but you only need to include them once in the merged CSV. If a subject has failed completely, make sure the LThickness, RThickness, LSurfArea, RSurfArea and ICV are also NA’ed. Here is an example file: Cortical_QC_ENIGMA_dataset_and_measures_merged.csv --->

## Outlier Detection of Cortical Measures

This is a simple R script that will identify subjects with cortical thickness and surface area values that deviate from the rest of your subjects.

**SCRIPT: `04_outliers_cortical.R`**

Edit the following in your script: 
*	_line 5 and 37:_ directories to the resepctive location of your CorticalMeasuresENIGMA_ThickAvg.csv and CorticalMeasuresENIGMA_SurfAvg.csv generated in the previous step. 

Run the script in your terminal or R window: 

      R --no-save --slave < 04_outliers_cortical.R > /enigma/Parent_Folder/FreeSurfer/measures/outliers_cortical.log

This will generate a log file that will tell you which subjects are outliers and for which structures they are outliers for. Make sure you look at these subjects closely as you proceed with the quality check protocol to make sure they are segmented properly. 

_Note:_ Just because a subject is an outlier does not necessarily mean they should be excluded from the analysis. If a subject is segmented properly in FreeSurfer (which you will visually verify at later steps in this protocol) then please do keep them in the analysis.
