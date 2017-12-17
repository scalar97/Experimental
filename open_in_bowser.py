import webbrowser
import time
import sys 

# the webbrowser module has the open function that will open a given url
# the sleep function from the time module will be used to delay the loop
# the argv function from the sys module will be used to take the amount 
# to take the specified url, the time intervals in secs,and the frequency

if len(sys.argv) == 4:
	this_much_time = int(sys.argv[2])
	every_this_much_time_in_sec = int(sys.argv[3])
	url = sys.argv[1]
	for i in range(this_much_time):
		webbrowser.open(url)
		time.sleep(every_this_much_time_in_sec)
else:
	print(f'Usage:{sys.argv[0]} open_this_url  this_much_time   every_this_much_time_in_sec')
	
# example argument: python open_in_bowser.py https://google.com 2 10
