# Topic 4: Code Style Check With PHP_CodeSniffer

**Time:** 20 minutes

## Goal
Add a style-checking stage. This topic's `app.php` still parses fine and
still passes every test - it only violates PSR-12 formatting, and this is
the first stage that has any reason to care.

## File Provided
`code/app.php` - same 2 methods and 2 tests as Topic 3, but `Calculator`
is now formatted badly on purpose: missing spaces after commas, no space
around `+`/`*`/`%`/`<`/`===`, and a brace placed on the same line as the
method signature.

## Execute Shell Command
Add this as a **new** step, after "Unit Tests (PHPUnit)":

```bash
echo "== Stage: Code Style Check (PSR-12) =="
vendor/bin/phpcs --standard=PSR12 app.php
```

## Guided Steps
1. Copy this topic's `code/app.php` over your existing one. Commit and
   push.
2. Add the **Code Style Check (PSR-12)** step to the job, after "Unit
   Tests," and save.
3. Trigger a build. "PHP Syntax Check" and "Unit Tests" both pass -
   the file is valid, working PHP. "Code Style Check" fails - read the
   `phpcs` report: missing space after a comma, missing whitespace
   around operators, and an opening brace that should be on its own
   line.
4. Open `app.php` and fix the violations in `add` and `isPrime` one at a
   time, rebuilding between fixes so you can watch the error count in
   the `phpcs` report go down.
5. Once clean, try the auto-fixer instead of fixing by hand next time:
   `vendor/bin/phpcbf --standard=PSR12 app.php` rewrites the file in
   place for the mechanical violations (spacing, brace style).

## Guided Explanation
Notice the command only checks `app.php`, not `vendor/`. `phpcs` would
happily report thousands of style "violations" in third-party library
code you don't control and can't fix - always scope these tools to your
own code.

## Checkpoint
This `app.php` never fails "PHP Syntax Check" or "Unit Tests." What
category of real-world bug does a PSR-12 style check *not* protect you
from, and which earlier stage in this module actually does?
