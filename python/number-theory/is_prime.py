import unittest

def is_prime(number):
	"""Returns True if the number is prime"""

	if type(number).__name__ != 'int':
		return False

	if number in (2,3,5):
		return True

	elif(number <= 1 or True in (number % i == 0 for i in (2,3,5))):
		return False

	else:# alternatively, if (number ^ 1/2), or (i*i < number)
		square_root_number = int((number ** 0.5) + 1) 
		for divisor in range(7, square_root_number,2):
			if number % divisor == 0:
				return False
		return True






class Test(unittest.TestCase):
	primes = (2,11,17,101,601,877,911,99991,5915587277)
	non_primes = (2000,4,253,27,49,77,'hi',-19, 17.1,3.0)

	def test_is_prime(self):
		# True check
		for prime in self.primes:
			self.assertTrue(is_prime(prime))

	def test_is_prime(self):
		# False check
		for not_a_prime in self.non_primes:
			self.assertFalse(is_prime(not_a_prime))

if __name__ == '__main__':
	unittest.main()
