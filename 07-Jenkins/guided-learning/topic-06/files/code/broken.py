"""Deliberately invalid Python file.

This file exists on purpose: it has a syntax error (missing colon). It is
used to prove that a Jenkins pipeline's "syntax check" stage actually
catches bad code instead of always reporting success. Do not fix it - the
guided topics fix it live in the terminal to turn a red build green.
"""


def broken_function(a, b)
    return a + b
