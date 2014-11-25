
class Allergies(object):
    allergens = ['eggs', 'peanuts', 'shellfish', 'strawberries', 
                 'tomatoes', 'chocolate', 'pollen', 'cats']

    def __init__(self, allergies_code):
        self.myallergies = allergies_code

    def is_allergic_to(self, allergen):
        return self.myallergies & 2**self.allergens.index(allergen) > 0

    @property
    def list(self):
        return [ a for a in self.allergens if self.is_allergic_to(a) ]



