
def smallest_palindrome(max_factor, min_factor=0):
    return min(_all_palindromes(max_factor, min_factor), key=lambda p:p[0])

def largest_palindrome(max_factor, min_factor=0):
    return max(_all_palindromes(max_factor, min_factor), key=lambda p:p[0])

def _all_palindromes(max_factor, min_factor):
    return [ (a*b, (a, b)) for a in range(min_factor,max_factor+1)
                           for b in range(min_factor, a+1)
                           if _is_palindrome(a,b) ]

def _is_palindrome(a, b):
    return str(a*b) == str(a*b)[::-1]

