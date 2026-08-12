# Topic 4: Code Style Check With PHP_CodeSniffer

**Time:** 20 minutes

## Goal
Add a style-checking stage. `Messy.php` will parse fine (`php -l` passes)
and has no tests to fail - it violates PSR-12 formatting rules only, and
this is the first stage that will actually catch that.

## Files Provided
`code/composer.json` (adds `squizlabs/php_codesniffer`),
`code/phpcs.xml.dist` (tells `phpcs` which standard and paths to use),
`code/src/Messy.php` (valid PHP, full of PSR-12 violations),
`code/src/Calculator.php`, `code/tests/CalculatorTest.php`,
`code/index.php`, `code/phpunit.xml`.

## Execute Shell Command
Add this as a **new** step, after "Unit Tests (PHPUnit)":

```bash
echo "== Stage: Code Style Check (PSR-12) =="
vendor/bin/phpcs --standard=PSR12 src/ index.php
```

## Guided Steps
1. Copy this topic's `code/*` into `simple-project`. Commit and push -
   the "Composer Install" step will now also pull in
   `squizlabs/php_codesniffer`.
2. Add the **Code Style Check (PSR-12)** step to the job, after "Unit
   Tests," and save.
3. Trigger a build. "PHP Syntax Check" and "Unit Tests" both pass -
   `Messy.php` is valid, working PHP. "Code Style Check" fails - read the
   `phpcs` report: missing visibility modifier on `badMethod`, no space
   around `=` and after the comma, brace placement, and a stray closing
   `?>` tag at the end of the file (PSR-12 says PHP-only files should
   omit it).
4. Open `src/Messy.php` and fix the violations one at a time, rebuilding
   between fixes so you can watch the error count in the `phpcs` report
   go down.
5. Once clean, try the auto-fixer instead of fixing by hand next time:
   `vendor/bin/phpcbf --standard=PSR12 src/ index.php` rewrites files in
   place for the mechanical violations (spacing, brace style) - it won't
   add a missing `public` keyword for you, but it removes most of the
   busywork.
6. Notice `phpcs.xml.dist` exists but the Execute Shell command still
   passes `--standard=PSR12` explicitly. That's deliberate for this
   lesson - once you're comfortable, `vendor/bin/phpcs` alone (no flags)
   would read the same configuration from `phpcs.xml.dist` automatically.

## Checkpoint
`Messy.php` never fails "PHP Syntax Check" or "Unit Tests" (it has no
tests). What category of real-world bug does a PSR-12 style check *not*
protect you from, and which earlier stage in this module actually does?
