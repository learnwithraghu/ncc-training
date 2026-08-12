<?php
require __DIR__ . '/Calculator.php';

echo add(2, 3) . PHP_EOL;
echo (isPrime(17) ? 'true' : 'false') . PHP_EOL;
for ($i = 1; $i <= 15; $i++) {
    echo fizzbuzz($i) . PHP_EOL;
}
