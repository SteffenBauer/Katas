
def slices(series, length):
    if length < 1 or length > len(series): 
        raise ValueError
    return [ [int(series[y+x]) for x in range(length)] 
                               for y in range(len(series)-length+1) ]

