import webbrowser

class Movie(object):
	def __init__(self,title, **kwargs):
		self.title = title
		self.storyline = kwargs.get('storyline')
		self.image = kwargs.get('image')
		self.trailer = kwargs.get('trailer')
	
	def show_trailler(self):
		webbrowser.open(self.trailer)
