import json
import os
import argparse

# runing on Unix, with the $HOME env variable set and cloned repository
path_to_json = "/Desktop/GIT/HTTP-Status-Code-CLI/status.json"
status_file = None
parser = None
args = None

def load_json():
	try:
		with open(os.environ['HOME'] + path_to_json, "r") as f :
			status_file = json.load(f)
	except KeyError:
		print('No home directory found')
	except IOError:
		print('File does not exist')

	return status_file is not None	

def process_args(args):
	pass

if __name__ == '__main__':
	if load_json():
		# BY DEFAULT, DISPLAYS ALL THE CODES AND CATEGORY DESCRIPTION PYPING THEM TO A LESS-LIKE SCROLLING
		parser = argparse.ArgumentParser(description =
				 'Description: Display the description of HTTP status codes.')
		parser.add_argument('-c','--code', help="the 3 digit http status code to be described.", action='store_true')
		parser.add_argument('-d','--desc', help="returns code(s)  matching the description", action='store_true')
		parser.add_argument('-t','--type', help="returns code(s) and description of one category", action='store_true')
		parser.add_argument('-g','--cat' , help="returns the categories and their descriptions", action='store_true')

		args = parser.parse_args()
		process_args(args)
	else:
		# json file was not loaded
		exit(1)
