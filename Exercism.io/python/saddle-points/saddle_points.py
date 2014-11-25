
def saddle_points(matrix):
    if matrix == []: return set()
    rowlengths = map(lambda r: len(r), matrix)
    if max(rowlengths) != min(rowlengths): raise ValueError

    return { (x,y) for y in range(len(matrix[0]))
                   for x in range(len(matrix))
                   if max(matrix[x]) == matrix[x][y] == min(zip(*matrix)[y]) }

