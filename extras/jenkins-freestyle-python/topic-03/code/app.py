"""Tiny CLI used across this whole track - it grows one topic at a time."""
import sys
import os


def add(a,b):
    return a+b

def is_prime(n):
    if n<2:
        return False
    for i in range(2,int(n**0.5)+1):
        if n%i==0:
            return False
    return True

def main():
    command=sys.argv[1]
    if command=="add":
        print(add(int(sys.argv[2]),int(sys.argv[3])))
    elif command=="is_prime":
        print(is_prime(int(sys.argv[2])))

if __name__=="__main__":
    main()
