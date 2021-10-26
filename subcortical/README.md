#### Steps:
* [1. Extract Subcortical Measures](#1.-extract-subcortical-measures)
* [2. Prep for Visual Quality Check of Subortical Structures](#2.-prep-for-visual-quality-check-of-subcortical-structures)
* [3. Visual QC Subcortical Structures](#3.-visual-qc-subcortical-structures)
* [4. Generate Histogram Plots for Subcortical Measures](#4.-generate-histogram-plots-for-subcortical-measures)
* [5. Detect Outliers for the Subcortical Measures](#4.-detect-outliers-for-subcortical-measures)

### 1. Extract Subcortical Measures

Similar to the cortical measures, we want to get the subcortical Volumes of each ROI for each subject from FreeSurfer. This script will extract and organize each of the values for each FreeSurfer ROI. The script assumes that your FreeSurfer output are organized in a standard way:
_/enigma/Parent_Folder/FreeSurfer/outputs/subject1/_

SCRIPT: `extract_subcortical_FreeSurfer_measures_v2021.sh`
* _NB: this is an updated script version which correctly extracts the full ICV number with %f to avoid rounding up of the values when the CSV is opened._ 

Edit the following in your script: 
*	_line 5:_ `fs_dir` to where your FreeSurfer outputs are
*	_line 7:_ `dir` to where your CSV will be saved
*	_line 14:_ edit the for loop so that the ls command selects the subject folder naming scheme used in your study
*	_line 17:_ if you are using FreeSurfer version 7 and above: replace `Left-Thalamus-Proper` and `Right-Thalamus-Proper` with `Left-Thalamus` and `Right-Thalamus`, respectively.
 
Run script: 

      sh extract_subcortical_FreeSurfer_measures_v2021.sh

The result of this step will be one comma-separated (CSV) file (“LandRvolumes.csv”) that can be opened in your favorite spreadsheet application (i.e., Excel). It should contain a table with volumes (in mm3) of the ventricles, thalamus, caudate, putamen, pallidum, hippocampus, amygdala and accumbens and intracranial volume (ICV) for each subject. The first row is a header describing the extracted regions and names for each column. Each row after the first gives the cortical thickness average (or total surface area) measures for each subject found in your FreeSurfer directory. In the next step, you will do a QC of the segmentation quality.

_Note 1:_ After running the script, the CSV file ("LandRvolumes.csv") and make sure that only subjects are listed in the rows of the file. Sometimes if there are other folders in your parent directory those folders can sometimes become included in your final files, if that happens just delete those from your CSV files and save. 
_Note 2:_ When you edit the files in Excel, be sure to keep them in CSV format when you save!

### 2. Prep for Visual Quality Check of Subcortical Structures

First, create subcortical QC PNGs:

SCRIPT: `make_subcortical_FreeSurfer_QC_png_slices.sh`
* _NB: can also be adjusted to submit in parallel jobs_

Edit the following in your script: 
*	_line 5:_ replace `subject1 subject2 subject3` with your subject list 
*	_line 10:_ `fs_dir` to where your FreeSurfer outputs are 
*	_line 12:_ `qc_dir` to where your subcortical QC outputs will be saved
*	_line 21:_ `/enigma/Parent_Folder/scripts/ENIGMA_QC/` to where you saved your scripts
*	_line 28:_ `/usr/local/matlab/bin/matlab` to your Matlab directory

Run script: 

      sh make_subcortical_FreeSurfer_QC_png_slices.sh
 
The func_make_subcorticalFS_ENIGMA_QC-script should take approximately 7 seconds/subject and will output a series of .png image files separated by individual subject folders.

Note: if you run into problems with this Matlab loop try removing the last “/” in the qc_dir variable. So, `qc_dir=/enigma/Parent_Folder/FreeSurfer/QC_subcortical/` would become `qc_dir=/enigma/Parent_Folder/FreeSurfer/QC_subcortical`

Then, create a webpage for easy viewing of the subcortical QC PNGs:

SCRIPT: `make_ENIGMA_QC_webpage_subcortical.sh`

Make sure it is executable:
      chmod 777 make_ENIGMA_QC_webpage_subcortical.sh

Run the bash script (while in your /scripts/ENIGMA_QC/ folder) by giving the script the full path to the directory where you stored the subcortical QC output files: 

      ./make_ENIGMA_QC_webpage_subcortical.sh /enigma/Parent_Folder/FreeSurfer/QC_subcortical/

_Note 1:_ If you have trouble running this script, it’s possible that you need to fix the line endings in the script before running. You can do this by running this command: 

      sed -i -e 's/\r$//' make_ENIGMA_QC_webpage_subcortical.sh

_Note 2:_ The script will create multiple webpages (e.g. ‘ENIGMA_Amyg_volume_QC.html’, ENIGMA_Subcortical_QC.html’) in the same folder as your QC output. If you want to check the segmentation on another computer, you can just copy over the whole QC-folder to your computer and open the webpage from there. To open one of these webpages in a browser of your choice in a Linux environment. For example: 

      firefox ENIGMA_Subcortical_QC.html

### 3. Visually QC Subcortical Structures

I.	Guide: detailed guide coming soon 
II.	Sample excel file to keep track of your QC ratings: Subcortical_QC_ENIGMA_dataset.xlsx
III.	How to merge the extracted measures with your QC ratings: edit_spreadsheet_subcortical.ipynb. This Jupyter Notebook will automatically replace the FreeSurfer measures with NA's if they have been failed by a QC user. You will need to edit the input and output CSV paths in the script. The input is a CSV containing FreeSurfer generated values and your QC sheet. Specifically, the user needs to append the following three CSV's into one, with the subject ID's listed in Column A: (1) Subcortical_QC_ENIGMA_dataset.xlsx, (2) LandRvolumes.csv. The QC notation must follow the rule outlined in the ENIGMA Subcortical QC guide (coming soon) where the QC user will note 1 under each ROI that needs to be failed. If a subject has failed completely, make sure the ICV is also NA’ed. Here is an example file: Subcortical_QC_ENIGMA_dataset_and measures_merged.csv

### 4. Generate Histogram Plots for Subcortical Measures

In the next step, you can generate histogram plots of your data, which your working group leaders might request for analyses. 

SCRIPT: `histogram_plots_subcortical.R`

You do not need to edit this script which will call on the LandRvolumes.csv which should look like this:

      SubjID,LLatVent,RLatVent,Lthal,Rthal,Lcaud,Rcaud,Lput,Rput,Lpal,Rpal,Lhippo,Rhippo,Lamyg,Ramyg,Laccumb,Raccumb,ICV
      subj01,6523.3,9343.5,7598.5,4488.2,4752.4,5665.3,5864.59,2052.69,1842.28,3398.2,4052.37,787.061,702.422,591.68,576.65,0.908024
      subj02,5362.22,7786.76,7885.63,4106.95,3923.44,4746.09,5222.29,1819.34,1961.72,3454.37,3675.85,933.398,880.4,x,x,0.737983
      subj03,4476.45,5984.82,5984.82,4583.94,4466.07,4263.57,3899.71,x,x,3172.76,3083.38,599.59,435.85,146.338,253.916,0.677593
      subj04,3375.55,7115.98,6468.93,x,4078.48,5056.96,5150.3,567.949,617.783,3628.39,3214.69,1091.6,1033.86,435.85,208.037,0.637183

Make sure that the columns are in the same order as in the file above. Also, note that the “x” is the marker that should be used to mark files as poorly segmented or excluded (see step 8). Also, you need to make sure that there are no missing values in the file. In the LandRvolumes.csv file missing values will appear as two commas in a row “,,”. Missing values are probably easier to see in a spreadsheet program like Microsoft Excel, there it will just be a blank cell. You need to put an “x” value for any missing value so that it will be excluded from the analysis. 

Run the R script from inside /enigma/Parent_Folder/FreeSurfer/measures/to generate the plots:

      R --no-save --slave < /enigma/Parent_Folder/scripts/histogram_plots_subcortical.R

It should only take a few minutes to generate all of the plots. If you get errors, they should tell you what things need to be changed in the file in order to work properly. Just make sure that your input file is in .csv format similar to the file above.

The outputs in _/Parent_Folder/freesurfer_enigma_test/subcortical/_ will be SummaryStats.txt and a series of PNG image files that you can open in any standard picture viewer. You need to go through each of the PNG files to make sure that your histograms look approximately normal. 

### 5. Detect Outliers for Subcortical Measures

Now we will run a semi-automated script to detect outliers, which is based on the SummaryStats.txt-file you created with R, and LandRvolumes.csv. This is done by defining the Interquartile Interval (IQI), defined as Quartile 1 (Q1) – 1.5 times the Interquartile Range (IQR) to Quartile 3 (Q3) + 1.5 times the IQR. For a normal distribution this is equivalent to the mean+/-2.698 standard deviations. This script assumes a normal distribution.

SCRIPT: `mkIQIrange_subcortical.sh`

Move the script from your scripts folder, save and run inside /enigma/Parent_Folder/FreeSurfer/measures/:

      ./ mkIQIrange_subcortical.sh > subcortical_jnk.txt

Then run the following code from the save folder:

      more jnk.txt | grep "has" |  awk -F/ ' { print $NF } ' | awk ' { print $1 } '| sort | uniq > jnk2.txt
      more jnk2.txt | wc -l
      hd=`pwd
