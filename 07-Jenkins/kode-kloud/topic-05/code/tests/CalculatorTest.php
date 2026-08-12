<?php

namespace App\Tests;

use App\Calculator;
use PHPUnit\Framework\TestCase;

class CalculatorTest extends TestCase
{
    private Calculator $calc;

    protected function setUp(): void
    {
        $this->calc = new Calculator();
    }

    public function testAdd(): void
    {
        $this->assertSame(5, $this->calc->add(2, 3));
        $this->assertSame(0, $this->calc->add(-1, 1));
    }

    public function testIsPrime(): void
    {
        $this->assertTrue($this->calc->isPrime(17));
        $this->assertFalse($this->calc->isPrime(1));
        $this->assertFalse($this->calc->isPrime(9));
    }

    public function testFizzbuzz(): void
    {
        $this->assertSame('Fizz', $this->calc->fizzbuzz(3));
        $this->assertSame('Buzz', $this->calc->fizzbuzz(5));
        $this->assertSame('FizzBuzz', $this->calc->fizzbuzz(15));
        $this->assertSame('7', $this->calc->fizzbuzz(7));
    }
}
