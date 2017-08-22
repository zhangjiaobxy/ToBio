#!/usr/bin/env python
# -*- coding: utf-8 -*-

# *********************************************************************
# run magna to get raw label files
# *********************************************************************

# import the modules needed to run the script
import os, sys, subprocess

file_list = os.listdir('.')

# db range
dbStart = int(sys.argv[1])
dbEnd = int(sys.argv[2]) 
# query range
queryStart = int(sys.argv[3])
queryEnd = int(sys.argv[4])

# number of parrallel subprocess 
thread_num = 8
thread_list = []

# cmd_temp = "./magnapp -G ex1.gw -H ex2.gw -o test_run -m S3 -p 10 -n 10"
cmd_temp = "./magnapp -G [FILENAME_2] -H [FILENAME_1] -o [FILENAME_3] -m S3 -p 10 -n 10"

file_list_1 = []    # db network file list
file_list_2 = []    # query network file list
for e_file in file_list:
    if e_file.endswith('.gw'):
        if dbStart <= float(e_file.replace('.gw','')) <= dbEnd:
	        file_list_1.append(e_file)
        elif queryStart <= float(e_file.replace('.gw','')) <= queryEnd:
            file_list_2.append(e_file)

if len(thread_list) < thread_num:
    for e_file_2 in file_list_2:
        fi_2 = open(e_file_2, 'r')
        lineNode_2 = int(fi_2.readlines()[4])
        for e_file_1 in file_list_1:
            fi_1 = open(e_file_1, 'r')
            lineNode_1 = int(fi_1.readlines()[4])
            if lineNode_2 <= lineNode_1:  # the nodes of the first network must be less than or equal to the nodes of the second network
                cmd = cmd_temp.replace("[FILENAME_2]", e_file_2).replace("[FILENAME_1]", e_file_1).replace("[FILENAME_3]", e_file_2+'-'+e_file_1)
            else:
                cmd = cmd_temp.replace("[FILENAME_2]", e_file_1).replace("[FILENAME_1]", e_file_2).replace("[FILENAME_3]", e_file_2+'-'+e_file_1)
            thread = subprocess.Popen(cmd, shell=True)
            thread_list.append(thread)
else:
    for thread in thread_list:
        thread.poll()
        if thread.returncode != None:
            thread_list.remove(thread)
            break

for thread in thread_list:
    thread.communicate()
