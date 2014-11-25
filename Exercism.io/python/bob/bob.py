
def is_question(what):
    return what.endswith('?')

def said_nothing(what):
    return what.strip() == ""
    
def is_yelling(what):
    return what.isupper()

def hey(what):
    if   said_nothing(what): return "Fine. Be that way!"
    elif is_yelling(what):   return "Whoa, chill out!"
    elif is_question(what):  return "Sure."
    else:                    return "Whatever."

