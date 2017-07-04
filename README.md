ToBio 1.0 executable binary - Linux version
------------------------

ToBio 1.0 is implemented in Python.

This tool performs global pathway similarity search based on Topological and Biological features.

This package includes ToBio executable binary programs and related program scripts and for the following paper:

ToBio: global pathway similarity search based on Topological and Biological features


CONTAINS:
------------------------

* ToBio : ToBio executable binary

* sourceCode : a folder contains ToBio related Python, shell scripts and binaries. It has following files :

	* formatMfinder.py : Python script to convert network file to the file format that can be run in mfinder

	* runMfinder.py : Python script to run mfinder and get subgaph raw data
	
	* featureExtract.py : Python script to extract subgraph features
	
	* mfinder : mfinder executable binary
	
	* runNetal.sh : shell scripts to run NETAL
	
	* runNetal.py : Python script to run NETAL and get label raw data
	
	* netalEC.py : Python script to extract NETAL EC label
	
	* netalLCCS.py : Python script to extract NETAL LCCS label

	* netalFC.py : Python script to extract NETAL FC label
	
	* NETAL : NETAL executable binary
	
	* runHubalign.sh : shell script to run HubAlign
	
	* runHubalign.py : Python script to run HubAlign and get label raw data
	
	* hubalignEC.py : Python script to extract HubAlign EC label
	
	* hubalignLCCS.py : Python script to extract HubAlign LCCS label

	* hubalignFC.py : Python script to extract HubAlign FC label
	
	* HubAlign : HubAlign executable binary
	
	* csvFeatureLabel.py : Python script to generate a csv file, which contains final feature and label
	
	* rfRegression.py : Python script to call random forest regression, train the model and perform network query
	
	* postProcess.py : Python script of the post-processing pipeline

	* ToBio.sh : shell script to generate the ToBio executable binary

* data : this folder stores all the data related to ToBio. It has following files :

	* rawData : it stores the input files of ToBio. It has network txt files, blast.b (blast score), go.b (go score), goa.b (the GOA file), simNetTop20%.csv (an example of the input file of the post-processing pipeline), which are existed in the initial stage
	
	* mfinderFeature : it stores input network files that can be run in mfinder, the output subgraph files of mfinder, and raw subgraph features, which are created in the program execution stage
	
	* netalLabel : it stores output files of NETAL and raw labels, which are created in the program execution stage

	* hubLabel : it stores output files of HubAlign and raw labels, which are created in the program execution stage
	
	* csvFeatureLabel : it stores final feature label csv file, which is created in the program execution stage
	
	* topkOutput : it stores top k percent similar networks, which is created in the program execution stage

	* pipelineOutput : it stores the output result of the post-processing pipeline

* LICENSE : MIT License

* README.md : this file


PREREQUISITE
------------------------

ToBio was tested by using Python 2.7.6 version on Ubuntu 14.04 LTS. Following Python packages should be installed:

* scipy

* numpy

* pandas

* scikit-learn


HOW TO USE
------------------------

