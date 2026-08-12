# Topic 5: Mess Detection With PHPMD

**Time:** 20 minutes

## Goal
Add a stage that looks past syntax and style into code *quality* -
unused variables, deeply nested conditionals, unused parameters - none
of which `php -l`, PHPUnit, or `phpcs` have any reason to flag.

## Files Provided
`code/composer.json` (adds `phpmd/phpmd`), `code/src/Risky.php` (valid,
PSR-12-clean, but deliberately messy logic), plus the now-fixed
`code/src/Messy.php` from Topic 4, `code/src/Calculator.php`,
`code/tests/CalculatorTest.php`, `code/index.php`, `code/phpunit.xml`,
`code/phpcs.xml.dist`.

## Execute Shell Command
Add this as a **new** step, after "Code Style Check (PSR-12)":

```bash
echo "== Stage: Mess Detection (PHPMD) =="
vendor/bin/phpmd src/,index.php text cleancode,codesize,controversial,design,naming,unusedcode
```

## Guided Steps
1. Copy this topic's `code/*` into `simple-project`. Commit and push -
   `phpmd/phpmd` installs via the existing "Composer Install" step.
2. Add the **Mess Detection (PHPMD)** step to the job, after "Code Style
   Check," and save.
3. Trigger a build. The first three stages pass - `Risky.php` compiles,
   has no tests to fail, and is formatted correctly. "Mess Detection"
   fails - read the report: `UnusedFormalParameter` on `$unusedParam`,
   `UnusedLocalVariable` on `$unusedLocal`, and a complexity warning on
   `classify()` for its nested `if`/`elseif` chain.
4. Fix `Risky.php`: remove the unused parameter and variable, and
   flatten the nested conditionals (a `match` expression or an early-
   return chain both work). Push, rebuild, confirm the stage goes green.
5. Read the six ruleset names in the command - `phpmd` ships several
   rulesets, and you chose to run all six at once. Try running with just
   `unusedcode` to see a much shorter, more focused report - useful when
   you're introducing this stage to a team for the first time and don't
   want to overwhelm them on day one.

## Guided Explanation
PHPMD is inherently more opinionated than `phpcs` - "this function is too
complex" is a judgment call, not an objective parse rule. Many real teams
run this stage without letting it fail the build (append `|| true` to the
command, or route its output to a Jenkins warnings plugin as "unstable"
rather than "failed"). This lesson leaves it blocking, on purpose, so you
feel the difference before deciding which policy fits your own team.

## Checkpoint
If you appended `|| true` to the `vendor/bin/phpmd` command, the Execute
Shell step would always exit 0. What would you lose by doing that, and
what would you still gain from running the tool at all?
