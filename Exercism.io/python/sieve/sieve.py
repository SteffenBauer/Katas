
def sieve(upper):
    primes = [ x+1 for x in xrange(1,upper) ]
    pivot = 0
    while pivot < len(primes):
        test = primes[pivot]
        primes = [ p for p in primes if p <= test or p % test != 0 ]
        pivot += 1
    return primes

