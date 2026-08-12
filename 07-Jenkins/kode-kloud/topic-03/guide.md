# Topic 3: Unit Tests With PHPUnit

**Time:** 20 minutes

## Goal
Add a real test suite, run it with PHPUnit as a new **Execute Shell**
step, and produce a JUnit XML report Jenkins can turn into a visual
pass/fail breakdown.

## Files Provided
`code/composer.json` (now with `phpunit/phpunit` under `require-dev`),
`code/phpunit.xml`, `code/tests/CalculatorTest.php`,
`code/src/Calculator.php`, `code/index.php`, `code/.gitignore` (now also
ignores `/build/`, where the JUnit report will be written).

## Execute Shell Command
Add this as a **new** step, after "Composer Install" and "PHP Syntax
Check":

```bash
echo "== Stage: Unit Tests (PHPUnit) =="
vendor/bin/phpunit --testdox --log-junit build/report.xml
```

## Guided Steps
1. Copy this topic's `code/*` into `simple-project`, overwriting
   `composer.json`, `index.php`, and `.gitignore`, and adding
   `phpunit.xml` and `tests/CalculatorTest.php`.
2. Commit and push. Because `require-dev` changed, the existing
   "Composer Install" step from Topic 2 will pull in PHPUnit the next
   time it runs - no changes needed to that step itself.
3. Add the **Unit Tests (PHPUnit)** step above to the job, after the
   existing two steps, and save.
4. Trigger a build. Read the `--testdox` output: it prints each test
   method as a readable sentence (`Add`, `Is prime`, `Fizzbuzz`) with a
   pass/fail mark.
5. In the job configuration, add a **post-build action**: "Publish JUnit
   test result report," with report path `build/report.xml`. This is a
   Jenkins feature, not another Execute Shell step - it parses the XML
   `phpunit` wrote and turns it into the job's **Test Result Trend**
   graph and a per-test breakdown page.
6. Break a test on purpose - change `testFizzbuzz`'s expected value for
   `fizzbuzz(15)` to something wrong - push, and watch the "Unit Tests"
   step fail while the earlier two stages still pass. Click **Test
   Result** on the failed build to see exactly which assertion failed.
7. Fix the test, push again, confirm all three stages are green.

## Guided Explanation
`phpunit.xml`'s `bootstrap="vendor/autoload.php"` is what lets test files
use `App\Calculator` without a manual `require` - it's the same Composer
autoloader from Topic 2, just also loaded by PHPUnit before tests run.

## Checkpoint
`composer.json` now has both `autoload` and `autoload-dev` blocks. What's
the practical difference, and why would shipping a real application
without `require-dev` care about that distinction?
