import copy

class School(object):
    def __init__(self, schoolname):
        self.schoolname = schoolname
        self.__db = dict()
        
    def add(self, student, grade):
        if grade not in self.__db:
            self.__db[grade] = set()
        self.__db[grade].add(student)
            
    def grade(self, g):
        if g not in self.__db: return set()
        else:                  return self.__db[g]
    
    def sort(self):
        return { k: tuple(sorted(v)) for (k,v) in self.__db.iteritems()}

    @property
    def db(self):
        return copy.deepcopy(self.__db)

