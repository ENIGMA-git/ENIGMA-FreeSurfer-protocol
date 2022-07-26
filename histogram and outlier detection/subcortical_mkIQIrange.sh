#!/bin/bash

echo "Region,MNminus1.5IQI,MNplus1.5IQI" > IQI_range.csv
sed '1d' SummaryStats.txt | grep -v "Assym" | grep -v "Avg_"  | awk ' { print $1","$4-2.698*$5","$4+2.698*$5 } ' >> IQI_range.csv
N_regions=`more LandRvolumes.csv | head -n 1 | awk -F "," ' { print NF } '`
for (( c=2; c<=$N_regions; c++))
do roi=`more LandRvolumes.csv | head -n 1 | awk -F "," ' { print $'$c' } '`
IQI_low=`more IQI_range.csv | grep $roi | awk -F "," ' { print $2 }'`
IQI_high=`more IQI_range.csv | grep $roi | awk -F "," ' { print $3 }'`
IQI_low_int=`printf "%10.0f\n" $IQI_low`
IQI_high_int=`printf "%10.0f\n" $IQI_high`
echo "Looking for subjects with "$roi" volumes outside of "$IQI_low":"$IQI_high
cnt=1
for textline in `sed '1d' LandRvolumes.csv | awk -F "," ' { print $'$c' } '`
do cnt=`echo $cnt+1 | bc `
textline_int=`printf "%10.0f\n" $textline`
if [ $textline_int -gt $IQI_high_int ];
then sid=`more LandRvolumes.csv | head -n $cnt | tail -n 1 | awk -F "," ' { print $1 } '`
echo $sid" has a "$roi" of "$textline", this volume is high"
fi
if [ $textline_int -lt $IQI_low_int ];
then sid=`more LandRvolumes.csv | head -n $cnt | tail -n 1 | awk -F "," ' { print $1 } '`
echo $sid" has a "$roi" of "$textline", this volume is low"
fi
done
done
