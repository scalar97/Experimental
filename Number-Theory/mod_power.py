# program to compute the modulo of a number
# 'a' raised to the power of a number 'n', modulo 'y'.

def mod_power(a, n ,y):

	if n == 0: return 1
	if a == 0 or y == 0: return 0

	initial = a % y
	i = 1
	while 2 ** i <= n:
		initial = (initial ** 2) % y
		i += 1
	if 2 ** (i-1) == n:
		return initial
	else:
		return (initial * mod_power(a,  n - (2 ** (i -1)) , y)) % 6

	print(mod_power(1234244242242424,434234324242424512,27))
