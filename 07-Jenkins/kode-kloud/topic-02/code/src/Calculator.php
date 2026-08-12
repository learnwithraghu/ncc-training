<?php

namespace App;

class Calculator
{
    public function add($a, $b)
    {
        return $a + $b;
    }

    public function isPrime($n)
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

    public function fizzbuzz($n)
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
}
