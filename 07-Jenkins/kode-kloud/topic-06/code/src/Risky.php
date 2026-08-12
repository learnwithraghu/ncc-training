<?php

namespace App;

class Risky
{
    public function classify($value)
    {
        return match (true) {
            $value > 300 => 'huge',
            $value > 200 => 'large',
            $value > 100 => 'medium',
            $value > 50 => 'small',
            default => 'tiny',
        };
    }
}
