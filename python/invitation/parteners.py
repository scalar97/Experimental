# Author : Tatiana Zihindula ~ 7/10/2018

import json
import dateutil.parser

class Partner(object):
	# class method to keep track of favourable dates
	def __init__(self):
		self.country = ""
		self.attendee_count = 0
		self.start_date = ""
		self.attendees = set()
		self.favour = dict()

	# the best way would be to use a heap as it will self sort in (O)log n
	# this would allow to merge update_date & set_startdate methods in 1 method.
	# but I will use a dictionary as time is short.
	def update_date(self, dates):
		for i in range(len(dates) - 1):
			curr_date = dateutil.parser.parse(dates[i])
			next_date = dateutil.parser.parse(dates[i+1])
			delta = next_date - curr_date

			# only add successive days; don't compute dates we won't use
			if delta.days == 1 :
				if dates[i] in self.favour:
					self.favour[dates[i]] += 1
				else:
					self.favour[dates[i]] = 1

	def set_startdate(self):
		tmp = [(k, self.favour[k]) for k in sorted(self.favour, key=self.favour.get, reverse=True)]
		if len(tmp) > 0:
			self.start_date = tmp[0][0]
		else :
			self.start_date = 'No favourable starting date'

	def __repr__(self):
		display = self.__dict__ ; display.pop('favour')	# ignore the favour dict
		return "\n\n%r" % (display)

if __name__ == '__main__':
	# get the list of partners
	with open('entries.json') as f:
		data = json.load(f)
		partners = data['partners']

		# create a dictionary entry for each country
		countries = dict()
		for item in partners:
			c = item['country']
			if not c in countries:
				# create a new entry for this new country
				p = Partner()
				p.country = c
				countries[c] = p
			# update the country data whether with existant or newly created country.
			countries[c].attendee_count += 1
			countries[c].attendees.add(item['email'])
			countries[c].update_date(item['availableDates'])

		for country in countries:
			# finally set favourable dates for Parterners from each country.
			countries[country].set_startdate()
			print(countries[country])
