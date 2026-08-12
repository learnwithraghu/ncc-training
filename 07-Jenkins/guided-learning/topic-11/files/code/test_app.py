"""Pytest unit tests for app.py, run from the Jenkins pipeline."""
from app import add, is_prime, fizzbuzz


def test_add():
    assert add(2, 3) == 5
    assert add(-1, 1) == 0


def test_is_prime():
    assert is_prime(2) is True
    assert is_prime(17) is True
    assert is_prime(1) is False
    assert is_prime(9) is False


def test_fizzbuzz():
    assert fizzbuzz(3) == "Fizz"
    assert fizzbuzz(5) == "Buzz"
    assert fizzbuzz(15) == "FizzBuzz"
    assert fizzbuzz(7) == "7"
