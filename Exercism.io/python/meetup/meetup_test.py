from datetime import date
import unittest

from meetup import meetup_day


class MeetupTest(unittest.TestCase):
    def test_monteenth_of_may_2013(self):
        self.assertEqual(date(2013, 5, 13),
                         meetup_day(2013, 5, 'Monday', 'teenth'))

    def test_saturteenth_of_february_2013(self):
        self.assertEqual(date(2013, 2, 16),
                         meetup_day(2013, 2, 'Saturday', 'teenth'))

    def test_first_tuesday_of_may_2013(self):
        self.assertEqual(date(2013, 5, 7),
                         meetup_day(2013, 5, 'Tuesday', '1st'))

    def test_second_monday_of_april_2013(self):
        self.assertEqual(date(2013, 4, 8),
                         meetup_day(2013, 4, 'Monday', '2nd'))

    def test_third_thursday_of_september_2013(self):
        self.assertEqual(date(2013, 9, 19),
                         meetup_day(2013, 9, 'Thursday', '3rd'))

    def test_fourth_sunday_of_march_2013(self):
        self.assertEqual(date(2013, 3, 24),
                         meetup_day(2013, 3, 'Sunday', '4th'))

    def test_last_thursday_of_october_2013(self):
        self.assertEqual(date(2013, 10, 31),
                         meetup_day(2013, 10, 'Thursday', 'last'))

    def test_last_wednesday_of_february_2012(self):
        self.assertEqual(date(2012, 2, 29),
                         meetup_day(2012, 2, 'Wednesday', 'last'))
                         
    def test_wrong_position(self):
        self.assertEqual(None,
                         meetup_day(2013, 3, 'Sunday', 'wtf'))

    def test_wrong_dayname(self):
        self.assertEqual(None,
                         meetup_day(2013, 3, 'Blergh', 'last'))

if __name__ == '__main__':
    unittest.main(verbosity=2)
