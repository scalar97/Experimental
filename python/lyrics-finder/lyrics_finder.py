import re
import sys
import urllib.request
import urllib.parse
from bs4 import BeautifulSoup,SoupStrainer

def get_lyrics(url):
	try:
		response = urllib.request.urlopen(url).read()
		soup = BeautifulSoup(response, 'html.parser')
		l = str(soup)
		# lyrics lies between 'l_start' and '<!-- MxM banner -->'
		l_start = '<!-- Usage of azlyrics.com content by any third-party lyrics provider is prohibited by our licensing agreement. Sorry about that. -->'
		start = l.find(l_start,4096, len(l)) # Move away 4096 bytes as lyrics start far down the page aroud 6000+ bytes on average.
		end = l.find('<!-- MxM banner -->', start+len(l_start))
		if start > 0 and end > 0:
			lyrics = '\n' + soup.title.string.split('Lyrics', 1)[0] + '\n' + l[start + len(l_start):end]
			return BeautifulSoup(lyrics, 'html.parser').get_text()
		return 'No results found.'
	except:
		raise

if __name__ == '__main__':
	try:
		if len(sys.argv) < 2:
			print('Usage: '+ sys.argv[0]+' followed by song title', file= sys.stderr)
		else:
			# getting the first 7 links from DuckDuckGo search engine
			res = urllib.request.urlopen('https://duckduckgo.com/html/?q='+'+'.join(sys.argv[1:])+'+lyrics').read()
			soup = BeautifulSoup(res,'html.parser', parse_only=SoupStrainer('a',{'class': 'result__snippet'}))
			results = soup.find_all('a', limit=7)
			url = None
			for tag in results:
				parsed = urllib.parse.urlparse(tag['href'])
				url = urllib.parse.parse_qs(parsed.query)['uddg'][0]
				if url.startswith('https://www.azlyrics.com'):
					break
			if url:
				print(get_lyrics(url))
			else:
				print('Sorry, No fast results found!\n', file=sys.stderr)
	except:
		raise
