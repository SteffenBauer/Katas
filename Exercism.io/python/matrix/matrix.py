

class Matrix(object):
    def __init__(self, init):
        split_at_newline = lambda m:   map(lambda s: s.split(), m.split('\n'))
        convert_to_int   = lambda m:   map(lambda s: int(s), m)
        column_range     = lambda m:   range(len(m))
        column_at        = lambda m,x: list(zip(*m)[x])

        self.rows    = [convert_to_int(row)       for row in split_at_newline(init)]
        self.columns = [column_at(self.rows, col) for col in column_range(self.rows[0])]

