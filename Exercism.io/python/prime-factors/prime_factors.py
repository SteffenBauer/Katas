

def prime_factors(num):
    factors, n = [], 2
    while n <= num:
        if num % n == 0:
            factors.append(n)
            num /= n
        else:
            n += 1 if n == 2 else 2
    return factors

