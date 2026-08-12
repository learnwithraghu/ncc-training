# Topic 1: PHP Syntax Check

**Time:** 20 minutes

## Goal
Get the very first CI stage working: push PHP code to Gitea, let Jenkins
trigger automatically, and have a single **Execute Shell** build step
fail the build the moment any `.php` file doesn't parse.

## Files Provided
`code/index.php`, `code/Calculator.php` (both valid), `code/broken.php`
(a real syntax error - a missing closing brace).

## Execute Shell Command
Add this as the job's first **Execute Shell** build step:

```bash
echo "== Stage: PHP Syntax Check =="
STATUS=0
for f in $(find . -name "*.php" -not -path "./vendor/*"); do
    echo "-- php -l $f"
    php -l "$f" || STATUS=1
done
exit $STATUS
```

## Guided Steps
1. Copy `code/index.php`, `code/Calculator.php`, and `code/broken.php`
   into your local `simple-project` folder.
2. Commit and push to `master`. Confirm in the Jenkins job that a new
   build was triggered automatically by the push (check the build's
   "Started by" cause).
3. If the job has no build steps yet, open its configuration, add the
   **Execute Shell** step above, and save. Otherwise this step *is* the
   job for now - later topics append to it.
4. The build should go **red**. Open the console output and find the
   exact `php -l` line that reports the parse error in `broken.php`.
5. Fix `broken.php` (add the missing closing `}`) locally, commit, push
   again. Watch the same build step go **green**.
6. Read the script: it loops over every `.php` file (skipping `vendor/`,
   which won't exist until Topic 2), running `php -l` on each one
   individually and only setting `STATUS=1` on failure - so one bad file
   doesn't stop the script from checking the rest, but the **build**
   still fails overall because of the final `exit $STATUS`.

## Guided Explanation
`php -l` ("lint") only parses the file - it does not run it. That's
exactly the same boundary Topic 7 of `guided-learning/` drew for Python's
`py_compile`: catches "this isn't even valid code," catches nothing about
whether the code is any good.

## Checkpoint
If you removed the `|| STATUS=1` and just wrote `php -l "$f"` on its own
line, would the build still correctly fail when `broken.php` is present?
Why or why not - what does the shell step's exit code depend on?
