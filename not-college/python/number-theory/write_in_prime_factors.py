# write a number as a product of prime factors
# e.g. input: 48 output ((2,4),(3,1)) where 48 = 2^4 * 3^1
# input 8 output (2,3) where 8 = 2^3
from math import log, ceil

def prime_factoriser(number, curr_prime):
	i = 1
	# while number can evenly divide into curr_prime
	while number % (curr_prime ** i) == 0:
		i+=1
	# alternative to log function is to compare with the next prime
	# if (number / curr_prime ** i -1) == get_prime_factor(curr_prime,number//(curr_prime**(i-1)))
	if log(number, curr_prime) == i-1:
		return (curr_prime, i-1)
	else:
		# the number where it stopped dividing 
		new_factor= number//(curr_prime**(i-1))
		return (curr_prime, i-1), prime_factoriser(new_factor, get_prime_factor(curr_prime, new_factor))
	
	
	

# get primes has to be a genetator to implement next()
def get_prime_factor(from_, end):
	from_ = 3 if from_ == 2 else from_ + 2
	# plus one to accomodate when from_ divides evenly into end e.g 3|9, 4|16, 3|12 ..
	all_numbers = (n for n in range(from_, ceil(end ** 0.5) + 1, 2))
	for number in all_numbers:
		if end % number == 0:
			# a prime factor was found
			return number
	# the number itself is prime
	return end


# the values returned have to be unpacked for the unittest module to work
# this will be implemented using a queue. these values are returned in a
# from of a tree. Breadth first search has to be used to flatten the
# nesting, down to single level tuples.

# e.g prime_factoriser(4823,2) returns ((2, 0), ((7, 1), ((13, 1), (53, 1))))
# those nested values are the results of the recursive calls of dividors that
# were not product of the current_prime at that point
# this resulted them to make their own recursive calls and append their results to
# the parent result. Thus, the return of expected values but in a nested form

# from the test case above:
# what I get : ((2, 0), ((7, 1), ((13, 1), (53, 1))))
# what I want: ((2, 0), (7, 1), (13, 1), (53, 1))

# the easier way to solve this would be to recieve values completely
# flatten from prime_factoriser. e.g as (2,0,7,1,13,1,53,1), then
# user ../../Problem-solving.from_flat_to_tuple_pairs.pairs_maker 
# function to reconstruct the tuple pairs.
# but this would loose the tree structure of the output, which would be usefull
# in other many other applications

import unittest
from functools import reduce

class TestPrimeFactoriser(unittest.TestCase):

	correct_values = ( (48, ((2,4), (3,1)))  , (51, ((2,0), (3,1), (17,1))) )
	more_values = (34,64,98854, 235)
	incorrect_values = (49,102)

	def test_prime_factoriser(self): 

		# direct check
		for dividor , factors in self.correct_values:
			self.assertEqual(prime_factoriser(dividor,2), factors)

		# when muliplying the factors together they should give the dividor
		for dividor in self.more_values:
			self.assertEqual(dividor, reduce(lambda x,y: (x[0]**x[1]) * (y[0]**y[1])),
				prime_factoriser(dividor,2))

		# false checks
		for dividor in self.incorrect_values:
			for answer in self.correct_values:
				self.assertNotEqual(prime_factoriser(dividor,2), answer[1])

# if __name__=='__main__':
# 	unittest.main()
