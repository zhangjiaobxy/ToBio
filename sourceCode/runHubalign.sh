#!/bin/bash

#############################################################
# extract labels by using hubalign
#############################################################

cp HubAlign ./../data/rawData/
cp runHubalign.py ./../data/rawData/
mkdir -p ./../data/hubLabel/
cp hubalignEC.py ./../data/hubLabel/
cp hubalignLCCS.py ./../data/hubLabel/
cp hubalignFC.py ./../data/hubLabel/
cd ./../data/rawData/
# run hubalign to get raw label files, $1: dbStart, $2: dbEnd, $3: queryStart, $4: queryEnd
python runHubalign.py $2 $3 $4 $5 >> outputHub  
rm HubAlign
rm runHubalign.py
rm outputHub
mv *.eval ./../hubLabel/
mv *.alignment ./../hubLabel/
cp goa.b ./../hubLabel/
cd ./../hubLabel/
if [ "$1" == "m4" ]; then
    python hubalignEC.py $2 $3 # get label netal ec
elif [ "$1" == "m5" ]; then	
    python hubalignLCCS.py $2 $3 # get label netal lccs
elif [ "$1" == "m6" ]; then
    python hubalignFC.py $2 $3 # get label netal fc
fi
rm hubalignEC.py
rm hubalignLCCS.py
rm hubalignFC.py
rm goa.b
