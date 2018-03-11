import json
import os
import argparse

# runing on Unix, with the $HOME env variable set and cloned repository
path_to_json = "/Desktop/GIT/HTTP-Status-Code-CLI/status.json"
status = None
parser = None
group = None
args = None

def load_json():
	global status
	try:
		with open(os.environ['HOME'] + path_to_json, "r") as f :
			status = json.load(f)
	except KeyError:
		print('No home directory found')
	except IOError:
		print('File does not exist')
	return status is not None

def unpack_dict(a_dict, start_str=None, end="\n"):
	if start_str: print(start_str)
	for item in a_dict:
		if type(a_dict[item]) is dict:
			unpack_dict(a_dict[item], start_str = f'status code\t: {item}')
		else:
			# print the ley values of pairs
			print(f"{item}\t: {a_dict[item].replace('_',' ')}" )
	print(end=end)


def process_args(args):
	# TODO: use classes to encapsulate the type of status that can be there.
	if args.group:
		if args.number:
			category = status['type'].get(args.number[0] +'xx')
			if category:
				unpack_dict(category, start_str= f"status code\t: {args.number[0] +'xx'}")

elif args.desc:
			# find the item with a match in the string
			pass
		else:
			# display all the group info only
			unpack_dict(status['type'], start_str='CATEGORIES', end='')
	elif args.number:
		# a single code was given to display the description
		description = status["code"].get(args.number)
		description = "No result found" if description is None else description.replace('_',' ')
		print(f'Status Code <{args.number}> : {description}')

	else:
		unpack_dict(status, end="")

if __name__ == '__main__':
	if load_json():
		# BY DEFAULT, DISPLAYS ALL THE CODES AND CATEGORY DESCRIPTION PYPING THEM TO A LESS-LIKE SCROLLING
		parser = argparse.ArgumentParser(description =
				 'Description: Display the description of HTTP status codes.')
		group = parser.add_mutually_exclusive_group()
		# can only serach by number or by descriprion, not both
		group.add_argument('-n','--number', help="the 3 digit http status code to be described.", type=str, default="")
		group.add_argument('-d','--desc', help="returns code(s)  matching the description", type=str)
		# if option -g is present, the -n or -d will be applied to the group exclusively.
		# TODO: Status code belonging to a particular group should all be output as well.
		parser.add_argument('-g','--group' , help="returns the categories and their descriptions", action='store_true')

		args = parser.parse_args()
		process_args(args)
	else:
		# json file was not loaded
		exit(1)
