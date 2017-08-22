#!/bin/bash

#############################################################
# extract labels by using magna
#############################################################

python formatMagna.py
cp magnapp ./../data/magnaLabel/
cp runMagna.py ./../data/magnaLabel/
cp magnaS3.py ./../data/magnaLabel/
cd ./../data/magnaLabel/
# run magna to get raw label files, $1: dbStart, $2: dbEnd, $3: queryStart, $4: queryEnd
python runMagna.py $2 $3 $4 $5 >> outputMagna
if [ "$1" == "m8" ]; then
    python magnaS3.py $2 $3 # get label magna s3
fi
rm magnapp
rm runMagna.py
rm magnaS3.py
rm outputMagna
rm *.gw
rm *.gw_final_visualize.sif
rm *.gw_final_stats.txt
rm *.gw_final_alignment.txt
