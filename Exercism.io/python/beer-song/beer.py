
def song(start, end=0):
    return ''.join(map(lambda n: verse(n) + "\n", 
                       range(start, end-1, -1)))

def verse(n):

    plural   = lambda n: 's' if n!=1 else ''
    pronoun  = lambda n: "one" if n > 1 else "it"
    nomore   = lambda s: 'No more' if s else 'no more'
    numbeers = lambda n, s: str(n) if n>0 else nomore(s)

    beer   = lambda n, s: "{num} bottle{s} of beer".format(num=numbeers(n, s), s=plural(n))
    wall   = lambda n, s: "{beers} on the wall".format(beers=beer(n, s))

    first_line  = lambda n: "{beersonwall}, {beers}.\n".format(beersonwall=wall(n, True), beers=beer(n, False))

    takebeer = lambda n: "Take {pronoun} down and pass it around, {beersonwall}.\n".format(pronoun=pronoun(n), beersonwall=wall(n-1, False))
    buymore =            "Go to the store and buy some more, {beersonwall}.\n".format(beersonwall=wall(99, False))

    second_line = lambda n: takebeer(n) if n >= 1 else buymore

    return first_line(n) + second_line(n)

