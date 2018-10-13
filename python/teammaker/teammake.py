import sys
import operator as op
from functools import reduce
from collections import defaultdict

def is_even(n):
    return n % 2 == 0

def get_next(alist,step):
    if step < len(alist):
        return alist[step]
    return alist[len(alist)-1]

def clear_resolved(alist, num):
	for i in range(num):
	    alist.pop(0)

def n_choose_k(n,r):
    r = min(r, n-r)
    numer = reduce(op.mul, range(n, n-r, -1), 1)
    denom = reduce(op.mul, range(1, r+1), 1)
    return numer//denom

def team(alist, cache):
    best = alist[0]
    occurrence = cache[best]
    next_best = get_next(sorted_contestants,occurrence)
    next_occ = cache[next_best]

    if len(alist) <= 2:
        return [], 0
    elif next_best == best:
        return [], n_choose_k(occurrence,2)
    else:
        if occurrence == 1:
            clear_resolved(alist, 2)
            if next_occ == 1:
                return alist, 1
            else:
                cache[next_best] -= 1
                return alist, next_occ # return how many there were initially
        elif occurrence > 1:
            clear_resolved(alist,2)
            cache[best] -= 2
            return alist, n_choose_k(occurrence,2)


testcases = int(sys.stdin.readline().strip())

while testcases :
    no_of_ppl = int(sys.stdin.readline().strip())
    contestants = sys.stdin.readline().strip().split(" ")
    contestants = list(map(lambda x: int(x), contestants))
    sorted_contestants = sorted(contestants, reverse=True)

    cache = defaultdict(int)
    total = 0
    for i in sorted_contestants:
        cache[i] += 1

    if len(sorted_contestants) == 2:
        total = 1
    else:
        temp = sorted_contestants
        while len(temp) > 0:
            sorted_contestants, returned = team(temp, cache)
            total += returned
            temp = sorted_contestants

    print(total % 100000007)

    testcases -= 1
