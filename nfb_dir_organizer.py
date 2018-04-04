#!/usr/bin/python

import sys
import glob
import re
import os
import shutil

#Grab file path
raw_path=sys.argv[1]

#Is the task sonsira 1 or 2?
task_version = raw_path[-1]

#Grab directories in this century
listing = sorted(glob.glob(raw_path + '/raw/2*/*'))
for sub_dir in listing:
	
	#Grab the subjects id number -- should be at end of string
	subj_id=re.search(r'\d+$',sub_dir)
	subj_id=subj_id.group()
	
	#Make sure every id is in the same format
	while (len(subj_id) < 3):
		subj_id = '0' + subj_id
	
	#Determine the correct prefix
	if task_version=='1':
		prefix='SON1_'
	elif task_version=='2':
		prefix='SON2_'
	else:
		raise Exception('Did not properly grab the correct task version (i.e. sonsira1 or sonsira2)')
	
	
	#Determine what to call new directory
	if os.path.exists(raw_path+'/raw/'+ prefix+subj_id+'_a'):
		new_dir = prefix+subj_id+'_b'
	else:
		new_dir = prefix+subj_id+'_a'
	
	#set new data_path
	new_path = raw_path+'/raw/'+new_dir
	
	#make new dir	
	#os.mkdir(raw_path+'/raw/'+new_dir)
	
	#Move contents from old dir to new dir
	print "moving %s to %s" % (sub_dir,new_path)
	shutil.copytree(sub_dir,new_path)	
	
	#Remove old directory
	print "removing %s..." % (sub_dir)
	shutil.rmtree(os.path.dirname(sub_dir),ignore_errors=True)
	
#Filter mprage dir here -- this should be outside the loop or a sperate process as we don't want to resort the data every bloody time
#If the number of mp rage dirs is > 1

listing = sorted(glob.glob(raw_path + '/raw/SON*'))
#mprage_dirs=sorted(glob.glob(new_path + '*MPRAGE*'))
for sub_dir in listing:
	if not os.path.exists(sub_dir + '/mprg_stash'):
		os.mkdir(sub_dir + '/mprg_stash')
	
	#If mprage dir already exists skip	
	if not os.path.exists(sub_dir + '/mprage'):
		mprage_dirs=glob.glob(sub_dir + '/MPRAGE*')
		mprage_dirs.pop()
		if len(mprage_dirs)>=1:
			for i in range(len(mprage_dirs)):
				shutil.move(mprage_dirs[i], sub_dir + '/mprg_stash')
	#mprage_dirs=sorted(glob.glob(sub_dir + '/MPRAGE*')
	#mprage_dirs=sorted(glob.glob(sub_dir + '*MPRAGE*')
