
class Garden(object):
    default_childs = [ "Alice", "Bob", "Charlie", "David",
                 "Eve", "Fred", "Ginny", "Harriet",
                 "Ileana", "Joseph", "Kincaid", "Larry" ]
    plant_table = { 'V': "Violets", 'C': "Clover", 'G': "Grass", 'R': "Radishes" }
    
    def __init__(self, garden, students = default_childs):
        self.children = sorted(students)
        self.row1, _, self.row2 = garden.partition('\n')
        
    def plants(self, child):
        pos = 2*self.children.index(child)
        plantcodes = [self.row1[pos], self.row1[pos+1], 
                      self.row2[pos], self.row2[pos+1] ]
        return [ self.plant_table[p] for p in plantcodes ]
