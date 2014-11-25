codes = ['wink', 'double blink', 'close your eyes', 'jump']

def handshake(code):
    try:
        if type(code) == str: code = int(code, 2)
        if code > 31 or code < 0: raise ValueError
    except ValueError: return []
    ret = [codes[i] for i in range(4) if (code & 2**i) >= 1 ]
    if (code & 0x10) == 0x10: ret.reverse()
    return ret

def code(shake):
    coded = encode_shake(shake, codes, '')
    if coded != None:
        return coded
    coded = encode_shake(shake[::-1], codes, '')
    if coded != None:
        return '1' + coded
    return '0'

def encode_shake(shake, encodes, encoded):
    if len(shake) == 0:
        return encoded
    if encodes == [] and len(shake) > 0:
        return None
    if shake[0] == encodes[0]:
        return encode_shake(shake[1:], encodes[1:], '1'+encoded)
    return encode_shake(shake, encodes[1:], '0'+encoded)

