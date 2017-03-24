#!/usr/bin/env python
# -*- coding: utf-8 -*-

# *********************************************************************
# convert network file to the file format that can be run in mfinder
# *********************************************************************

# input: 
# 		1.txt (each node is the geneProduct symbol)
# output: 
# 		1.txt (each node is the index of the corresponding geneProduct)

# import the modules needed to run the script
import os

inputDir = './../data/rawData/'  # raw data root dir
outputDir = './../data/mfinderFeature/'

# create mfinder feature folder
if not os.path.exists(outputDir):  
    os.makedirs(outputDir)

filelist = os.listdir(inputDir)

for file in filelist:
	if file.endswith('.txt'):
		f = open(inputDir + file, 'r')
		fOut = open(outputDir + file, 'w')
		nodes = set()  # all the nodes of the network
		l_s = set()  # all edges
		ls = f.readlines()
		for l in ls:
			node1 = l.strip().split('\t')[0]
			node2 = l.strip().split('\t')[1]
			nodes.add(node1)
			nodes.add(node2)
			l_s.add(l)
		nodes = list(nodes)
		lenNodes = len(nodes)
		for l in l_s:
			node1 = l.strip().split('\t')[0]
			index1 = nodes.index(node1)
			node2 = l.strip().split('\t')[1]
			index2 = nodes.index(node2)
			fOut.write(str(index1+1) + '\t' + str(index2+1) + '\t' +str(1) +'\n')
		f.close()
		fOut.close()
print 'Done.'









