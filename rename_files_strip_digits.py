# in the folder ../file00s are files starting with one or more digits
# this program will strip all the digits starting a file name if any.

import os
from collections import deque

# version 1
def strip_integers_rename(file_list,abspath):
	"""Strips off the trailling integers at the start of a filename"""
	temp = []
	
	for i in range(len(file_list)):
		# if it is an integer its ascii value should be between [48 and 57] included
		if ord(file_list[i][0]) >= 48 and ord(file_list[i][0]) <= 57:
			temp = deque(file_list[i])
			while ord(temp[0]) >= 48 and ord(temp[0]) <= 57:
				del temp[0]
			# os.rename renames the second argument to the name of the first
			# os.path.join() will recreate the full path by joining its second
			# argument to its first.
			os.rename(os.path.join(abspath,file_list[i]),
					  os.path.join(abspath,''.join(temp)))


if __name__=='__main__':
	import sys
	
	if len(sys.argv) == 2:
		dir_path = sys.argv[1]
		strip_integers_rename(os.listdir(dir_path), dir_path)	
