#!/bin/bash
#$ -S /bin/bash

###### no need to edit this script
###### to run >> ./make_ENIGMA_QC_webpage.sh ${dirO} (where $dirO is the output directory specified for the Matlab script, i.e., /enigma/Parent_Folder/FreeSurfer/QC_subcortical/)

QC_directory=$1
cd $QC_directory
subject_list=`ls -d */`

echo "<html>" 												>  ENIGMA_Subcortical_QC.html
echo "<head>"                                   >> ENIGMA_Subcortical_QC.html
echo "<style type=\"text/css\">"						>> ENIGMA_Subcortical_QC.html
echo "*"                                        >> ENIGMA_Subcortical_QC.html
echo "{"														>> ENIGMA_Subcortical_QC.html
echo "margin: 0px;"										>> ENIGMA_Subcortical_QC.html
echo "padding: 0px;"										>> ENIGMA_Subcortical_QC.html
echo "}"														>> ENIGMA_Subcortical_QC.html
echo "html, body"											>> ENIGMA_Subcortical_QC.html
echo "{"														>> ENIGMA_Subcortical_QC.html
echo "height: 100%;"										>> ENIGMA_Subcortical_QC.html
echo "}"														>> ENIGMA_Subcortical_QC.html
echo "</style>"											>> ENIGMA_Subcortical_QC.html
echo "</head>"												>> ENIGMA_Subcortical_QC.html
echo "<body>" 												>> ENIGMA_Subcortical_QC.html



for roi in Thal Caud Put Pall Hip Amyg NAcc
do 
cp ENIGMA_Subcortical_QC.html ENIGMA_${roi}_volume_QC.html
done



for sub in ${subject_list};
do
	echo "<table cellspacing=\"1\" style=\"width:100%;background-color:#000;\">"				>> ENIGMA_Subcortical_QC.html
	echo "<tr>"																										>> ENIGMA_Subcortical_QC.html
	echo "<td> <FONT COLOR=WHITE FACE=\"Geneva, Arial\" SIZE=5> $sub </FONT> </td>"             >> ENIGMA_Subcortical_QC.html
	echo "</tr>"                                                                                >> ENIGMA_Subcortical_QC.html
	echo "<tr>"                                                                                 >> ENIGMA_Subcortical_QC.html
	echo "<td><a href=\"file:"$sub"/Subcortical_set_Axial_20.png\"><img src=\""$sub"/Subcortical_set_Axial_70_20.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Subcortical_QC.html
	echo "<td><a href=\"file:"$sub"/Subcortical_set_Axial_40.png\"><img src=\""$sub"/Subcortical_set_Axial_70_40.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Subcortical_QC.html
	echo "<td><a href=\"file:"$sub"/Subcortical_set_Axial_60.png\"><img src=\""$sub"/Subcortical_set_Axial_70_60.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Subcortical_QC.html
	echo "<td><a href=\"file:"$sub"/Subcortical_set_Axial_80.png\"><img src=\""$sub"/Subcortical_set_Axial_70_80.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Subcortical_QC.html
	echo "</tr>"																				>> ENIGMA_Subcortical_QC.html
	echo "<tr>"																					>> ENIGMA_Subcortical_QC.html
	echo "<td><a href=\"file:"$sub"/Subcortical_set_Coronal_20.png\"><img src=\""$sub"/Subcortical_set_Coronal_70_20.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Subcortical_QC.html
	echo "<td><a href=\"file:"$sub"/Subcortical_set_Coronal_40.png\"><img src=\""$sub"/Subcortical_set_Coronal_70_40.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Subcortical_QC.html
	echo "<td><a href=\"file:"$sub"/Subcortical_set_Coronal_60.png\"><img src=\""$sub"/Subcortical_set_Coronal_70_60.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Subcortical_QC.html
	echo "<td><a href=\"file:"$sub"/Subcortical_set_Coronal_80.png\"><img src=\""$sub"/Subcortical_set_Coronal_70_80.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Subcortical_QC.html
	echo "</tr>"																				>> ENIGMA_Subcortical_QC.html
	echo "<tr>"																					>> ENIGMA_Subcortical_QC.html
	echo "<td><a href=\"file:"$sub"/Subcortical_set_Sagittal_20.png\"><img src=\""$sub"/Subcortical_set_Sagittal_70_20.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Subcortical_QC.html
	echo "<td><a href=\"file:"$sub"/Subcortical_set_Sagittal_40.png\"><img src=\""$sub"/Subcortical_set_Sagittal_70_40.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Subcortical_QC.html
	echo "<td><a href=\"file:"$sub"/Subcortical_set_Sagittal_60.png\"><img src=\""$sub"/Subcortical_set_Sagittal_70_60.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Subcortical_QC.html
	echo "<td><a href=\"file:"$sub"/Subcortical_set_Sagittal_80.png\"><img src=\""$sub"/Subcortical_set_Sagittal_70_80.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Subcortical_QC.html
	echo "</tr>"																				>> ENIGMA_Subcortical_QC.html	

	echo "</table>"                                                         >> ENIGMA_Subcortical_QC.html
