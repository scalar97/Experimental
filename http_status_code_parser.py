import json
import os
import argparse

# runing on Unix, with the $HOME env variable set and cloned repository
path_to_json = "/Desktop/GIT/HTTP-Status-Code-CLI/status.json"
status_file = None
try:
	with open(os.environ['HOME'] + path_to_json, "r") as f :
		status_file = json.load(f)	
except KeyError:
	print('No home directory found')
except IOError:
	print('File does not exist')

if __name__ == '__main__':
	if status_file:
		# BY DEFAULT, DISPLAYS ALL THE CODES AND THEIR MEANING PYPING THEM TO A LESS-LIKE SCROLLING
		parser = argparse.ArgumentParser(description =
										 'Description: Display the description of HTTP status codes.')
		parser.add_argument('-c','--code', help="the 3 digit http status code to be described.")
		parser.add_argument('-d','--desc', help="returns code(s)  matching the description")
		parser.add_argument('-t','--type', help="returns code(s) and description of one category")
		parser.add_argument('-g','--cat' , help="returns the categories and their descriptions")

		parser.parse_args()
	else:
		# help stuff go here
		pass
