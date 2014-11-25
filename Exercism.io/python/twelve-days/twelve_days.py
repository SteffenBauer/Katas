
def sing():
    return verses(1,12)
    
def verses(start, end):
    return ''.join(verse(n) + "\n" for n in range(start, end+1))

items = ['a Partridge', 'two Turtle Doves', 'three French Hens', 
         'four Calling Birds', 'five Gold Rings', 'six Geese-a-Laying',
         'seven Swans-a-Swimming', 'eight Maids-a-Milking', 'nine Ladies Dancing',
         'ten Lords-a-Leaping', 'eleven Pipers Piping', 'twelve Drummers Drumming']

numbers = ['first', 'second', 'third', 'fourth', 'fifth', 'sixth',
           'seventh', 'eighth', 'ninth', 'tenth', 'eleventh', 'twelfth']

songline = "On the {day} day of Christmas my true love gave to me, {gifts} in a Pear Tree.\n"

def verse(n):
    day = numbers[n-1]
    firstgift = ', and ' + items[0] if n>1 else items[0]
    gifts = ', '.join(items[n-1:0:-1]) + firstgift
    return songline.format(day=day, gifts=gifts)

