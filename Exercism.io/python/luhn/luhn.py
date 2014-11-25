
class Luhn(object):
    def __init__(self, value):
        self.value = value

    def addends(self):
        return self._add_odd(self.value, [])
    
    def _add_odd(self, value, luhn):
        if value == 0: return luhn
        luhnval = value % 10
        return self._add_even(value / 10, [luhnval] + luhn)

    def _add_even(self, value, luhn):
        if value == 0: return luhn
        luhnval = 2*(value%10)
        if luhnval >= 10: luhnval -= 9
        return self._add_odd(value / 10, [luhnval] + luhn)

    def checksum(self):
        return sum(self.addends()) % 10

    def is_valid(self):
        return self.checksum() == 0

    @staticmethod
    def create(number):
        return 10*number + ((10-Luhn(10*number).checksum()) % 10)

