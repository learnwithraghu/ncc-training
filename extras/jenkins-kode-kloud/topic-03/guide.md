# Topic 3: Unit Tests With PHPUnit

**Time:** 20 minutes

## Goal
Add a `CalculatorTest` class **inside the same file** as `Calculator`,
run it with PHPUnit as a new Execute Shell step, and produce a JUnit XML
report Jenkins can turn into a visual pass/fail breakdown.

## File Provided
`code/app.php` - now 38 lines: the same `Calculator` class, plus a
`CalculatorTest` class at the bottom that tests it.

## Execute Shell Command
Add this as a **new** step, after "Composer Install" and "PHP Syntax
Check":

```bash
echo "== Stage: Unit Tests (PHPUnit) =="
vendor/bin/phpunit --testdox --log-junit build/report.xml
```

## Guided Steps
1. Copy this topic's `code/app.php` over your existing one. Commit and
   push.
2. Add the **Unit Tests (PHPUnit)** step above to the job, after the
   existing two steps, and save.
3. Trigger a build. Read the `--testdox` output: it prints each test
   method as a readable sentence (`Add`, `Is prime`) with a pass/fail
   mark. No arguments told `phpunit` which file to run - it read
   `phpunit.xml` from `setup/`, which points straight at `app.php`.
4. In the job configuration, add a **post-build action**: "Publish JUnit
   test result report," with report path `build/report.xml`. This is a
   Jenkins feature, not another Execute Shell step - it parses the XML
   `phpunit` wrote and turns it into the job's **Test Result Trend**
   graph and a per-test breakdown page.
5. Break a test on purpose: change `testIsPrime`'s expectation for
   `isPrime(9)` from `assertFalse` to `assertTrue`. Push, and watch "Unit
   Tests" fail while the earlier two stages still pass. Click **Test
   Result** on the failed build to see exactly which assertion failed.
6. Fix it back, push again, confirm all three stages are green.

## Guided Explanation
Having the test class live in the same file as the code it tests is not
how a large PHP project would do it - but it's exactly why this stays
possible as "1 file, growing," and PHPUnit doesn't care: point it at any
file (or directory) and it runs every `TestCase` subclass it finds.

## Checkpoint
Why does `Calculator` never need a `require` or `use App\...` statement
to see itself from inside `CalculatorTest`, when they'd need one if they
lived in separate files?
