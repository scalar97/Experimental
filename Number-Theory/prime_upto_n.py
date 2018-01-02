def prime_upto_n(max_):
	all_numbers = [ x for x in range(2,max_) ]
	primes = set()
	i = 0
	while i < len(all_numbers):
		prime = all_numbers.pop(0)
		j = 0
		while j < len(all_numbers):
			if all_numbers[j] % prime == 0:
				del all_numbers[j]
			j += 1
		primes.add(prime)
		i += 1
	primes.update(all_numbers)

	return primes
