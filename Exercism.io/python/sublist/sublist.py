
SUBLIST   = 1
SUPERLIST = 2
EQUAL     = 3
UNEQUAL   = 4

def check_lists(a, b):
    if a == b:           return EQUAL
    if is_sublist(a, b): return SUBLIST
    if is_sublist(b, a): return SUPERLIST
    return UNEQUAL

def is_sublist(a, b):
    start, end = 0, len(a)
    while end <= len(b):
        if a == b[start:end]: return True
        start, end = start+1, end+1
    return False

