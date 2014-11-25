
class SpaceAge(object):
    YEAR_LENGTHS = { "mercury": 0.2408467,
                     "venus": 0.61519726,
                     "earth": 1.0,
                     "mars": 1.8808158,
                     "jupiter": 11.862615,
                     "saturn": 29.447498,
                     "uranus": 84.016846,
                     "neptune": 164.79132 }

    def __init__(self, seconds):
        self.seconds = seconds
        self.rawyear = seconds / 31557600.0

    def __getattribute__(self, name):
        if name[:3] == "on_" and name[3:] in self.YEAR_LENGTHS:
            return lambda: round(self.rawyear / self.YEAR_LENGTHS[name[3:]], 2)
        else:
            return object.__getattribute__(self, name)
