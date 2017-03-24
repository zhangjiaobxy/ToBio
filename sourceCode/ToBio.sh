#!/bin/bash
###############################################################################
###############################################################################
#                   ToBio method and its post-processing pipeline              
###############################################################################
###############################################################################
# Help info:
if [ "$1" == "-h" ] ; then
    echo "======================================================================"
    echo "[-h]:            print help info of ToBio"
    echo "ToBio Usage:     ./ToBio [OPTION] [SUBGRAPH_SIZE] [BIO_FEATURE] [LABEL] [TOP_K_PERCENT] [DB_START] [DB_END] [QUERY_START] [QUERY_END]"
    echo "Example:         ./ToBio -t 2 b1 m1 20 1 100 101 120"
    echo "[OPTION]:        -t (-t means choose ToBio approach)"
    echo "[SUBGRAPH_SIZE]: 2, 3, 4 or 234 (234 indicates that feature is the combination of subgraph size 2, 3 and 4)"
    echo "[BIO_FEATURE]:   b1, b2, or b3 (b1: BLAST, b2: GO, b3: BLAST and GO)"
    echo "[LABEL]:         m1, m2, m3, m4, m5 or m6 (m1: NETAL EC, m2: NETAL LCCS, m3: NETAL EC, m4: HubAlign EC, m5: HubAlign LCCS, m6: HubAlign FC)"
    echo "[TOP_K_PERCENT]: top k percent similar networks"
    echo "[DB_START]:      integer number, it should be the smallest file name in the database"
    echo "[DB_END]:        integer number, it should be the largest file name in the database"
    echo "[QUERY_START]:   integer number, it should be the smallest file name in the query network set"
    echo "[QUERY_END]:     integer number, it should be the largest file name in the query network set"    
    echo "======================================================================"
    echo "Pipeline Usage:  ./ToBio [OPTION] [INPUT_FILE] [BIO_FEATURE] [REAL_PERCENT] [INC_PERCENT]"
    echo "Example:         ./ToBio -p inputNet20%.csv b1 10 20"
    echo "[OPTION]:        -p (-p means choose the post-processing pipeline of ToBio approach)"
    echo "[INPUT_FILE]:    the input file to be processed"
    echo "[BIO_FEATURE]:   b1, or b2 (b1: BLAST, b2: GO)"
    echo "[REAL_PERCENT]:  the real topk percent we want"
    echo "[INC_PERCENT]:   topk percent used to improve the performance"   
    echo "======================================================================"
    exit 0
fi

###############################################################################
# ToBio steps: the script of ToBio approach
# step 1: convert network file to the file format that can be run in mfinder
# input: 
#            ./data/rawData/1.txt (each node is the geneProduct symbol)
# output: 
#            ./data/mfinderFeature/1.txt (each node is the index of the corresponding geneProduct)
# parameter: 
#            $1: -t (the option means to use the ToBio approach)

if [ "$1" == "-t" ] ; then
    cd ./sourceCode/  # go to sourceCode folder
    chmod +x *        # enable the executable authority for all the programs
    python formatMfinder.py  

###############################################################################
# step 2: run mfinder to get subgraph feature OUT files
# input:
#            ./data/rawData/
# output: 
#            ./data/mfinderFeature/*_subgraphSize_OUT.txt (mfinder output file)
# parameter: 
#            $2: subgraphSize (subgraphSize = 2, 3, 4 or 234)

    python runMfinder.py $2  # generate mfinder OUT files for raw feature
    # python runMfinder.py 2

###############################################################################
# step 3: featureExtract() function will extract subgraph features
# input: 
#            ./../data/mfinderFeature/*_OUT.txt
# output: 
#            ./../data/mfinderFeature/querySubgraphSize2.t (querySubgraphSize3.t, querySubgraphSize4.t)
#            ./../data/mfinderFeature/dbSubgraphSize2.t (dbSubgraphSize3.t, dbSubgraphSize4.t)
#            ./../data/mfinderFeature/querySubgraphSize2Feature.t (querySubgraphSize3Feature.t, querySubgraphSize4Feature.t)
#            ./../data/mfinderFeature/dbSubgraphSize2Feature.t (dbSubgraphSize3Feature.t, dbSubgraphSize4Feature.t)
#            ./../data/mfinderFeature/featureSize2.t  (featureSize3.t, featureSize4.t)
# parameter:
#            $2: subgraphSize (subgraphSize = 2, 3, 4 or 234)
#            $7: dbEnd: the end range of database, it is the dividing line of the database and query set 

    python featureExtract.py $2 $7 # generate subgraph feature, subgraph size can be 2, 3, 4 or 234
    # python featureExtract.py 2 100