done;
echo "</body>"                                                             >> ENIGMA_Subcortical_QC.html
echo "</html>"                                                             >> ENIGMA_Subcortical_QC.html


#regions=('Thal' 'Caud' 'Put' 'Pall' 'Hip' 'Amyg' 'NAcc')

for roi in Thal Caud Put Pall Hip Amyg NAcc
do 
echo $roi
for sub in ${subject_list};
do
	echo "<table cellspacing=\"1\" style=\"width:100%;background-color:#000;\">"				>> ENIGMA_${roi}_volume_QC.html
	echo "<tr>"																										>> ENIGMA_${roi}_volume_QC.html
	echo "<td> <FONT COLOR=WHITE FACE=\"Geneva, Arial\" SIZE=5> $sub </FONT> </td>"             >> ENIGMA_${roi}_volume_QC.html
	echo "</tr>"                                                                                >> ENIGMA_${roi}_volume_QC.html
	echo "<tr>"                                                                                 >> ENIGMA_${roi}_volume_QC.html
	echo "<td><a href=\"file:"$sub"/${roi}_Axial_25.png\"><img src=\""$sub"/${roi}_Axial_70_25.png\" width=\"100%\" ></a></td>"	>> ENIGMA_${roi}_volume_QC.html
	echo "<td><a href=\"file:"$sub"/${roi}_Axial_50.png\"><img src=\""$sub"/${roi}_Axial_70_50.png\" width=\"100%\" ></a></td>"	>> ENIGMA_${roi}_volume_QC.html
	echo "<td><a href=\"file:"$sub"/${roi}_Axial_75.png\"><img src=\""$sub"/${roi}_Axial_70_75.png\" width=\"100%\" ></a></td>"	>> ENIGMA_${roi}_volume_QC.html
	echo "</tr>"																				>> ENIGMA_${roi}_volume_QC.html
	echo "<tr>"																					>> ENIGMA_${roi}_volume_QC.html
	echo "<td><a href=\"file:"$sub"/${roi}_Coronal_25.png\"><img src=\""$sub"/${roi}_Coronal_70_25.png\" width=\"100%\" ></a></td>"	>> ENIGMA_${roi}_volume_QC.html
	echo "<td><a href=\"file:"$sub"/${roi}_Coronal_50.png\"><img src=\""$sub"/${roi}_Coronal_70_50.png\" width=\"100%\" ></a></td>"	>> ENIGMA_${roi}_volume_QC.html
	echo "<td><a href=\"file:"$sub"/${roi}_Coronal_75.png\"><img src=\""$sub"/${roi}_Coronal_70_75.png\" width=\"100%\" ></a></td>"	>> ENIGMA_${roi}_volume_QC.html
	echo "</tr>"																				>> ENIGMA_${roi}_volume_QC.html
	echo "<tr>"																					>> ENIGMA_${roi}_volume_QC.html
	echo "<td><a href=\"file:"$sub"/${roi}_Sagittal_25.png\"><img src=\""$sub"/${roi}_Sagittal_70_25.png\" width=\"100%\" ></a></td>"	>> ENIGMA_${roi}_volume_QC.html
	echo "<td><a href=\"file:"$sub"/${roi}_Sagittal_50.png\"><img src=\""$sub"/${roi}_Sagittal_70_50.png\" width=\"100%\" ></a></td>"	>> ENIGMA_${roi}_volume_QC.html
	echo "<td><a href=\"file:"$sub"/${roi}_Sagittal_75.png\"><img src=\""$sub"/${roi}_Sagittal_70_75.png\" width=\"100%\" ></a></td>"	>> ENIGMA_${roi}_volume_QC.html
	echo "</tr>"																				>> ENIGMA_${roi}_volume_QC.html	
	echo "</table>"                                                         >> ENIGMA_${roi}_volume_QC.html
done;
echo "</body>"                                                             >> ENIGMA_${roi}_volume_QC.html
echo "</html>"                                                             >> ENIGMA_${roi}_volume_QC.html

done







