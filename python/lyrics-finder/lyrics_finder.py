import re
import urllib.request
from bs4 import BeautifulSoup
import sys

def get_lyrics(song_title,artist):
	# remove all except alphanumeric characters from artist and song_title
	artist = re.sub('([^A-Za-z0-9]+|^the)', '', artist.lower())
	song_title = re.sub('[^A-Za-z0-9]+', '', song_title.lower())
	url = 'https://azlyrics.com/lyrics/'+artist+'/'+song_title+'.html'
	try:
		response = urllib.request.urlopen(url).read()
		soup = BeautifulSoup(response, 'html.parser')
		lyrics = str(soup)
		# lyrics lies between up_partition and down_partition
		up_partition = '<!-- Usage of azlyrics.com content by any third-party lyrics provider is prohibited by our licensing agreement. Sorry about that. -->'
		down_partition = '<!-- MxM banner -->'
		lyrics = lyrics.split(up_partition)[1].split(down_partition)[0]
		# remove html tags
		lyrics = re.sub('<\s*\w[^>]*>|</\w*>','', lyrics)
		return lyrics
	
	except Exception as e:
		return 'The following error occurred\n' + url + '\n'+str(e)

if __name__ == '__main__':
	args = []
	if len(sys.argv) == 3:
		args = sys.argv[1:]
	else:
		args = ''.join(sys.argv[1:]).split('-')
	assert len(args) == 2 , 'Error:invalid arguments:\nExpected: song tite - artist name\nReceived: '+ ' '.join(sys.argv[1:])

	print(args[0].title(),' -', args[1].title())
	print(get_lyrics(*args))
	
