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
	# if (number / curr_prime ** i -1) == next(primes)
	if log(number, curr_prime) == i-1:
		return (curr_prime, i-1)
	else:
		# the number where it stopped dividing 
		new_factor= number//(curr_prime**(i-1))
		return (curr_prime, i-1) , prime_factoriser(new_factor, get_prime_factor(curr_prime, new_factor))
	
	

# get primes has to be a genetator to implement next()
def get_prime_factor(from_, end):
	from_ = 3 if from_ == 2 else from_ + 2
	# plus one to accomodate when from_ divides evenly into end e.g 3|9, 4|16, 3|12 ..
	all_numbers = (n for n in range(from_, ceil(end ** 0.5) + 1, 2))
	for number in all_numbers:
		if end % number == 0:
			return number
	return end

