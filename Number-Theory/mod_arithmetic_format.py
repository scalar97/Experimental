# Program to rewrite the divident a and the divisor b in modulus arithmetic 
# forme. e.g a = 239, b= 15, get written as 299 = 15(15)+ 14. 
# the remainder must always be a positive integer
#
# Author : Tatiana Zihindula
#

import unittest


def modulo_equation (divident, divisor):
	"""Returns the quotient and the remainder as a tuple"""
	if divisor == 0:
		raise ZeroDivisionError('Error: The dividor must not equal zero.')
	
	elif divident > 0 and divisor > 0:
		return (int(divident/divisor), divident % divisor)

	elif divident < 0 and divisor > 0:
		# -1 to get one divisor unit above the current quotient
		return (int(divident/divisor) - 1 , divident % divisor )

	elif divident > 0 and divisor < 0:
		# * -1 to get the absolute value of the divisor
		return (int(divident/divisor), divident % (divisor * -1))

	else:
		# +1 to get one divisor unit above the current quotient
		return (int(divident/divisor) + 1 ,divident % (divisor * -1))


# q,r = modulo_equation(-1001,15)
# print('{0} = {1}({2}) + {3}'.format(-1001,15,q,r))



class Test_Modulo_Equation(unittest.TestCase):

	input_cases = ((11,4), (-11,4),(11,-4),(-11,-4),(1,11),(12,1))
	correct_output = ((2, 3),(-3, 1),(-2, 3),(3, 1),(0, 1),(12, 0))
	incorrect_output = iter(((10, -3),(-34, 1),(-52, 6),(4, -1),(2, 1),(2, 6.0)))
	zero_division = (8,0)

	def test_modulo_equation(self):
		# true check
		self.assertSequenceEqual([modulo_equation(d,v)
					for d,v in self.input_cases], self.correct_output)
		# false check
		for d, v in self.input_cases:
			self.assertNotEqual(modulo_equation(d,v), next(self.incorrect_output))

		# zero division check, unpacks zero_division's arguments
		with self.assertRaises (ZeroDivisionError):
			modulo_equation(*self.zero_division)
			
						
if __name__=='__main__':
	unittest.main()
