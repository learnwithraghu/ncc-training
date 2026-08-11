<?php

require_once __DIR__ . '/app.php';

if (add(2, 3) !== 5) {
    fwrite(STDERR, "Test failed\n");
    exit(1);
}

echo "Test passed\n";
