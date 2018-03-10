import json
import os

# runing on Unix, with the $HOME env variable set and cloned repository
path_to_json = "/Desktop/GIT/HTTP-Status-Code-CLI/status.json"
status_file = ""
try:
	with open(os.environ['HOME'] + path_to_json, "r") as status_content :
		status_file = json.load(status_content)	
except KeyError:
	print('No home directory found')
except IOError:
	print('File does not exist')
