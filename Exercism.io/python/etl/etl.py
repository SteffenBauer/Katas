
def transform(old_dict):
    return { nk.lower(): k for k in old_dict for nk in old_dict[k] }

