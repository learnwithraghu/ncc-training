# Topic 1: PHP Syntax Check

**Time:** 20 minutes

## Goal
Get the very first CI stage working: push PHP code to Gitea, let Jenkins
trigger automatically, and have a single **Execute Shell** build step
fail the build the moment `app.php` doesn't parse.

## File Provided
`code/app.php` - 9 lines, one `Calculator` class with an `add` method.
This is the whole app for this topic; it grows from here.

## Execute Shell Command
Add this as the job's first **Execute Shell** build step:

```bash
echo "== Stage: PHP Syntax Check =="
php -l app.php
```

## Guided Steps
1. Copy `code/app.php` into your local `simple-project` folder. Commit
   and push to `master`. Confirm in the Jenkins job that a new build was
   triggered automatically by the push (check the build's "Started by"
   cause).
2. If the job has no build steps yet, open its configuration, add the
   **Execute Shell** step above, and save. Otherwise this step *is* the
   job for now - later topics append to it.
3. The build should be **green** on this file as-is. Now break it on
   purpose: locally delete the final closing `}` from `app.php`, commit,
   and push.
4. Watch the build go **red**. Open the console output and find the
   exact line `php -l` reports the parse error on.
5. Restore the closing `}` (or just `git revert`/re-copy `code/app.php`),
   commit, push again, and confirm the build is green.

## Guided Explanation
`php -l` ("lint") only parses the file - it does not run it. That's
exactly the same boundary Topic 7 of `guided-learning/` drew for Python's
`py_compile`: catches "this isn't even valid code," catches nothing about
whether the code is any good. From here, every topic adds a new stage
that looks a little deeper.

## Checkpoint
Why is "break it yourself, watch it fail, fix it, watch it pass" a more
convincing way to learn what a CI stage does than just reading that it
"checks syntax"?
