# ENIGMA FreeSurfer cortical and subcortical extraction and QC

Use these protocols for the analysis of subcortical volume, and cortical thickness and surface area data within FreeSurfer ROI's for ENIGMA working groups. If you have any questions or run into problems, please feel free to contact enigma@ini.usc.edu.

These protocols are offered with an unlimited license and without warranty. However, if you find these protocols useful in your research, please provide a link to the ENIGMA website in your work: www.enigma.ini.usc.edu

In all template scripts, we assume the following main path set-up which you will need to replace if different: _/enigma/Parent_Folder/_. Save all scripts in a folder as follows: _/enigma/Parent_Folder/scripts/_. In addition to the scripts provided, download the collection of Matlab scripts called `ENIGMA_QC_3.0.zip`, unzip the directory, and change directories to that folder with the required Matlab `.m` scripts. For simplicity, we assume you are working on a Linux machine with the base directory _/enigma/Parent_Folder/scripts/ENIGMA_QC/_. 

All scripts are in a for loop configuration, but if you have a computing system which allows you to parallelize jobs, we highlight where you could edit the script in order to run through your subjects faster. 