###############################################################################
# step 4: run labelExtract to get label files
# input: 
#            ./data/rawData/*.txt
#            ./data/rawData/goa.b  (the GO term used to get the FC label)
# output: 
#            ./data/netalLabel (netal output file: *.eval files, netal_ec_label.txt, netal_lccs_label.txt, netal_fc_label.txt)
#            ./data/hubLabel (hubalign output file: *.eval files, hubalign_ec_label.txt, hubalign_lccs_label.txt, hubalign_fc_label.txt)
# parameter: 
#            $4: label (label = m1, m2, m3, m4, m5, m6)
#                      (m1: NETAL EC, m2: NETAL LCCS, m3: NETAL FC, m4: HubAlign EC, m5: HubAlign LCCS, m6: HubAlign FC)
#            $6: dbStart: the start range of database
#            $7: dbEnd: the end range of database
#            $8: queryStart: the start range of query networks
#            $9: queryEnd: the end range of query networks

    netal_ec="m1"
    netal_lccs="m2"
    netal_fc="m3"
    hub_ec="m4"
    hub_lccs="m5"
    hub_fc="m6"
    if [ "$4" == "$netal_ec" ] || [ "$4" == "$netal_lccs" ] || [ "$4" == "$netal_fc" ]; then
        bash runNetal.sh $4 $6 $7 $8 $9
        # bash runNetal.sh m1 1 100 101 120
    elif [ "$4" == "$hub_ec" ] || [ "$4" == "$hub_lccs" ] || [ "$4" == "$hub_fc" ]; then
        bash runHubalign.sh $4 $6 $7 $8 $9
        # bash runHubalign.sh m3 1 100 101 120
    else
        echo "*********************************************************************"
        echo
        echo "Invalid label, system exit!"
        echo
        echo "*********************************************************************"
        exit 0
    fi

###############################################################################
# step 5: get feature_lable csv file, it is the input csv file for random forest regression model
# input: 
#            ./../data/mfinderFeature/featureSize2.t  (featureSize3.t, featureSize2=4.t)
#            ./../data/rawData/blast.b  (blast score for each pair network)
#            ./../data/rawData/go.b  (go score for each pair network)
#            ./../data/netalLabel/netal_ec_label.txt  (netal_lccs_label.txt, netal_fc_label.txt, hubalign_ec_label.txt, hubalign_lccs_label.txt, hubalign_fc_label.txt)
# output: 
#            ./../data/csvFeatureLabel/featureSize2_BLAST_netal_ec_label.csv (featureSize2_GO_netal_ec_label.csv, featureSize2_BLAST_GO_netal_ec_label.csv)
# parameter: 
#            $2: subgraphSize (subgraphSize = 2, 3, 4 or 234)
#            $3: bio (bio = b1, b2, b3)
#            $4: label (label = m1, m2, m3, m4, m5, m6)
#                      (m1: NETAL EC, m2: NETAL LCCS, m3: NETAL FC, m4: HubAlign EC, m5: HubAlign LCCS, m6: HubAlign FC)

    python csvFeatureLabel.py $2 $3 $4  # generate final csvfile
    # python csvFeatureLabel.py 2 b1 m1

###############################################################################
# step 6: run random forest regression
# input: 
#            ./../data/csvFeatureLabel/featureSize2_BLAST_netal_ec_label.csv (featureSize2_GO_netal_ec_label.csv, featureSize2_BLAST_GO_netal_ec_label.csv)
# output: 
#            ./../data/output/topkNetwork.csv
# parameter: 
#            $2: subgraphSize (subgraphSize = 2, 3, 4 or 234)
#            $3: bio (bio = b1, b2, b3)
#            $4: label (label = m1, m2, m3, m4, m5, m6)
#                      (m1: NETAL EC, m2: NETAL LCCS, m3: NETAL FC, m4: HubAlign EC, m5: HubAlign LCCS, m6: HubAlign FC)
#            $5: topk (output top k percent similar networks)

    python rfRegression.py $2 $3 $4 $5  # train random forest model and perform query
    # python rfRegression.py 2 b1 m1 20
    exit 0
fi

###############################################################################
# pipeline step: 
#            a pipeline script of the post-processing stage of existing method
# input:
#            ./../data/rawData/inputNet20%.csv  (topK similar network)
#            ./../data/rawData/blast.b   (blast score)
#            or ./../data/rawData/go.b  (go score)
# output:
#            ./../data/postProcess/simNetTop10%_pipeline.csv  (topK similar network sorted by blast score or go score)
# parameter: 
#            $1: -p (the option means to use the pipeline script)
#            $2: input_file (the top similar networks file generated by existing method (inputNet20%.csv))
#            $3: bio (bio feature, b1: blast score, or b2: go score)
#            $4: realPer (the real topk percent we want)
#            $5: incPer (topk percent used to improve the performance)

if [ "$1" == "-p" ] ; then
    cd ./sourceCode/  # go to sourceCode folder
    chmod +x *        # enable the executable authority for all the programs
    python postProcess.py $2 $3 $4 $5
    # python postProcess.py inputNet20%.csv b1 10 20
    exit 0
fi

###############################################################################