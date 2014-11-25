
def parse_binary(s, num=0):
    if len(s) == 0 : return num
    if s[0] in '10': return parse_binary(s[1:], (num<<1) + int(s[0]) )
    raise ValueError

