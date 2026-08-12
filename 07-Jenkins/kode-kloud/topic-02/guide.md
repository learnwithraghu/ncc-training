# Topic 2: Dependencies & Autoloading With Composer

**Time:** 20 minutes

## Goal
Introduce Composer, restructure the app into a proper `src/` folder with
PSR-4 autoloading, and add a second **Execute Shell** build step that
installs dependencies before anything else runs.

## Files Provided
`code/composer.json`, `code/.gitignore`, `code/src/Calculator.php` (now a
real class, `App\Calculator`), `code/index.php` (now uses the Composer
autoloader). `Calculator.php` moved from the project root into `src/` -
remove the old root-level copy from Topic 1 when you copy these in.

## Execute Shell Command
Add this as a **new** build step, placed **before** the syntax-check step
from Topic 1 (drag it to the top in the job's build-step list):

```bash
echo "== Stage: Composer Install =="
composer install --no-interaction --prefer-dist

echo "== Stage: Verify Autoloading =="
php -r "require 'vendor/autoload.php'; \$c = new App\Calculator(); echo \$c->fizzbuzz(15) . PHP_EOL;"
```

## Guided Steps
1. Delete `Calculator.php` from the project root and `broken.php` from
   Topic 1 (keep it around locally if you want, but don't push it - a
   syntax error would fail the *new* Composer step's autoload check too,
   for a confusing reason).
2. Copy `code/composer.json`, `code/.gitignore`, `code/src/Calculator.php`,
   and `code/index.php` into `simple-project`. Commit and push.
3. In the Jenkins job configuration, add the **Composer Install** step
   above and move it to run **first**, ahead of the "PHP Syntax Check"
   step from Topic 1. Order matters: linting `vendor/` files you haven't
   installed yet wastes time, and `vendor/` is already excluded from that
   step's `find`, so this reordering is really just about keeping "set
   up dependencies" conceptually first.
4. Save, then push a trivial change (or click **Build Now**) to trigger a
   build. Watch `composer install` download to a `vendor/` folder inside
   the workspace and the syntax-check step still pass afterward.
5. Read `composer.json`'s `autoload.psr-4` block:
   `"App\\": "src/"` tells Composer's generated autoloader that any class
   in namespace `App\` lives under `src/`, one directory per namespace
   segment. That's why `App\Calculator` resolves to `src/Calculator.php`
   with zero `require` statements for it in `index.php`.
6. `vendor/` is listed in `.gitignore` on purpose - it's derived from
   `composer.json`/`composer.lock`, not something you commit. Every build
   regenerates it from scratch via `composer install`, which is exactly
   what your new Execute Shell step does.

## Checkpoint
`composer.json` pins `"php": ">=8.1"` under `require`. What happens to
the `composer install` step (not `php -l`) if the Jenkins agent has an
older PHP than that - and why is that a useful failure to get at this
stage rather than three stages later?
