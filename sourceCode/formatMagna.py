# *********************************************************************
# convert network file to the file format that can be run in magna
# *********************************************************************

# input: 
# 		1.txt (each node is the numerical symbol)
# output: 
# 		1.gw (the input format of MAGNA)

# import the modules needed to run the script
import os

inputDir = './../data/mfinderFeature/'
outputDir = './../data/magnaLabel/'

if not os.path.exists(outputDir):
	os.makedirs(outputDir)

fl = os.listdir(inputDir)
for f in fl:
	if f.endswith('.txt') and not f.endswith('_OUT.txt'):
		fi = open(inputDir + f, 'r')
		fo = open(outputDir + f.strip().replace('.txt', '.gw'), 'w')
		ls = fi.readlines()
		nodeSet = set()
		edgeList = []
		for l in ls:
			sNode = l.strip().split('\t')[0]
			tNode = l.strip().split('\t')[1]
			edge = sNode + ' ' + tNode + ' ' + str(0) + ' |{}|' + '\n'
			nodeSet.add(sNode)
			nodeSet.add(tNode)
			edgeList.append(edge)
		fo.write('LEDA.GRAPH\n' + 'void\n' + 'void\n' + str(-2) + '\n')
		fo.write(str(len(nodeSet)) + '\n')
		for node in nodeSet:
			fo.write('|{' + node + '}|\n')
		fo.write(str(len(edgeList)) + '\n')
		for e_edge in edgeList:
			fo.write(e_edge)

# print 'Done.'