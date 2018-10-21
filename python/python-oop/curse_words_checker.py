import urllib.request
import sys

def curse_words_checker(file_name):
	try:
		with open(file_name, 'r') as f:
			content = f.read()
			curse_check = 'http://www.wdylike.appspot.com/?'+\
			urllib.parse.urlencode([('q', content)])
			response =urllib.request.urlopen(curse_check)
			
			if b'true' in response.read():
				print('Curse word found!')
			else:
				print('All clean!')
			response.close()
			
	except IOError:
		print(f"Unable to open '{file_name}'. File not found or permision denied.")

if __name__=='__main__':
	if len(sys.argv) == 2:
		file_name = sys.argv[1]
		curse_words_checker(sys.argv[1])
	else:
		print(f'usage {sys.argv[0]} file_to_check_for_curse_words')
