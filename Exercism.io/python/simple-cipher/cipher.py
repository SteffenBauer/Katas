import string
import itertools
import random

class Cipher(object):
    discard = string.punctuation + string.digits + string.whitespace

    def __init__(self, key=""):
        if key == "":
            randchar = lambda: random.choice(string.lowercase)
            key = str().join([randchar() for i in xrange(100)])
        self.key = key
        if key.lower().translate(None, Cipher.discard) != key: 
            raise ArgumentError

    def encode(self, text):
        text = text.lower().translate(None, Cipher.discard)
        keycycle = itertools.cycle(self.key)
        return str().join(itertools.imap(self._encoder, text, keycycle))

    def decode(self, crypto):
        keycycle = itertools.cycle(self.key)
        return str().join(itertools.imap(self._decoder, crypto, keycycle))

    def _encoder(self, char, shift):
        ret = ord(char) + (ord(shift) - ord('a'))
        return self._normalize(ret)

    def _decoder(self, char, shift):
        ret = ord(char) - (ord(shift) - ord('a'))
        return self._normalize(ret)

    def _normalize(self, char):
        if char < ord('a'): return chr(char + (ord('z')-ord('a')+1))
        if char > ord('z'): return chr(char - (ord('z')-ord('a')+1))
        return chr(char)

class Caesar(Cipher):
    def __init__(self):
        super(Caesar, self).__init__('d')

