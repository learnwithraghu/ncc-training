# Topic 5: Mess Detection With PHPMD

**Time:** 20 minutes

## Goal
Add a stage that looks past syntax, tests, and style into code *quality*
- an unused parameter and an unused local variable, neither of which
`php -l`, PHPUnit, or `phpcs` have any reason to flag.

## File Provided
`code/app.php` - PSR-12-clean again (Topic 4's fix carried forward), but
`isPrime` now takes an extra `$unused` parameter and declares an unused
`$wasted` variable it never reads. The tests were updated to still call
`isPrime` correctly with the new (unused) second argument.

## Execute Shell Command
Add this as a **new** step, after "Code Style Check (PSR-12)":

```bash
echo "== Stage: Mess Detection (PHPMD) =="
vendor/bin/phpmd app.php text cleancode,codesize,controversial,design,naming,unusedcode
```

## Guided Steps
1. Copy this topic's `code/app.php` over your existing one. Commit and
   push.
2. Add the **Mess Detection (PHPMD)** step to the job, after "Code Style
   Check," and save.
3. Trigger a build. The first three stages pass - the file compiles, has
   correctly formatted code, and its tests pass. "Mess Detection" fails -
   read the report: `UnusedFormalParameter` on `$unused`,
   `UnusedLocalVariable` on `$wasted`.
4. Fix `app.php`: remove the `$unused` parameter from `isPrime` (and the
   extra argument from both places it's called in `CalculatorTest`), and
   remove the `$wasted` line. Push, rebuild, confirm the stage goes
   green.
5. Read the six ruleset names in the command - `phpmd` ships several
   rulesets at once here. Try running with just `unusedcode` to see a
   much shorter, more focused report - useful when introducing this
   stage to a team for the first time.

## Guided Explanation
PHPMD is inherently more opinionated than `phpcs` - "this parameter is
unused" is close to objective, but other PHPMD rules (like flagging
"too many lines in a method") are judgment calls. Many real teams don't
let this stage fail the build (append `|| true`, or route its output to
a "warnings" plugin instead). This lesson leaves it blocking, on purpose,
so you feel the difference before deciding which policy fits your team.

## Checkpoint
If you appended `|| true` to the `vendor/bin/phpmd` command, the Execute
Shell step would always exit 0. What would you lose by doing that, and
what would you still gain from running the tool at all?
