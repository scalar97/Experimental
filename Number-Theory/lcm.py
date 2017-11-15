# function to find the lowest common of a number using the gcd of the two numbers

from gcd import euclidian_gcd

def lcm_gcd(*numbers):
	n = number[: len(numbers) -1]
	product = int(reduce(lambda x, y: x * y, n))
	return product * numbers[len(n)] / int(euclidian_gcd(product, numbers[len(n)]))
