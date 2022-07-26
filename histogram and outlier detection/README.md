## Generate Histogram Plots for Subcortical Measures

In the next step, you can generate histogram plots of your data, which your working group leaders might request for analyses. 

**SCRIPT: `subcortical_histogram_plots.R`**

You do not need to edit this script which will call on the "LandRvolumes.csv" which should look like this:

      SubjID,LLatVent,RLatVent,Lthal,Rthal,Lcaud,Rcaud,Lput,Rput,Lpal,Rpal,Lhippo,Rhippo,Lamyg,Ramyg,Laccumb,Raccumb,ICV
      subj01,6523.3,9343.5,7598.5,4488.2,4752.4,5665.3,5864.59,2052.69,1842.28,3398.2,4052.37,787.061,702.422,591.68,576.65,0.908024
      subj02,5362.22,7786.76,7885.63,4106.95,3923.44,4746.09,5222.29,1819.34,1961.72,3454.37,3675.85,933.398,880.4,x,x,0.737983
      subj03,4476.45,5984.82,5984.82,4583.94,4466.07,4263.57,3899.71,x,x,3172.76,3083.38,599.59,435.85,146.338,253.916,0.677593
      subj04,3375.55,7115.98,6468.93,x,4078.48,5056.96,5150.3,567.949,617.783,3628.39,3214.69,1091.6,1033.86,435.85,208.037,0.637183

Make sure that the columns are in the same order as in the file above. Note that the “x” is the marker that should be used to mark files as poorly segmented or excluded according to the QC guide. Also, you need to make sure that there are no missing values in the file. In the "LandRvolumes.csv" file missing values will appear as two commas in a row “,,”. Missing values are probably easier to see in a spreadsheet program like Microsoft Excel, there it will just be a blank cell. You need to put an “x” value for any missing value so that it will be excluded from the analysis. 

Run the R script from inside _/enigma/Parent_Folder/FreeSurfer/measures/_ to generate the plots:

      R --no-save --slave < /enigma/Parent_Folder/scripts/subcortical/subcortical_histogram_plots.R

It should only take a few minutes to generate all of the plots. If you get errors, they should tell you what things need to be changed in the file in order to work properly. Just make sure that your input file is in .csv format similar to the file above.

The outputs in _/enigma/Parent_Folder/freesurfer_enigma_test/subcortical/_ will be `SummaryStats.txt` and a series of PNG image files that you can open in any standard picture viewer. You need to go through each of the PNG files to make sure that your histograms look approximately normal. 

## Detect Outliers for Subcortical Measures

Now we will run a semi-automated script to detect outliers, which is based on the `SummaryStats.txt`-file you created with `R`, and "LandRvolumes.csv". This is done by defining the Interquartile Interval (IQI), defined as Quartile 1 (Q1) – 1.5 times the Interquartile Range (IQR) to Quartile 3 (Q3) + 1.5 times the IQR. For a normal distribution this is equivalent to the mean+/-2.698 standard deviations. This script assumes a normal distribution.

**SCRIPT: `subcortical_mkIQIrange.sh`**

Run the R script from inside _/enigma/Parent_Folder/FreeSurfer/measures/_:

      ./enigma/Parent_Folder/scripts/subcortical/subcortical_mkIQIrange.sh > subcortical_jnk.txt

Then run the following code from the save folder:

      more subcortical_jnk.txt | grep "has" |  awk -F/ ' { print $NF } ' | awk ' { print $1 } '| sort | uniq > subcortical_jnk2.txt
      more subcortical_jnk2.txt | wc -l
      hd=`pwd`

## Outlier Detection of Cortical Measures

This is a simple R script that will identify subjects with cortical thickness and surface area values that deviate from the rest of your subjects.

**SCRIPT: `cortical_outliersl.R`**

Edit the following in your script: 
*	_line 5 and 37:_ directories to the resepctive location of your CorticalMeasuresENIGMA_ThickAvg.csv and CorticalMeasuresENIGMA_SurfAvg.csv generated in the previous step. 

Run the script in your terminal or R window: 

      R --no-save --slave < cortical_outliersl.R > /enigma/Parent_Folder/FreeSurfer/measures/outliers_cortical.log

This will generate a log file that will tell you which subjects are outliers and for which structures they are outliers for. Make sure you look at these subjects closely as you proceed with the quality check protocol to make sure they are segmented properly. 

_Note:_ Just because a subject is an outlier does not necessarily mean they should be excluded from the analysis. If a subject is segmented properly in FreeSurfer (which you will visually verify at later steps in this protocol) then please do keep them in the analysis.
