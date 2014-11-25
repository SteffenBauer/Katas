#!/usr/bin/env python
# -*- coding: utf-8 -*-

def word_idx(word): return "".join(sorted(word))

def read_words(filename):
    with open(filename) as filehandle:
        words    = (line.strip() for line in filehandle)
        wordlist = [( word, word_idx(word)) for word in words]
    return wordlist

def chunk(words):
    ret, idx = [], ""
    for w in words:
        if w[1] != idx:
            if ret != []: yield ret
            ret, idx = [w[0]], w[1]
        else:
            ret.append(w[0])
    if ret != []: yield ret
    return

def find_longest(acc, x): return x if len(x) > len(acc) else acc

if __name__ == "__main__":
    wordlist = read_words("wordlist.txt")
    wordlist = sorted(wordlist, key=lambda x: x[1])
    anagramlist = chunk(wordlist)
    anagramlist = filter(lambda x: len(x) > 1, anagramlist)
    print "Found", len(anagramlist), "anagrams"
    longest = reduce(find_longest, anagramlist)
    print "Longest anagram list is", longest, "with", len(longest), "anagrams"

