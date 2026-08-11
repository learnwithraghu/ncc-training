import pytest

from app import add, divide, fizzbuzz, is_prime, multiply, subtract


def test_add():
    assert add(2, 3) == 5


def test_subtract():
    assert subtract(5, 3) == 2


def test_multiply():
    assert multiply(4, 3) == 12


def test_divide():
    assert divide(10, 2) == 5


def test_divide_by_zero_raises():
    with pytest.raises(ValueError):
        divide(1, 0)


@pytest.mark.parametrize(
    "n,expected",
    [(1, False), (2, True), (4, False), (17, True), (18, False)],
)
def test_is_prime(n, expected):
    assert is_prime(n) is expected


def test_fizzbuzz():
    result = fizzbuzz(15)
    assert result[2] == "Fizz"
    assert result[4] == "Buzz"
    assert result[14] == "FizzBuzz"
    assert result[0] == "1"
