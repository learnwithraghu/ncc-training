# Topic 6: Copy-Paste Detection With PHPCPD, and the Full Pipeline

**Time:** 20 minutes

## Goal
Add the last stage - duplicate-code detection - then step back and look
at the whole six-stage pipeline you've built one Execute Shell step at a
time.

## File Provided
`code/app.php` - 43 lines: the mess-detection fix from Topic 5 carried
forward, plus a new `addAgain` method that copy-pastes `add`'s exact
body, on purpose.

## Execute Shell Command
Add this as a **new** step, after "Mess Detection (PHPMD)":

```bash
echo "== Stage: Copy-Paste Detection (PHPCPD) =="
vendor/bin/phpcpd --min-lines=3 --min-tokens=20 app.php
```

## Guided Steps
1. Copy this topic's `code/app.php` over your existing one. Commit and
   push.
2. Add the **Copy-Paste Detection (PHPCPD)** step to the job, after
   "Mess Detection," and save.
3. Trigger a build. The first four stages pass. "Copy-Paste Detection"
   fails - read the report: it names `add()` and `addAgain()` as
   near-exact duplicates.
4. Fix it the way you would in a real project: delete `addAgain`
   entirely (nothing in this file actually needs a second copy of the
   same logic). Push, rebuild, confirm all six stages are green.
5. `--min-lines=3 --min-tokens=20` lowers PHPCPD's default detection
   thresholds so a two-line duplicate method still gets flagged in a
   small teaching example - on a real codebase, the defaults
   (`--min-lines=5 --min-tokens=70`) are usually a better starting
   point; tune from there based on how noisy the reports get.

## The Full Pipeline
Six Execute Shell steps, in this order, is the whole module:

| Order | Stage | Tool | Catches |
|-------|-------|------|---------|
| 1 | Composer Install | `composer` | Missing/incompatible dependencies |
| 2 | PHP Syntax Check | `php -l` | Code that doesn't even parse |
| 3 | Unit Tests | PHPUnit | Code that parses but behaves wrong |
| 4 | Code Style Check | PHP_CodeSniffer | Correct code, inconsistent formatting |
| 5 | Mess Detection | PHPMD | Working code, poor structure |
| 6 | Copy-Paste Detection | PHPCPD | Duplicated logic in the same file |

Each stage answers a narrower, later question than the one before it -
that's why the order matters and why no single tool from this list could
replace the other five. The whole thing ran on one file, `app.php`, that
never grew past 43 lines.

## Checkpoint
If "PHP Syntax Check" (stage 2) fails, do stages 3-6 still run in a
Jenkins Freestyle job with one Execute Shell step per stage? What would
you need to change about how the steps are configured if you wanted
every stage to run and report its own result regardless of earlier
failures?
