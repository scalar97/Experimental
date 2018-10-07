import urllib.request
import json
import dateutil.parser
import requests

class Partener(object):
	country = ""
	attendee_count = 0
	attendees = set()
	start_date = ""

	# get the suitable date for each country
	# the best way would be to use a heap but I will use a dictionary as time is short
	def getDate(self):
		favour = dict()
		for a in self.attendees:
			dates = a['availableDates']
			for i in range(len(dates) - 1):
				curr_date = dateutil.parser.parse(dates[i])
				next_date = dateutil.parser.parse(dates[i+1])
				delta = next_date - curr_date

				# only add successive days; don't compute values we don't need
				if delta.days == 1 :
					if favour.get(dates[i]):
						favour[dates[i]] += 1
					else:
						favour[dates[i]] = 1

		tempFilter = list((k, favour[k]) for k in sorted(favour, key=favour.get, reverse=True))
		if len(tempFilter) > 0:
			self.start_date = tempFilter[0]
		# else : none value for start_date will be encoded to null by json

if __name__ == '__main__':
	# get the list of parteners
	weburl = urllib.request.urlopen('get_url_goes_here')
	data = weburl.read()
	encoding = weburl.info().get_content_charset('utf-8')
	json_data = json.loads(data.decode(encoding))

	parteners = json_data['parteners']

	# create a dictionary of countries
	countries = dict()
	for item in parteners :
		c = item['country']
		# create a new entry for new country
		if not countries.get(c):
			p = Partener()
			p.country = c
			countries[c] = p
		# update the country data whether existant or newly created country
		countries[c].attendee_count += 1
		countries[c].attendees.add(item['email'])

	for aPartener in countries:
		# now get varourable dates for each all partener
		aPartener.getDate()

	# send the favourable date back as post
	resolved = json.dumps(countries).encode('utf8')
	requests.post("post_url_goes_here", json=resolved)
