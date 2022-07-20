#!/bin/bash
#$ -S /bin/bash

###### no need to edit this script
###### to run >> ./make_ENIGMA_QC_webpage.sh ${dirO}  (where $dirO is the output directory specified for the Matlab script)

QC_directory=$1
cd $QC_directory
subject_list=`ls -d */`

echo "<html>" 												>  ENIGMA_Cortical_QC.html
echo "<head>"                                                   >> ENIGMA_Cortical_QC.html
echo "<style type=\"text/css\">"								>> ENIGMA_Cortical_QC.html
echo "*"                                                        >> ENIGMA_Cortical_QC.html
echo "{"														>> ENIGMA_Cortical_QC.html
echo "margin: 0px;"												>> ENIGMA_Cortical_QC.html
echo "padding: 0px;"											>> ENIGMA_Cortical_QC.html
echo "}"														>> ENIGMA_Cortical_QC.html
echo "html, body"												>> ENIGMA_Cortical_QC.html
echo "{"														>> ENIGMA_Cortical_QC.html
echo "height: 100%;"											>> ENIGMA_Cortical_QC.html
echo "}"														>> ENIGMA_Cortical_QC.html
echo "</style>"													>> ENIGMA_Cortical_QC.html
echo "</head>"													>> ENIGMA_Cortical_QC.html

echo "<body>" 													>>  ENIGMA_Cortical_QC.html


for sub in ${subject_list};
do
echo "<table cellspacing=\"1\" style=\"width:100%;background-color:#000;\">"				>> ENIGMA_Cortical_QC.html
echo "<tr>"																					>> ENIGMA_Cortical_QC.html
echo "<td> <FONT COLOR=WHITE FACE=\"Geneva, Arial\" SIZE=5> $sub </FONT> </td>"             >> ENIGMA_Cortical_QC.html
echo "</tr>"                                                                                >> ENIGMA_Cortical_QC.html
echo "<tr>"                                                                                 >> ENIGMA_Cortical_QC.html
echo "<td><a href=\"file:"$sub"/Cortical_set_Axial_20.png\"><img src=\""$sub"/Cortical_set_Axial_70_20.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Cortical_QC.html
echo "<td><a href=\"file:"$sub"/Cortical_set_Axial_40.png\"><img src=\""$sub"/Cortical_set_Axial_70_40.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Cortical_QC.html
echo "<td><a href=\"file:"$sub"/Cortical_set_Axial_50.png\"><img src=\""$sub"/Cortical_set_Axial_70_50.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Cortical_QC.html
echo "<td><a href=\"file:"$sub"/Cortical_set_Axial_60.png\"><img src=\""$sub"/Cortical_set_Axial_70_60.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Cortical_QC.html
echo "<td><a href=\"file:"$sub"/Cortical_set_Axial_80.png\"><img src=\""$sub"/Cortical_set_Axial_70_80.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Cortical_QC.html
echo "</tr>"																				>> ENIGMA_Cortical_QC.html
echo "<tr>"																					>> ENIGMA_Cortical_QC.html
echo "<td><a href=\"file:"$sub"/Cortical_set_Coronal_20.png\"><img src=\""$sub"/Cortical_set_Coronal_70_20.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Cortical_QC.html
echo "<td><a href=\"file:"$sub"/Cortical_set_Coronal_40.png\"><img src=\""$sub"/Cortical_set_Coronal_70_40.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Cortical_QC.html
echo "<td><a href=\"file:"$sub"/Cortical_set_Coronal_50.png\"><img src=\""$sub"/Cortical_set_Coronal_70_50.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Cortical_QC.html
echo "<td><a href=\"file:"$sub"/Cortical_set_Coronal_60.png\"><img src=\""$sub"/Cortical_set_Coronal_70_60.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Cortical_QC.html
echo "<td><a href=\"file:"$sub"/Cortical_set_Coronal_80.png\"><img src=\""$sub"/Cortical_set_Coronal_70_80.png\" width=\"100%\" ></a></td>"	>> ENIGMA_Cortical_QC.html
echo "</tr>"																				>> ENIGMA_Cortical_QC.html
echo "</table>"                                                                             >> ENIGMA_Cortical_QC.html
done;

echo "</body>"                                                                              >> ENIGMA_Cortical_QC.html
echo "</html>"                                                                              >> ENIGMA_Cortical_QC.html


