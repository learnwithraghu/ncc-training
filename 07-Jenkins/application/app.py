#!/usr/bin/env python3
"""Small ops-utils CLI used as the Jenkins lab project.

Kept dependency-free (stdlib only) so pipeline stages install fast and the
Lint/Test/Package stages have something real to check.
"""
import argparse
import sys


def add(a: float, b: float) -> float:
    return a + b


def subtract(a: float, b: float) -> float:
    return a - b


def multiply(a: float, b: float) -> float:
    return a * b


def divide(a: float, b: float) -> float:
    if b == 0:
        raise ValueError("cannot divide by zero")
    return a / b


def is_prime(n: int) -> bool:
    if n < 2:
        return False
    for divisor in range(2, int(n ** 0.5) + 1):
        if n % divisor == 0:
            return False
    return True


def fizzbuzz(n: int) -> list:
    result = []
    for i in range(1, n + 1):
        if i % 15 == 0:
            result.append("FizzBuzz")
        elif i % 3 == 0:
            result.append("Fizz")
        elif i % 5 == 0:
            result.append("Buzz")
        else:
            result.append(str(i))
    return result


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(description="NCC Jenkins lab utility")
    sub = parser.add_subparsers(dest="command", required=True)

    calc = sub.add_parser("calc", help="run a math operation")
    calc.add_argument("op", choices=["add", "subtract", "multiply", "divide"])
    calc.add_argument("a", type=float)
    calc.add_argument("b", type=float)

    prime = sub.add_parser("is-prime", help="check if a number is prime")
    prime.add_argument("n", type=int)

    fb = sub.add_parser("fizzbuzz", help="print fizzbuzz up to n")
    fb.add_argument("n", type=int)

    args = parser.parse_args(argv)

    if args.command == "calc":
        ops = {
            "add": add,
            "subtract": subtract,
            "multiply": multiply,
            "divide": divide,
        }
        print(ops[args.op](args.a, args.b))
    elif args.command == "is-prime":
        print(is_prime(args.n))
    elif args.command == "fizzbuzz":
        print("\n".join(fizzbuzz(args.n)))

    return 0


if __name__ == "__main__":
    sys.exit(main())
