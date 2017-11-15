# base case = when gcd (0,b) or gcd(a,0) return the non zero valae
# case 1: both even
# if both a and b are even, return binary 2, multiplied by gcd a/2, b/2
# case 2: either one is odd
# if a is odd return (gcd a, b/2) if b is odd, return gcd a/2, b
# case 3: both odd
# if a >= b, return gcd (a-b dibided by 2 , b )
# if b > a, return gcd (b-a dibided by 2, a)

# Author Tatiana Zihindula


def binary_gcd(a,b):
	'''
	Returns the gcd of a, and b using 
	the the recursive implementation of the binary gcd algorithm
	'''
	# case 0 : either a or b is zero
	if a == 0: return b
	elif b == 0: return a

	# case 1: both a and b are even
	elif a & 1 == b & 1 == 0:
		return 2 * binary_gcd(a>>1, b>>1) 

	# case 2: a is odd but b is even
	elif a & 1 and (not b & 1) :
		return binary_gcd(a, b >> 1)
	# case 2: a is even but b is odd
	elif (not a & 1) and b & 1:
		return binary_gcd(a >> 1, b)

	# case 3: they are both odd
	else:
		if a >= b :
			return binary_gcd ((a-b) >>1, b)
		else:
			return binary_gcd (a, (b-a) >>1)


def euclidian_gcd(a,b):
	if a < 0 :
		a *= -1
	if b < 0 :
		b *= -1
	if a < b:
		a , b = b , a
	if b == 0:
		print(a,b)
		return a
	else:
		print(a,b)
		return euclidian_gcd(b, a%b)
	


# import unittest

# class TestBinaryGcd(unittest.TestCase):
# 	pass

# if __name__ == '__main__':
#	unittest.main()
