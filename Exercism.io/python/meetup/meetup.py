
import datetime
import calendar

DAYRULES = { 'teenth': lambda d: [dn for dn in d if dn in range(13,20)][0],
             '1st':    lambda d: d[0],
             '2nd':    lambda d: d[1],
             '3rd':    lambda d: d[2],
             '4th':    lambda d: d[3],
             'last':   lambda d: d[-1] }

def meetup_day(year, month, day, rule):
    try:
        days = calendar.Calendar().itermonthdays2(year, month)
        daycode = list(calendar.day_name).index(day)
        possible_days = [ dn for (dn, dc) in days if dn > 0 and dc == daycode ]
        resulting_day = DAYRULES[rule](possible_days)
        return datetime.date(year, month, resulting_day)
    except:
        return None

