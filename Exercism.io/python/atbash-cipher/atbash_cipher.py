
import string

BLOCKSIZE = 5

def cipher():
    plain  = string.ascii_lowercase
    cipher = string.ascii_lowercase[::-1]
    return string.maketrans(plain, cipher)

def code(text):
    return text.lower().translate(cipher(), string.punctuation + string.whitespace)

def chunk(text):
    if len(text) <= BLOCKSIZE: return text
    return text[0:BLOCKSIZE] + ' ' + chunk(text[BLOCKSIZE:])

def encode(text):
    return chunk(code(text))

def decode(text):
    return code(text)
