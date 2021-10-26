#### Steps:
* [1. Extract Cortical Measures](#1.-extract-cortical-measures)
* [2. Prep for Visual Quality Check of Cortical Structures](#2.-prep-for-visual-quality-check-of-cortical-structures)
  * [I. The Internal Surface Method](#i.-the-internal-surface-method)
  * [II. The External Surface Method](#ii.-the-external-surface-method)
* [3. Visual QC Cortical Structures](#3.-visual-qc-cortical-structures)
* [Outlier Detection of Cortical Measures](outlier-detection-of-cortical-measures)

### 1. Extract Cortical Measures

First, we want to get each subject's cortical Surface Area and Thickness Average of each region of interst (ROI) after running FreeSurfer. In this first step, extract and organize each of the values for each FreeSurfer ROI. The script assumes that your FreeSurfer output are organized in a standard way:
_/enigma/Parent_Folder/FreeSurfer/outputs/subject1/_

SCRIPT: `extract_cortical_measures_v2021.sh` 
* _NB: This is an updated script version which correctly extracts the full intracranial volume (ICV) value using %f to avoid rounding up of the values when the CSV is opened and edited._

Edit the following in your script: 
*	_line 5:_ `fs_dir` to where your FreeSurfer outputs are
*	_line 7:_ `dir` to where your CSV’s will be saved
*	_line 16:_ edit the for loop so that the `ls` command selects the subject folder naming scheme used in your study
 
Run script:    

      sh extract_cortical_FreeSurfer_measures_v2021.sh

The result of this step will be two comma-separated (CSV) files (“CorticalMeasuresENIGMA_ThickAvg.csv” and “CorticalMeasuresENIGMA_SurfAvg.csv”) that can be opened in your favorite spreadsheet application (i.e. Excel). The first row is a header describing the extracted regions and names for each column. Each row after the first gives the cortical thickness average (or total surface area) measures for each subject found in your FreeSurfer directory. In the next step, you will do a QC of the segmentation quality.

_Note 1:_ After running `extract.sh`, open both of the CSV files (“CorticalMeasuresENIGMA_ThickAvg.csv” and “CorticalMeasuresENIGMA_SurfAvg.csv”) and make sure that only subjects are listed in the rows of the file. Sometimes if there are other folders in your parent directory those folders can sometimes become included in your final files, if that happens just delete those from your CSV files and save. 

_Note 2:_ When you edit the files in Excel, be sure to keep them in CSV format when you save them!

### 2. Prep for Visual Quality Check of Cortical Structures

There are two steps for visually quality checking the cortical segmentations outputted from FreeSurfer:

#### I. The Internal Surface Method:
This method uses a Matlab function to plot cortical surface segmentations directly on a subject’s scan and collates snapshots from internal slices of the brain into a webpage for easy checking. First create the QC PNGs.

SCRIPT: `make_cortical_FreeSurfer_internal_QC_png_slices.sh`
* _NB: can also be adjusted to submit in parallel jobs_

Edit the following in your script: 
* _line 5:_ replace `subject1 subject2 subject3` with your subject list.
* _line 10:_ `fs_dir` to where your FreeSurfer outputs are.
* _line 12:_ `qc_dir` to where your internal view QC outputs will be saved.
* _line 21:_ _/enigma/Parent_Folder/scripts/ENIGMA_QC/_ to where you saved your Matlab scripts from the `ENIGMA_QC_3.0.zip` file, as this script will call on the `func_make_corticalpngs_ENIGMA_QC.m` function.
* _line 28:_ `/usr/local/matlab/bin/matlab` to your Matlab directory.

Run script: 

      sh make_cortical_FreeSurfer_internal_QC_png_slices.sh
 
_Note 1:_ `The func_make_corticalpngs_ENIGMA_QC.m` function should take approximately 7 seconds/subject and will output a series of *.png image files separated by individual subject folders.

_Note 2:_ If you run into problems with this Matlab loop try removing the last “/” in the qc_dir variable. So, `qc_dir=/enigma/Parent_Folder/FreeSurfer/QC_cortical_internal/` would become `qc_dir=/enigma/Parent_Folder/FreeSurfer/QC_cortical_internal`.

Then, create a webpage for easy viewing of the internal QC PNGs:

SCRIPT: `make_ENIGMA_QC_cortical_internal_webpage.sh`

There is no need to edit this script, but first make sure it is executable: 

      chmod 777 make_ENIGMA_QC_cortical_internal_webpage.sh

Run script by giving the script the full path to the directory where you stored the Matlab QC output files:

      ./make_ENIGMA_QC_cortical_internal_webpage.sh /enigma/Parent_Folder/FreeSurfer/QC_cortical_internal/

This script will create a webpage called `ENIGMA_Cortical_QC.html` in the same folder as your QC output. You can open the ENIGMA_Cortical_QC.html file in any browser, just make sure all of the .png files are in the same folder if you decide to move the `ENIGMA_Cortical_QC.html` file to a different location (like a local computer). Zoom in and out of the window to adjust the size of the images per row, or you can click on a subject’s file to see a larger version. To open the webpage in a browser in a Linux environment you can probably just type the following from the _/QC_cortical_internal/_ folder:

      firefox ENIGMA_Cortical_QC.html

_Note 1:_ If you have trouble running this script, it’s possible that you need to fix the line endings in the script before running. You can do this by running this command: 

      sed -i -e 's/\r$//' make_ENIGMA_QC_cortical_internal_webpage.sh

_Note 2:_ you can use the legend.jpg file found in the _/enigma/Parent_Folder/scripts/ENIGMA_QC/_ folder as a colored coded reference of each FreeSurfer ROI (split by left/right). 

#### II. The External Surface Method:
This method uses a Matlab function to plot cortical surface segmentations from different angles. 
_NB:_ These are updated scripts that will extract the cortical external view PNGs needed for QC in a faster way that does not rely on `tksurfer`. Instead, this script uses a Matlab function (`FS_external_QC.m`) found in the `ENIGMA_QC_3.0.zip` file.

SCRIPT: make_cortical_FreeSurfer_external_QC_png_v2021.sh
* NB: can also be adjusted to submit in parallel jobs

Edit the following in your script: 
*	_line 7:_ fs_dir to where your FreeSurfer outputs are
*	_line 9:_ qc_dir to where your external view QC outputs will be saved
*	_line 13:_ _/enigma/Parent_Folder/scripts/ENIGMA_QC/_ to where you saved your Matlab scripts from the `ENIGMA _QC_3.0.zip` file, as this script will call on `FS_external_QC.m`.
*	_line 16:_ replace subject1 subject2 subject3 with your subject list 
*	_line 19:_ your Matlab directory `/usr/local/matlab/bin/matlab`
* You will also need to edit the `FS_external_QC.m` Matlab function in your text editor (_line 6_ `addpath(genpath('/enigma/Parent_Folder/scripts/ENIGMA_QC/'));`) to lead to your scripts folder. 

Run script: 

      sh make_cortical_FreeSurfer_external_QC_png_v2021.sh

Create a webpage for easy viewing of the external QC PNGs:

SCRIPT: `make_ENIGMA_QC_cortical_external_webpage_v2021.sh`

Open the script and edit:
-	_line 29:_ replace `subject1 subject2 subject3` with your subject list

Run the bash script (while in your scripts folder) by giving the script the full path to the directory where you stored the external view cortical QC output files:

      sh ./make_ENIGMA_QC_cortical_external_webpage_v2021.sh /enigma/Parent_Folder/Freesurfer/QC_cortical_external/

This script will create a webpage called `QC_external.html` in the same folder as your QC outputs. You can open the QC_external.html file in any browser, just make sure all of the .png files are in the same folder if you decide to move the `QC_external.html` file to a different location (like a local computer). Zoom in and out of the window to adjust the size of the images, or you can click on a subject’s file to see a larger version. To open the webpage in a browser in a Linux environment you can probably just type the following from the _/QC_cortical_external/_ folder:

      firefox QC_external.html

### 3. Visual QC Cortical Structures

Use the ENIGMA Cortical Control Guide 2.0 (April 2017) and the ENIGMA Cortical QC Template to conduct and record your quality ratings. 

I.	[Cortical QC guide PDF](https://drive.google.com/file/d/0Bw8Acd03pdRSU1pNR05kdEVWeXM/) 

II.	Sample Excel file to keep track of your QC ratings: `Cortical_QC_ENIGMA_dataset.xlsx`

III.	How to merge the extracted measures with your QC ratings: `edit_spreadsheet_cortical.ipynb`. This Jupyter Notebook will automatically replace the FreeSurfer measures with NA's if they have been failed by a QC user. You will need to edit the input and output CSV paths in the script. The input is a CSV containing FreeSurfer generated values and your QC sheet. Specifically, the user needs to append the following three CSV's into one, with the subject ID's listed in Column A: 1) CorticalMeasuresENIGMA_SurfAvg.csv, 2) CorticalMeasuresENIGMA_ThickAvg.csv, and 3) Cortical_QC_ENIGMA_dataset.xlsx. The QC notation must follow the rule outlined in the ENIGMA Cortical QC guide (upd. 2017) where the QC user will note R, L or R/L  under each ROI depending on if the right, left or both hemisphere ROI failed. e (i.e., R, L or R/L). Also note that columns LThickness, RThickness, LSurfArea, RSurfArea and ICV appear in both CorticalMeasuresENIGMA_ThickAvg.csv and CorticalMeasuresENIGMA_SurfAvg.csv, but you only need to include them once in the merged CSV. If a subject has failed completely, make sure the LThickness, RThickness, LSurfArea, RSurfArea and ICV are also NA’ed. Here is an example file: Cortical_QC_ENIGMA_dataset_and_measures_merged.csv

Finally, if you need to open up a subject’s FreeSurfer outputs in `freeview` to view the subject’s segmentation in more detail, here is an additional quick code to help you first open the internal view and then the external view for each subject. This is a bash script which you can configure to preview the FreeSurfer outputs in freeview, by just adjusting the FreeSurfer export (_line 7-8_) and FreeSurfer outputs directory (_line 9_) and running it command line: 

      sh ./view_FS_3d_QC.sh subjectID

Sample code:
  
      #!/bin/bash
      #$ -S /bin/bash

      SUBJECT=$1
      export LD_PATH_LIBRARY=${LD_PATH_LIBRARY}:/usr/local/freesurfer-v7.1.0/lib/vtk/lib/vtk-5.6
      export FREESURFER_HOME="/usr/local/freesurfer-v7.1.0"
      export SUBJECTS_DIR=/enigma/Parent_Folder/FreeSurfer/outputs/ #change directory to where the FreeSurfer outputs are
      cd ${SUBJECTS_DIR}

      freeview -v ${SUBJECT}/mri/orig.mgz \
      $SUBJECT/mri/aparc+aseg.mgz:colormap=lut:opacity=0.4

      freeview -f  ${SUBJECT}/surf/lh.pial:annot=aparc.annot:name=pial_aparc:visible=0 \
      ${SUBJECT}/surf/rh.pial:annot=aparc.annot:name=pial_aparc:visible=0 \
      --viewport 3d 

### Outlier Detection of Cortical Measures

This is a simple R script that will identify subjects with cortical thickness and surface area values that deviate from the rest of your subjects.

SCRIPT: `outliers_cortical.R`

Edit the following in your script: 
*	_line 5 and 37:_ directories to the location of your CorticalMeasuresENIGMA_ThickAvg.csv and CorticalMeasuresENIGMA_SurfAvg.csv generated in the previous step: /enigma/Parent_Folder/FreeSurfer/measures/

Run in your terminal or R window: 

      R --no-save --slave < outliers_cortical.R > /enigma/Parent_Folder/FreeSurfer/measures/outliers_cortical.log

This will generate a log file that will tell you which subjects are outliers and for which structures they are outliers for. Make sure you look at these subjects closely as you proceed with the quality check protocol to make sure they are segmented properly. 

_Note:_ Just because a subject is an outlier does not necessarily mean they should be excluded from the analysis. If a subject is segmented properly in FreeSurfer (which you will visually verify at later steps in this protocol) then please do keep them in the analysis.
