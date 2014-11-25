
scrabble_values = {'aeioulnrst': 1, 'dg': 2, 'bcmp': 3, 'fhvwy': 4,
                   'k': 5, 'jx': 8, 'qz': 10}

def score(word):
    return sum(map(get_scrabble_value, word.lower()))

def get_scrabble_value(char):
    for k in scrabble_values.keys():
        if char in k:
            return scrabble_values[k]
    return 0