* Help info :

	$ ./ToBio [-h]

	======================================================================

	* [-h] :            print help info of ToBio

	* ToBio Usage :     ./ToBio [OPTION] [SUBGRAPH_SIZE] [BIO_FEATURE] [LABEL] [TOP_K_PERCENT] [DB_START] [DB_END] [QUERY_START] [QUERY_END]
	
	* Example :         ./ToBio -t 2 b1 m1 20 1 100 101 120
	
	* [OPTION] :        -t (-t means choose ToBio approach)
	
	* [SUBGRAPH_SIZE] : 2, 3, 4 or 234 (234 indicates that feature is the combination of subgraph size 2, 3 and 4)
	
	* [BIO_FEATURE] :   b1, b2, or b3 (b1: BLAST, b2: GO, b3: BLAST and GO)
	
	* [LABEL] :         m1, m2, m3, m4, m5 or m6 (m1: NETAL EC, m2: NETAL LCCS, m3: NETAL EC, m4: HubAlign EC, m5: HubAlign LCCS, m6: HubAlign FC)
	
	* [TOP_K_PERCENT] : top k percent similar networks
	
	* [DB_START] :      integer number, it should be the smallest file name in the database
	
	* [DB_END] :        integer number, it should be the largest file name in the database
	
	* [QUERY_START] :   integer number, it should be the smallest file name in the query network set
	
	* [QUERY_END] :     integer number, it should be the largest file name in the query network set
	
	* ======================================================================
	
	* Pipeline Usage :  ./ToBio [OPTION] [INPUT_FILE] [BIO_FEATURE] [REAL_PERCENT] [INC_PERCENT]
	
	* Example :         ./ToBio -p inputNet20%.csv b1 10 20
	
	* [OPTION] :        -p (-p means choose the post-processing pipeline of ToBio approach)
	
	* [INPUT_FILE] :    the input file to be processed
	
	* [BIO_FEATURE] :   b1, or b2 (b1: BLAST, b2: GO)
	
	* [REAL_PERCENT] :  the real topk percent we want
	
	* [INC_PERCENT] :   topk percent used to improve the performance
	
	* ======================================================================

* Command line:

	* ToBio Usage :

	* $ ./ToBio [OPTION] [SUBGRAPH_SIZE] [BIO_FEATURE] [LABEL] [TOP_K_PERCENT] [DB_START] [DB_END] [QUERY_START] [QUERY_END]

	* Pipeline Usage :

	* ./ToBio [OPTION] [INPUT_FILE] [BIO_FEATURE] [REAL_PERCENT] [INC_PERCENT]
 
* Example:

	* $ cd /ToBio/
	
	* $ chmod +x ToBio

	* $ ./ToBio -t 2 b1 m1 20 1 100 101 120 

	* $ ./ToBio -p inputNet20%.csv b1 10 20


FILE NAMING RULE
------------------------

* Input network file is named in the txt file format. File name is an interger number. File name in the database should not have any interaction with the query set file name.

* For example, if there are 100 networks in the database and 20 query networks in the query set. Therefore, file names in the database should start from 1.txt to 100.txt. File names in the query set should start from 101.txt to 120.txt.


FILE FORMAT OF ToBio
------------------------

* Input network of ToBio is in the txt file format, which has the following format: 

 Each line corresponds to an interaction and contains the name of two nodes and the edge weight of the corresponding interaction (separated by a tab). Each node is a symbol of geneProduct, and we set all the weight of the edge to 1.

 Here is an example for network "1.txt" :

	Ephb2	Kmt2e	1

	Ephb2	Cntf	1

	Kmt2e	Cntf	1

	Cntf	Pten	1

	Ephb2	Pten	1

* Output file of ToBio is in the csv file format, which has the following format: 

 The output file returns top K similar networks against each query network. Each line contains the name of the query network, the name of similar netowrk in the database, label for regression and prediction of the similarity score (separated by a tab).

 Here is an example for the output file "simNetTop20%.csv" by using EC as label:

	q_name,db_name,label,predictions

	101,7,0.7,0.8

	101,79,0.9,0.9

	101,62,0.7,0.8

	101,35,0.4,0.6

	101,36,0.6,0.5


FILE FORMAT OF PIPELINE
------------------------

* Input file of the pipeline is in the csv file format, which has the same format with the output file of ToBio. It can be only has the q_name and db_name columns.

 Here is an example for the input file format of the pipeline "inputNet20%.csv" :

	q_name,db_name

	101,7

	101,79

	101,62

	101,35

	101,36

* Output file of the pipeline is in a csv file format, which has the same file format as the input file. The difference is that, if we want to get the top 10% similar network, we can input top 20% similar network.


FUNDING SUPPORT
------------------------
* We would like to thank Amazon Web Service (AWS) for providing cloud credits for the software development.


------------------------
Jiao Zhang

jiaozhang9-c@my.cityu.edu.hk

March 9 2017

