<?php
// Plain functions for now - no namespace, no Composer yet.
// Composer and PSR-4 autoloading arrive in Topic 02.

function add($a, $b)
{
    return $a + $b;
}

function isPrime($n)
{
    if ($n < 2) {
        return false;
    }
    for ($i = 2; $i * $i <= $n; $i++) {
        if ($n % $i === 0) {
            return false;
        }
    }
    return true;
}

function fizzbuzz($n)
{
    if ($n % 15 === 0) {
        return 'FizzBuzz';
    }
    if ($n % 3 === 0) {
        return 'Fizz';
    }
    if ($n % 5 === 0) {
        return 'Buzz';
    }
    return (string) $n;
}
