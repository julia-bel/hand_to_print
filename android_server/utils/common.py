def multidict_to_dict(multidict):
    print(multidict)
    d = {}
    for k in multidict.keys():
        v = multidict.getall(k)
        if isinstance(v, list):
            if len(v) > 1:
                d[k] = v
            else:
                d[k] = v[0]
        else:
            d[k] = v

    return d