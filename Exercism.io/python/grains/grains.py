
def on_square(n):
    s = 1
    for i in range(n-1):
        s *= 2
    return s
    
def total_after(n):
    s, t = 1, 1
    for i in range(n-1):
        s *= 2
        t += s
    return t

