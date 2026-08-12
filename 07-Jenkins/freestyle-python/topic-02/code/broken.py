"""Deliberately invalid Python file.

This file exists on purpose: it has a syntax error (missing colon). It is
used to prove that the "Python Syntax Check" Execute Shell step actually
catches bad code instead of always reporting success. Do not fix it - the
guide fixes it live in the terminal to turn a red build green.
"""


def broken_function(a, b)
    return a + b
