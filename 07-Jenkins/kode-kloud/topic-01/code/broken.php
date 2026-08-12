<?php
// Deliberately invalid PHP - a missing closing brace. Used to prove the
// "Syntax Check" Execute Shell step actually fails the build instead of
// always reporting green. Do not fix it here - fix it live on the Jenkins
// agent / in your simple-project checkout, then push again.

function brokenFunction($a, $b)
{
    return $a + $b;
