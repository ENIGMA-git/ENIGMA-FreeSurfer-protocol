#!/bin/bash
#$ -S /bin/bash

# Here's a simple code to create an HTML page to view your PNG images for QC! Only need to edit your subject list
# Updated April 2021 by Iyad Ba Gari (IGC USC) - enigma.ini.usc.edu

###### 
###### to run >> ./make_ENIGMA_QC_cortical_external_webpage_v2021.sh ${dirO} (where $dirO is the output directory specified for the Matlab script, i.e., /enigma/Parent_Folder/FreeSurfer/QC_cortical_external/)

dirI=$1
cd $dirI

echo "<html>" 						>  QC_external.html
echo "<head>"                       >> QC_external.html
echo "<style type=\"text/css\">"	>> QC_external.html
echo "*"                            >> QC_external.html
echo "{"							>> QC_external.html
echo "margin: 0px;"					>> QC_external.html
echo "padding: 0px;"				>> QC_external.html
echo "}"							>> QC_external.html
echo "html, body"					>> QC_external.html
echo "{"							>> QC_external.html
echo "height: 100%;"				>> QC_external.html
echo "}"							>> QC_external.html
echo "</style>"						>> QC_external.html
echo "</head>"						>> QC_external.html
echo "<body>" 						>> QC_external.html

for subj in subject1 subject2 subject3; # Edit your subject list here
do
    echo "<table cellspacing=\"1\" style=\"width:100%;background-color:black;\">"	>> QC_external.html
    echo "<tr>" >> QC_external.html
    echo "<td> <FONT COLOR=white FACE=\"Geneva, Arial\" SIZE=5> $subj </FONT> </td>" >> QC_external.html
    echo "</tr>" >> QC_external.html                                                                        

    echo "<tr>" >> QC_external.html 
    echo "<td><a href=\"file:"$subj".lh.lat.png\"><img src=\""$subj".lh.lat.png\" width=\"100%\" ></a></td>"	>> QC_external.html
    echo "<td><a href=\"file:"$subj".lh.med.png\"><img src=\""$subj".lh.med.png\" width=\"100%\" ></a></td>"	>> QC_external.html
    echo "<td><a href=\"file:"$subj".rh.lat.png\"><img src=\""$subj".rh.lat.png\" width=\"100%\" ></a></td>"	>> QC_external.html
    echo "<td><a href=\"file:"$subj".rh.med.png\"><img src=\""$subj".rh.med.png\" width=\"100%\" ></a></td>"	>> QC_external.html
    echo "</tr>" >> QC_external.html  

    echo "</table>" >> QC_external.html 
done;
echo "</body>" >> QC_external.html
echo "</html>" >> QC_external.html