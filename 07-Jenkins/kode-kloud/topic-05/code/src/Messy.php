<?php

namespace App;

class Messy
{
    public $publicVar = "value";

    public function badMethod($a, $b)
    {
        $x = $a + $b;
        return $x;
    }
}
