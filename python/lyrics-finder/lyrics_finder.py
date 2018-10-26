import re
import sys
import requests
import urllib.request
import urllib.parse
from bs4 import BeautifulSoup

def print_error(err = '', usage = False):
	if usage:
		err = 'Usage: '+ sys.argv[0]+' followed by song title'
	else:
		err = 'The following error occured :\n' + err
	print(err,file= sys.stderr)
	exit(-1)

def get_lyrics(url):
	try:
		response = urllib.request.urlopen(url).read()
		soup = BeautifulSoup(response, 'html.parser')
		l = str(soup)
		# lyrics lies between up_partition and down_partition
		start = '<!-- Usage of azlyrics.com content by any third-party lyrics provider is prohibited by our licensing agreement. Sorry about that. -->'
		end = '<!-- MxM banner -->'
		lyrics = l[l.find(start)+len(start):l.rfind(end)]
		# remove html tags
		lyrics = re.sub('<\s*\w[^>]*>|</\w*>','', lyrics)
		return lyrics
	
	except Exception as e:
		err = url + '\n'+str(e)
		print_error(err = err)

if __name__ == '__main__':
	try:
		if len(sys.argv) < 2:
			print_error(usage=True)
		r = requests.get('https://duckduckgo.com/html/?q='+'+'.join(sys.argv[1:])+'+lyrics')
		soup = BeautifulSoup(r.text, 'html.parser')
		print('- ' + ' '.join(sys.argv[1:]))
		results = soup.find_all('a', attrs={'class':'result__a'}, href=True, limit=7)
		url = None
		for tag in results:
			parsed = urllib.parse.urlparse(tag['href'])
			link = urllib.parse.parse_qs(parsed.query)['uddg'][0]
			if link.startswith('https://www.azlyrics.com'):
				url = link
				break
		if url:	
			print(get_lyrics(url))
		else:
			print_error(err= 'No fast result found')
	except Exception as e:
		print_error(err= str(e))
