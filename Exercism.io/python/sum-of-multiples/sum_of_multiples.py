
class SumOfMultiples(object):
    def __init__(self, *nn):
        self.factors = nn or (3,5)
    
    def to(self,n):
        return sum(x for x in range(1,n) if self._is_multiple(x))
    
    def _is_multiple(self, n):
        return any((n % x == 0) for x in self.factors)
