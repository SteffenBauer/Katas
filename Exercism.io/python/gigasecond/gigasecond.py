import datetime

def add_gigasecond(d):
    gigasec = datetime.timedelta(seconds = 1000*1000*1000)
    return d + gigasec

