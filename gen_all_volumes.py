#!/usr/bin/python
'''This will hopefully solve the issue of constantly logging into thorndike for 
volume lenbgths, just run  this at the start of preprocessing the data,
sync it somethere and you'll have a lookup table to pull the volume lengths from
'''

import sys
import os
import argparse

#First supply the path to the proc data
#Then supply the name of the sub dir or task
#Then supply the expected nuber of runs
'''
for each subject in arg1 dir
	get id that is the key value
	go into task dir and try to do wc -l on motion file
	if returned number 
		key = [].append(number)
	else on fail
		key = [].append(NA)
	
write dictionary to csv
''' 


#Parser out command line arguments
parser = argparse.ArgumentParser(description='Parse out the args for grabbing number of volumes per task.')
parser.add_argument('--proc_path', dest='proc_path',type=str, default='',
                    help='Enter the full path to the processed fMRI data')
parser.add_argument('--task_dir', dest='task_dir',type=str, default='',
                    help='Enter the name of the task')
parser.add_argument('--n_runs', dest='runs',type=int , default=0,
                    help='Enter the number of expected runs')

args = parser.parse_args()
proc_path = args.proc_path
task_dir = args.task_dir
runs = args.runs

#For now lets just loop over the tasks
proc_dir_list=os.listdir(proc_path)

for proc_dir in proc_dir_list:
	
	


