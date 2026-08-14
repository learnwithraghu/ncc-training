<?php

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
}
