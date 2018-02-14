class MinimumEditDistance(Object):
	
	def __init__(self, string1, string2):
		self.string1 = string1
		self.string2 = string2
		self.row , self.col = len(string1)+1) , len(string2)+1)
		self.matrix = [[self.row] * self.col]
		
		# initialise the matrix
		for i in range(self.row): self.matrix[0][i] = i
		for j in range(self.col): self.matrix[j][0] = j
		
		
	def __get_min3(self):
		x, y, z = self.matrix[a-1][b], self.matrix[a][b-1], self.matrix[a-1][b-1]
					
		if x <= y and x<= z: min_ = x
		elif y <= z: min_ = y
		else: min_ = z
		
		return min_ + 1
		
		
	def set_element(self,value, row_index, col_index):
		self.matrix[row_index][col_index] = value
	
	def min_edit_distance(self):
		
		# calculate the average for every other place
		for i in range(1,self.row):
			for j in range(1,self.col):
				if self.matrix[0][j] == self.matrix[i][0]:
					self.set_element(self.matrix[i-1][j-1], i, j)
				else:
					self.set_element(self.__get_min3(), i, j)

		return self.matrix[row-1][col-1]
	
