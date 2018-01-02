def prime_upto_n(max_):
	prime_divisors = set()
	primes = set()
	
	for prime in range(2,max_ + 1):
		if prime not in prime_divisors:
			j = prime * 2
			while j <= max_:
				if j % prime == 0:
					prime_divisors.add(j)
				j += prime
			primes.add(prime)
		
	return primes
