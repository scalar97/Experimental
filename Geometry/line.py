# Author : Tatiana Zihindula

class Line(object):
	'''Line class'''
	def __init__(self, *coordinates):
		'''unpacks the four *coordinates given to construct a line'''
		self.x0, self.y0 = coordinates[0], coordinates[1]
		self.x1, self.y1 = coordinates[2], coordinates[3]

	def distance(self):
		'''returns the distance between the two points making up the line'''
		return  abs((((self.x1-self.x0)**2)+(self.y1-self.y0)**2)**0.5)

	def middle(self):
		'''returns the middle coordinates of the line as a tuple'''
		return (self.x0 + self.x1)/2 , (self.y0 + self.y1)/2

	def slope(self):
		'''returns the slope a.k.a the steepness of the line'''
		vertical_steepness = (self.y1 - self.y0)
		horizontal_steepness = (self.x1 - self.x0)
		if vertical_steepness == 0:
			return 0 # horizontal line cos ^ = 180 degrees
		elif horizontal_steepness == 0:
			return 1 # vertical line sin ^ = 90 degree
		else:
			return  vertical_steepness / horizontal_steepness

	def is_parallel(self, other_line):
		'''returns True if both lines have the same slope'''
		return self.slope() == other_line.slope()

	def is_perpendicular(self, other_line):
		'''returns True if the product of their slopes is -1'''
		return (self.slope() * other_line.slope()) == -1

	def is_vertical(self):
		''''returns true if this line has the slope of 1'''
		return self.slope() == 1

	def is_horizontal(self):
		'''returns True if this line has the slope of 0'''
		return self.slope() == 0
