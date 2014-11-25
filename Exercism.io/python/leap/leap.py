
def is_leap_year(year):
    year_div_4   = (year % 4)   == 0
    year_div_100 = (year % 100) == 0
    year_div_400 = (year % 400) == 0
    return year_div_400 or (year_div_4 and not year_div_100)

