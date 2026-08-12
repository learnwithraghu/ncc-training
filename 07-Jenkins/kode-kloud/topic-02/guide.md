# Topic 2: Dependencies With Composer

**Time:** 20 minutes

## Goal
Do the **one-time setup** this whole track depends on, add `isPrime` to
`app.php`, and add a `composer install` stage ahead of the syntax check.

## Files Provided
- `../setup/composer.json`, `../setup/phpunit.xml`, `../setup/.gitignore`
  - copy these into `simple-project` **once**. You will not touch them
  again for the rest of this track, even though later topics use tools
  they declare (`phpunit`, `phpcs`, `phpmd`, `phpcpd` are all listed in
  `composer.json` from this point on, ready for whichever topic first
  runs them).
- `code/app.php` - now 22 lines, `add` plus a new `isPrime` method.

## Execute Shell Command
Add this as a **new** step, placed **before** "PHP Syntax Check":

```bash
echo "== Stage: Composer Install =="
composer install --no-interaction --prefer-dist
```

## Guided Steps
1. If you haven't already, copy `../setup/composer.json`,
   `../setup/phpunit.xml`, and `../setup/.gitignore` into
   `simple-project`. This is the only time this track asks you to copy
   more than one file.
2. Copy this topic's `code/app.php` over your existing one. Commit and
   push everything together.
3. In the Jenkins job configuration, add the **Composer Install** step
   above and move it to run **first**, ahead of "PHP Syntax Check" from
   Topic 1.
4. Save, then push a trivial change (or click **Build Now**) to trigger
   a build. Watch `composer install` download a `vendor/` folder inside
   the workspace, then the syntax-check step still pass on the new,
   longer `app.php`.
5. `vendor/` is listed in `.gitignore` on purpose - it's derived from
   `composer.json`, not something you commit. Every build regenerates it
   from scratch, which is exactly what your new step does.

## Checkpoint
`composer.json`'s `require-dev` already lists `phpunit`, `phpcs`,
`phpmd`, and `phpcpd`, even though only Topic 3 will actually run the
first of them. What does `composer install` do differently the first
time it runs on a fresh checkout versus the tenth time, once `vendor/`
already has everything it needs?
