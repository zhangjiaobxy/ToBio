#!/usr/bin/env python
# -*- coding: utf-8 -*-

# *********************************************************************
# this pipeline script is the post-processing stage of existing method
# *********************************************************************
# input:
# 		./../data/rawData/simNetTop20%.txt  (topK similar network)
# 		./../data/rawData/blast.b   (blast score)
# 		or ./../data/rawData/go.b  (go score)
# output:
# 		./../data/postProcess/simNetTop10%_blast.txt  (topK similar network sorted by blast score)
# 		or ./../data/postProcess/simNetTop10%_go.txt  (topK similar network sorted by go score)

from __future__ import division
import os,sys,math,time

oriResult = str(sys.argv[1])  # original result file (20%)
bio = str(sys.argv[2])  # biology feature file
realPer = int(sys.argv[3])  # 10%, real percent you want to get
incPer = int(sys.argv[4])  # 20%, increased percent that used to improve the final result

if bio == 'b1':
    print '\n*********************************************************************\n'
    print 'You have selected \''+bio+': BLAST score\' to post-process the result.\n'
    bioScore = 'blast.b'
elif bio == 'b2':
    print 'You have selected \''+bio+': GO score\' to post-process the result.\n'
    bioScore = 'go.b'
else:
    print 'Invalid biology feature, system exit!'
    print '\n*********************************************************************\n'
    raise SystemExit

if (0 < incPer <= 100) and (0 < realPer <= 100) and (incPer > realPer):
	print 'Real percent: ' + str(realPer) + '%\n'
	print 'Increased percent: ' + str(incPer) + '%'
else:
    print 'Invalid percent, system exit!'
    print '\n*********************************************************************\n'
    raise SystemExit

inputDir = './../data/rawData/'  # raw data root dir
outputDir = './../data/pipelineOutput/'

if not os.path.exists(outputDir):  
    os.makedirs(outputDir)

newResult = open(outputDir + 'simNetTop' + str(realPer)+'%_pipeline.csv', 'w')
newResult.write('q_name' + ',' + 'db_name' + '\n')

post_start = float(round(time.time() * 1000))  # millisecond

# bio feature
bioFile = open(inputDir + bioScore, 'r')
bio_ls = bioFile.readlines()[1:]

# result file
oriFile = open(inputDir + oriResult, 'r')
ori_ls = oriFile.readlines()[1:]
ori_qs = set()  # original query network name
ori_dbs = set()  # original db network name
ori_score = []  # original top percent networks
for ori_l in ori_ls:
	ori_l = ori_l.strip().split(',')
	ori_qs.add(float(ori_l[0]))
	for bio_l in bio_ls:
		bio_l_spl = bio_l.strip().split('\t')
		if (float(ori_l[0]) == float(bio_l_spl[0])) and (float(ori_l[1]) == float(bio_l_spl[1])):
			ori_score.append(bio_l)

dbSize = math.ceil((math.ceil(len(ori_score)/len(ori_qs)))/(incPer/100))  # database size
topk_net = int(math.ceil(dbSize * (realPer/100)))  # real percent you want

ori_qs = sorted(ori_qs)  # sort the query network name
q_size = len(ori_qs)  # the query network size
for ori_q in ori_qs:  # for each query network
	block = []
	for ori in ori_score:
		ori_spl = ori.strip().split('\t')
		if float(ori_q) == float(ori_spl[0]):
			block.append(ori)
	block = sorted(block, key=lambda x:float(x.strip().split('\t')[2]),reverse=True)[:topk_net]
	for e_line in block:
		e_line = e_line.strip().split('\t')
		newResult.write(e_line[0] + ',' + e_line[1] + '\n')

post_end = float(round(time.time() * 1000))  # millisecond
post_time = (post_end - post_start)/q_size  # post-processing time for each query network

print '\nThe post-processing time is: ' + str(post_time) + ' msec.'
print '\nThe post-processing result simNetTop' + str(realPer)+'%_pipeline.csv' + ' is generated.'
print '\n*********************************************************************\n'