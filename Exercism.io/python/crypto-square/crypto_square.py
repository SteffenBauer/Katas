from string import whitespace, punctuation
from itertools import dropwhile, count

def encode(phrase):
    p = phrase.lower().translate(None, whitespace+punctuation)
    l = next(dropwhile(lambda x: x*x < len(p), count()))
    return str(' ').join(p[i::l] for i in range(l))

