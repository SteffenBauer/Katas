
def hexa(s, num=0):
    s = s.upper()
    if len(s) == 0: return num
    if s[0] in '0123456789': return hexa(s[1:], (num*16)   +ord(s[0])-ord('0'))
    if s[0] in 'ABCDEF':     return hexa(s[1:], (num*16)+10+ord(s[0])-ord('A'))
    raise ValueError

