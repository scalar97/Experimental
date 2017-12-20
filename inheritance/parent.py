class Parent(object):
	def __init__(self,last_name, eye_color):
		print('Parent constructor called')
		self.last_name = last_name
		self.eye_color = eye_color

	def show_info(self):
		return f'{self.last_name} has {self.eye_color} eyes.'
		

class Child(Parent):
	def __init__(self,last_name, eye_color, number_of_toys):
		print('Child constructor called')
		super().__init__(last_name, eye_color)
		self.number_of_toys = number_of_toys

	def show_info(self):
		return super().show_info()[:-1]+ f' and owns {self.number_of_toys} toys.'

catty_billy = Parent('Billy', 'gray')
pat_billy = Child('Billy','brown',10)

print(catty_billy.show_info())
print(pat_billy.show_info())


''' +SCRIPT OUTPUT

	Parent constructor called
	Child constructor called
	Parent constructor called
	Billy has gray eyes.
	Billy has brown eyes and owns 10 toys.

'''	
