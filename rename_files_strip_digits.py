# in the folder ../file00s are files starting with one or more digits
# this program will strip all the digits starting a file name if any.

import os
from collections import deque

# version 1
def strip_integers_rename(file_list,abspath):
	"""Strips off the trailling integers at the start of a filename"""
	temp = []
	
	for file in file_list:
		# if it is an integer its ascii value should be between [48 and 57] included
		if file[0].isdigit():
			temp = deque(file)
			while temp[0].isdigit():
				temp.popleft()
			# os.rename renames the second argument to the name of the first
			# os.path.join() will recreate the full path by joining its second
			# argument to its first.
			os.rename(os.path.join(abspath,file),
				  os.path.join(abspath,''.join(temp)))


def strip_integers_rename2(file_list,abspath):
	# change to the current working directory to the files absolute path
	os.chdir(abspath) 
	for file in file_list:
		if file[0].isdigit():
			os.rename(file, file.lstrip('0123456789')) #if current dir is was changed
			
			#os.rename(os.path.join(abspath,file),
			#	  os.path.join(abspath,''.join(temp)))
	
	

	
if __name__=='__main__':
	import sys
	
	if len(sys.argv) == 2:
		dir_path = sys.argv[1]
		strip_integers_rename(os.listdir(dir_path), dir_path)	
