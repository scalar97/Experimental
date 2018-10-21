def prime_upto_n(max_):
	prime_divisors = set()
	primes = set()

	for prime in range(2,max_):
		if prime not in prime_divisors:
			j = prime * 2 # start counting from next prime factor
			while j <= max_: # stay in the bouds specified by max_
				if j % prime == 0:
					prime_divisors.add(j) # add the number to the seen set()
				j += prime # increment in prime factors
			primes.add(prime)
		
	return primes
