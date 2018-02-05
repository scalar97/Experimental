def levenshtein(string1, string2):
	temp = [[(len(string1)+1)] * (len(string2)+1)]
	row, col= len(temp[0]) , len(temp)
	
	# filling the first row and col with increments distance
	for i in range(row): temp[0][i] = i
	for j in range(col): temp[j][0] = j
		
	# calculate the average for every other place
	for i in range(1,row):
		for j in range(1,col):
			if temp[0][j] == temp[i][0]:
				temp[i][j] = temp[i-1][j-1]
			else:
				x, y, z = temp[a-1][b], temp[a][b-1], temp[a-1][b-1]
				
				if x <= y and x<= z: min_ = x
				elif y <= z: min_ = y
				else: min_ = z
				temp[i][j] = min_ + 1
				
	return temp[row-1][col-1]
	
