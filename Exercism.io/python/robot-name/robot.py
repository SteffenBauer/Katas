import string
import random
import unittest
import math

class Robot(object):
    def __init__(self, unique=True):
        self.assigned_names = set()
        self.unique = unique
        self.reset()

    def reset(self):
        while True:
            self.name = ''.join(map(random.choice, [string.uppercase]*2 + [string.digits]*3))
            if self.name not in self.assigned_names:
                if self.unique:
                    self.assigned_names.add(self.name)
                break

class CollisionRobotTest(unittest.TestCase):

    # How many robot names do we need to have a 0.99% probability of a collision?
    # Approximation using the birthday paradox
    def names_with_likely_collision(self, robot):
        num = int(0.5 + math.sqrt(0.25 - 2.0 * float(26*26*10*10*10) * math.log(0.01)))
        used_names = set()
        for i in range(num):
            used_names.add(robot.name)
            robot.reset()
        return (num, len(used_names))

    def test_unique_name_generation(self):
        num, names = self.names_with_likely_collision(Robot(True))
        self.assertEqual(num, names)

    def test_name_collision(self):
        num, names = self.names_with_likely_collision(Robot(False))
        self.assertNotEqual(num, names)

if __name__ == '__main__':
    unittest.main()
