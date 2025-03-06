#!/usr/bin/env python3
import random

# constants
bits = 5
width = 10
rep = 4

# calculated constants
max = 2**bits - 1


for i in range(max + 1):
    t = width * rep * i / max
    n = 0
    for k in range(rep):
        s = ""
        for j in range(width):        
            if n > t:
                s = s + "0"
            else:
                s = s + "1"
            n += 1
                
        if i == max and k == rep-1:
            print("when others => R := \"%s\";" % (s))
        else:
            print("when %d => R := \"%s\";" % (i * rep + k, s))


