#!/usr/bin/env python3
import random

# constants
bits = 5
width = 10


# calculated constants
max = 2**bits - 1


for i in range(max + 1):
    tgt = i / max
    acc = 0
    tot = random.randint(0, 1)
    s = ""
    for j in range(width):        
        avg = tot / (j + 1)
        if tgt > avg:
            s = s + "1"
            tot += 1
        else:
            s = s + "0"
            
    if i == max:
        print("when others => R := \"%s\";" % (s))
    else:
        print("when %d => R := \"%s\";" % (i, s))


