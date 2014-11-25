import itertools

def nth_prime(n):
    primelist = [2]
    for i in range(n-1):
        add_prime(primelist)
    return primelist[-1]
    
def add_prime(primelist):
    lastprime = primelist[-1]
    while True:
        lastprime += 1
        if is_prime(lastprime, primelist):
            primelist.append(lastprime)
            break

def is_prime(p, primelist):
    return not any(itertools.imap(lambda n: p%n == 0, primelist))
