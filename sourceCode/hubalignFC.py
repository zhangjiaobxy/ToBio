#!/usr/bin/env python
# -*- coding: utf-8 -*-

# *********************************************************************
# extract hubalign fc label
# *********************************************************************

# input:
# 		*.alignment  (generated by HubAlign)
# 		goa.b  (Gene ontology annotation file)
# output:
# 		hubalign_fc_label.txt  (fc label file)

# import the modules needed to run the script
from __future__ import division
import os, sys
import numpy as np

# db range
dbStart = int(sys.argv[1])
dbEnd = int(sys.argv[2])  

file_name = 'hubalign_fc_label.txt'
f = open(file_name, 'w') # function coherence calculation

fileList = os.listdir('.')
f_n = []
for fileName in fileList:
	if fileName.endswith('.alignment'):
		if dbStart <= float(fileName.replace('.txt.alignment','').split('-')[-1]) <= dbEnd:
			f_n.append(fileName)
goFile = open('goa.b', 'r')

# handle file: 'goa.b'
ls = goFile.readlines()[1:]
goSet = set()
go_s = []
for l in ls:
	genePro = l.strip().split('\t')[0]
	goSet.add(genePro)
	go = l.strip().split('\t')[0] + '\t' + l.strip().split('\t')[1]
	go_s.append(go)

# handle file generated by NETAL: '*.alignment'
final_f = []
for file in f_n:
	f1 = open(file, 'r')
	l1s = f1.readlines()
	jacl = []
	for l1 in l1s:
		node1 = l1.strip().split(' -> ')[0]
		node2 = l1.strip().split(' -> ')[-1]
		go1_set = set()
		go2_set = set()
		for e_pair in go_s:
			e_pair_f = e_pair.strip().split('\t')[0]
			e_pair_s = e_pair.strip().split('\t')[-1]
			if node1 == e_pair_f:
				go1_set.add(e_pair_s)
			if node2 == e_pair_f:
				go2_set.add(e_pair_s)
		if len(go1_set | go2_set) == 0:
			jac = 0
		else:
			jac = float(len(go1_set & go2_set)/len(go1_set | go2_set))
		jacl.append(jac)
	avg_jacl = np.mean(jacl)

	file_name = file.strip().replace('.txt','').replace('.alignment','').split('-')
	file_name = file_name[0] + '\t' + file_name[-1]
	final_line = file_name + '\t' + str(avg_jacl)
	final_f.append(final_line)

final_f = sorted(final_f, key=lambda x:float(x.strip().split('\t')[1]))  # sorted by db column
final_f = sorted(final_f, key=lambda x:float(x.strip().split('\t')[0]))  # sorted by query column

for e in final_f:
	espl = e.strip().split('\t')
	f.write(espl[0]+ '.txt' + '\t' + espl[1] + '.txt' + '\t' + espl[2] + '\n')

print 'Done!'
