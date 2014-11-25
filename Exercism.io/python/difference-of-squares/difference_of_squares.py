def euler_sum(n):      return n*(n+1)/2

def square_of_sum(n):  return euler_sum(n) ** 2
def sum_of_squares(n): return euler_sum(n) * (2*n+1)/3

def difference(n):     return square_of_sum(n) - sum_of_squares(n)

