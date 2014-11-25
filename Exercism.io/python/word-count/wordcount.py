
import collections

def my_word_count(sentence):
    return dict(collections.Counter(sentence.split()))

