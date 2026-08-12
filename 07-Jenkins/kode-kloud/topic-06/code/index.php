<?php

require __DIR__ . '/vendor/autoload.php';

use App\Calculator;

$calc = new Calculator();

echo $calc->add(2, 3) . PHP_EOL;
echo ($calc->isPrime(17) ? 'true' : 'false') . PHP_EOL;
for ($i = 1; $i <= 15; $i++) {
    echo $calc->fizzbuzz($i) . PHP_EOL;
}
