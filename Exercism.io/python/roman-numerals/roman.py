
romannums =  [ (1000, "M"), (900, "CM"), (500, "D"), (400, "CD") ,
                (100, "C"),  (90, "XC"),  (50, "L"),  (40, "XL") ,
                 (10, "X"),   (9, "IX"),   (5, "V"),   (4, "IV") ,
                  (1, "I") ]

def numeral(number, romanstr="", ctb=romannums):
    if number == 0:           return romanstr
    elif number >= ctb[0][0]: return numeral(number-ctb[0][0], romanstr+ctb[0][1], ctb)
    else:                     return numeral(number, romanstr, ctb[1:])

