class Parent(object):
	def __init__(self,last_name, eye_color):
		print('Parent constructor called')
		self.last_name = last_name
		self.eye_color = eye_color
		
catty_billy = Parent('Billy', 'gray')

class Child(Parent):
	def __init__(self,last_name, eye_color, number_of_toys):
		print('Child constructor called')
		super().__init__(last_name, eye_color)
		self.number_of_toys = number_of_toys

pat_billy = Child('Billy','blue',10)

	
	









