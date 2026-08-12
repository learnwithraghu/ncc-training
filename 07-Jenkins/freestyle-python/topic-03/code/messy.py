"""Valid Python - it compiles fine - but full of style problems on purpose.

Used to show the difference between a *syntax* check (py_compile only
cares if the parser accepts the file) and a *lint* check (flake8 also
cares about unused imports, spacing, and line length).
"""
import os
import sys
import json


def add(a,b):
    x = a+b
    unused_variable = 42
    return x

def really_long_line_that_definitely_goes_past_the_flake8_default_line_length_limit_of_79_characters(a, b, c):
    return a + b + c
