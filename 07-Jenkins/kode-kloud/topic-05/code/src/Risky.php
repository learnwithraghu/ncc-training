<?php

namespace App;

// Valid PHP, PSR-12 clean - but written badly on purpose so PHPMD's
// rulesets (unused code, cyclomatic complexity, naming) have something
// real to flag. Neither php -l, phpunit, nor phpcs catch any of this.
class Risky
{
    public function classify($value, $unusedParam)
    {
        $result = null;

        if ($value > 100) {
            if ($value > 200) {
                if ($value > 300) {
                    $result = 'huge';
                } else {
                    $result = 'large';
                }
            } else {
                $result = 'medium';
            }
        } elseif ($value > 50) {
            $result = 'small';
        } else {
            $result = 'tiny';
        }

        $unusedLocal = 42;

        return $result;
    }
}
