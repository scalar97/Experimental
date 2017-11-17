# program to compute the modulo of a number
# a raised to the power of a number n, mod a number y.

def mod_power(a, n ,y):
	initial = a % y
	i = 1
	while 2 ** i <= n:
		initial = (initial ** 2) % y
		i += 1
	if 2 ** (i-1) == n:
		return initial
		print(i,"initial = ",initial)
	else:
		rest = n - (2 ** (i -1))
		print(i,"initial = ",initial,"rest = ", rest)
		return (initial * mod_power(a, rest, y)) % 6
