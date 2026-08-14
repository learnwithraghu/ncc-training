"""Tiny CLI used across this whole track - it grows one topic at a time."""


def add(a, b):
    return a + b


if __name__ == "__main__":
    import sys
    print(add(int(sys.argv[1]), int(sys.argv[2])))
