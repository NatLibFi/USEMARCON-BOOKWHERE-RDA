#!/usr/bin/env python
# -*- coding: utf-8 -*

'''
Lisätään formaattitarkistustaulun vaihtuvamittaisten kenttien määrityksiin osakentät $5 ja $9.
'''


def addFields(line):
    return line + " $5* | $9* |"


def writeFile(data):
    with open("../ma_bibl.chk", "wt", encoding="utf-8") as f:
        f.write(data)


def is_number(char):
    try:
        float(char)
        return True
    except ValueError:
        return False

with open("../ma_bibl.chk", encoding="ISO-8859-1") as f:
    data = f.read().split("\n")

formatted = ""

for line in data:
    code = line[0:3]
    if (is_number(code)):
        if (int(code) > 8):
            line = addFields(line)
    formatted += line + "\n"
    
#writeFile(formatted)
