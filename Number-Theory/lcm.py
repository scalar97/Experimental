# function to find the lowest common of a number using the gcd of the two numbers

from gcd import euclidian_gcd
from numpy import prod


def lcm_gcd(*arg):
	if len(arg) > 2:
		num1 = prod(arg[: len(arg) -1])
		num2 = arg[:-1]
		return int(num1 * num2 / euclidian_gcd(num1,num2))
	else:
		return int(arg[0]*arg[1] /euclidian_gcd(arg[0],arg[1]))
