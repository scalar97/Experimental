import sys
import operator as op
from functools import reduce
from collections import defaultdict

def is_even(n):
    return n % 2 == 0

def get_next(alist,step):
	'''get_next gets the next skilled contestant in (O)1 as alist is sorted
	   alist: the sorted lists of contestant in descending order
	   step: how far the next contestant is
	'''
    if step < len(alist):
        return alist[step]
    return alist[len(alist)-1]

def clear_resolved(alist, n):
	'''clear deletes the first n contestants from a alist'''
	for i in range(n):
	    alist.pop(0)

def n_choose_k(n,r):
	'''implementation of the n choose k formula; faster than itertools'''
    r = min(r, n-r)
    numer = reduce(op.mul, range(n, n-r, -1), 1)
    denom = reduce(op.mul, range(1, r+1), 1)
    return numer//denom

def team(alist, cache):
	'''team return the valid paring(i.es=number of way they can be paired) 
       of the current bests contestant i.e alist[0], and/or the current best and the next_best(s) alist[nest_best_index]
	'''
    best = alist[0] # the best is always the first element as alist is sorted.
	# cache gives the number of occurence of 'best' inside alist
	# e.g alist = [2,2,2,1], best=2,therefore cache[best]=3
    occurrence = cache[best]
	# get the next skilled contestant e.g [2,2,1,1] get_next(..) will return 2
    next_best = get_next(sorted_contestants,occurrence)
	# same computation as occurence above
    next_occ = cache[next_best]

	# only proceed if there are more than 2 people, edge case for 2 has been taken care of. see line 93
    if len(alist) <= 2:
        return [], 0
	# if all remaining contestants are equally skilled,
    # return the number of combinations that can be made with them and we are done, e.g [2,2,2,2] return 6
    elif next_best == best: 
        return [], n_choose_k(occurrence,2)
    else:
		# if there is one skilled person and:
        if occurrence == 1:
			# two people will be teamed regardless
			# so delete them before the return statement
            clear_resolved(alist, 2)
			# if the next skilled person is only one person.
			# there is only one combination with the previous skilled , return the updated list, then 1.
			# in other words:how many ways can you team two skilled people if we don't care about their order
			# person1, person2 or person2,person1 = one; so long as we have those 2 people together. second way would be redundant
            if next_occ == 1:
                return alist, 1
            else:
				# else we have 1 best, but many second_bests
				# one of them will be teamed afterwards, so reduce that person
                cache[next_best] -= 1
				# return next_occ because it is the same as saying
				# if i have 1 best and 3 next_best,e.g [3,2,2,2] I can either pair them a (3,2) (3,2) (3,2) for each one of the twos
				# notice that the pairs are the same as the number of next_best , thus just return how many next_best there were
                return alist, next_occ
		# else if there are more bests , e.g in [5,5,5,5,4,3] occurrence=5, pair them with eachother before proceeding
        elif occurrence > 1:
			# two bests will be paired regardless, so delete them, we know how many they were initially through 'occurence'
            clear_resolved(alist,2) 
            cache[best] -= 2
            return alist, n_choose_k(occurrence,2) # keep on pairing the bests until there are one or none left.


testcases = int(sys.stdin.readline().strip())

while testcases :
    no_of_ppl = int(sys.stdin.readline().strip())
    contestants = sys.stdin.readline().strip().split(" ")
    contestants = list(map(lambda x: int(x), contestants))
	
    sorted_contestants = sorted(contestants, reverse=True) # sort the contestant so that high skilled ppl sit next to each other

    cache = defaultdict(int) # keep track of the occurence of bests
    total = 0 # the total pairings that can be made
	
    for i in sorted_contestants: # building the cache
        cache[i] += 1

    if len(sorted_contestants) == 2: # take care of the edge case [3,2] set total number to 1 and returun immedialty
        total = 1
    else:
        temp = sorted_contestants # this temp array is used to get arround pass by refence as sorted_contestants will shrink as the program runs
        while len(temp) > 0: # while there are still people to pair,
            sorted_contestants, returned = team(temp, cache) # return people who haven't been paired yet and the number of way they can be paired
            total += returned # update the total
            temp = sorted_contestants # reassign the temp array

    print(total % 100000007) # print the total

    testcases -= 1
