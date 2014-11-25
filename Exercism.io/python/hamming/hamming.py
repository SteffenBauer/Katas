
def distance(strand1, strand2):
    return len(filter(lambda (a,b): a!=b, zip(strand1, strand2)))

