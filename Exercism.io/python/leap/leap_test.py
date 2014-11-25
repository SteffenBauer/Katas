import unittest

# from year import is_leap_year

import leap

class YearTest(unittest.TestCase):
    def test_leap_year(self):
        self.assertTrue(leap.is_leap_year(1996))

    def test_non_leap_year(self):
        self.assertFalse(leap.is_leap_year(1997))

    def test_non_leap_even_year(self):
        self.assertFalse(leap.is_leap_year(1998))

    def test_century(self):
        self.assertFalse(leap.is_leap_year(1900))

    def test_exceptional_century(self):
        self.assertTrue(leap.is_leap_year(2400))

if __name__ == '__main__':
    unittest.main()
