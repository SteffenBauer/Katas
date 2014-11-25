
def sort_n_lower(word): 
    return "".join(sorted(word.lower()))

def test_for_anagram(word, base): 
    return sort_n_lower(word) == sort_n_lower(base) and word.lower() != base

def detect_anagrams(base, candidates):
    return [w for w in candidates if test_for_anagram(w, base) ]

