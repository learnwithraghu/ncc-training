<?php

use PHPUnit\Framework\TestCase;

class Calculator
{
    public function add($a, $b)
    {
        return $a + $b;
    }

    public function isPrime($n, $unused)
    {
        $wasted = 1;
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

class CalculatorTest extends TestCase
{
    public function testAdd()
    {
        $this->assertSame(5, (new Calculator())->add(2, 3));
    }

    public function testIsPrime()
    {
        $this->assertTrue((new Calculator())->isPrime(17, null));
        $this->assertFalse((new Calculator())->isPrime(9, null));
    }
}
