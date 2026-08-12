"""Tiny stdlib-only CLI used as the "code to test" throughout this track.

No third-party dependencies, so it can be syntax-checked and linted
without needing anything beyond Python itself.
"""
import sys


def add(a, b):
    """Return the sum of two numbers."""
    return a + b


def is_prime(n):
    """Return True if n is a prime number."""
    if n < 2:
        return False
    for i in range(2, int(n ** 0.5) + 1):
        if n % i == 0:
            return False
    return True


def main():
    if len(sys.argv) < 2:
        print("usage: app.py <add|is_prime> [args]")
        return 1

    command = sys.argv[1]
    if command == "add":
        a, b = int(sys.argv[2]), int(sys.argv[3])
        print(add(a, b))
    elif command == "is_prime":
        n = int(sys.argv[2])
        print(is_prime(n))
    else:
        print(f"unknown command: {command}")
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
