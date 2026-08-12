<?php

namespace App;

// A second class that copy-pasted logic straight out of Calculator
// instead of reusing it. This is exactly the kind of duplication PHPCPD
// looks for - php -l, phpunit, phpcs, and phpmd all have no opinion on
// duplication at all, so nothing earlier in the pipeline catches this.
class CalculatorDuplicate
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
