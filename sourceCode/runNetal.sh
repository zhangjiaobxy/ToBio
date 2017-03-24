#!/bin/bash

#############################################################
# extract labels by using netal
#############################################################

cp NETAL ./../data/rawData/
cp runNetal.py ./../data/rawData/
mkdir -p ./../data/netalLabel/
cp netalEC.py ./../data/netalLabel/
cp netalLCCS.py ./../data/netalLabel/
cp netalFC.py ./../data/netalLabel/
cd ./../data/rawData/
# run netal to get raw label files, $1: dbStart, $2: dbEnd, $3: queryStart, $4: queryEnd
python runNetal.py $2 $3 $4 $5 >> outputNetal  
rm NETAL
rm runNetal.py
rm outputNetal
rm alignmentDetails.txt
rm simLog.txt
mv *.eval ./../netalLabel/
mv *.alignment ./../netalLabel/
cp goa.b ./../netalLabel/
cd ./../netalLabel/
if [ "$1" == "m1" ]; then
    python netalEC.py $2 $3 # get label netal ec
elif [ "$1" == "m2" ]; then	
    python netalLCCS.py $2 $3 # get label netal lccs
elif [ "$1" == "m3" ]; then
    python netalFC.py $2 $3 # get label netal fc
fi
rm netalEC.py
rm netalLCCS.py
rm netalFC.py
rm goa.b
