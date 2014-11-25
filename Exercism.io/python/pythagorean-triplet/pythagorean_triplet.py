
def triplets_in_range(m1, m2):
    return { (a, b, c) for a in range(m1,  m2-1)
                       for b in range(a+1, m2)
                       for c in range(b+1, m2+1)
                       if is_triplet( (a,b,c) ) }

def primitive_triplets(b):
    if (b%4) > 0: raise ValueError
    return { tuple(sorted((m*m-n*n, 2*m*n, m*m+n*n))) 
             for m in range(1,b) 
             for n in range(1,m) 
             if _pythagorean(b,m,n) }

def is_triplet(t):
    a, b, c = sorted(t)
    return a*a + b*b == c*c

def _gcd(a, b):
    while b > 0: a, b = b, a % b
    return a

def _pythagorean(b, m, n):
    return (2*m*n) == b and (m-n)%2 == 1 and _gcd(m, n) == 1

