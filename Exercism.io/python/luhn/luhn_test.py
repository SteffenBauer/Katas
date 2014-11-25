import unittest

from luhn import Luhn


class LuhnTests(unittest.TestCase):
    def test_addends(self):
        self.assertEqual([1, 4, 1, 4, 1], Luhn(12121).addends())

    def test_addends_large(self):
        self.assertEqual([7, 6, 6, 1], Luhn(8631).addends())

    def test_checksum1(self):
        self.assertEqual(2, Luhn(4913).checksum())

    def test_ckecksum2(self):
        self.assertEqual(1, Luhn(201773).checksum())

    def test_invalid_number(self):
        self.assertFalse(Luhn(738).is_valid())

    def test_valid_number(self):
        self.assertTrue(Luhn(8739567).is_valid())

    def test_create_valid_number1(self):
        self.assertEqual(1230, Luhn.create(123))

    def test_create_valid_number2(self):
        self.assertEqual(8739567, Luhn.create(873956))

    def test_create_valid_number3(self):
        self.assertEqual(8372637564, Luhn.create(837263756))


if __name__ == '__main__':
    unittest.main()
