# KodeKloud Track: PHP CI, Stage by Stage

This is an optional Jenkins track, separate from the bootcamp path in
[`07-Jenkins/guided-learning/`](../../07-Jenkins/guided-learning/). It
assumes you are working in a **KodeKloud-style lab** where the
infrastructure already exists:

- A Jenkins UI is already running.
- A Gitea account/server is already running, with a repo you push to
  (referred to below as `simple-project`).
- A Jenkins **Freestyle** job already exists for `simple-project`, with a
  build trigger configured so a push to `master` on Gitea fires a build
  (via webhook or SCM polling - already set up).
- PHP and Composer are already installed wherever the build runs (the
  Jenkins agent/master itself, since this track uses **Execute Shell**
  build steps only - no Docker, no Pipeline/Jenkinsfile).

None of that infrastructure is created by this folder.

## How This Track Works

The whole app is **one file**, `app.php`, that grows a little at each
topic - it never exceeds ~45 lines. That's the only thing you copy and
push at every topic. Everything else (`composer.json`, `phpunit.xml`,
`.gitignore`) is set up **once**, in `setup/`, before Topic 1, and never
touched again.

1. **Do this once, before Topic 1:** copy `setup/composer.json`,
   `setup/phpunit.xml`, and `setup/.gitignore` into your local
   `simple-project` folder. Commit and push.
2. For each topic: open its `guide.md`, copy that topic's single
   `code/app.php` over your existing one, commit, push.
3. Jenkins triggers automatically. Watch the build.
4. In the Jenkins job configuration, **add a new Execute Shell build
   step** with that topic's command (previous steps stay in place - one
   growing job, not a new one each time).
5. Save, and either push a trivial change or click **Build Now** to see
   the new stage run.

## Topic List

| Topic | Folder | Stage | Tool |
|-------|--------|-------|------|
| Topic 01 | [topic-01/](topic-01/) | Syntax check | `php -l` |
| Topic 02 | [topic-02/](topic-02/) | Dependencies (Composer install) | Composer |
| Topic 03 | [topic-03/](topic-03/) | Unit tests | PHPUnit |
| Topic 04 | [topic-04/](topic-04/) | Code style | PHP_CodeSniffer (PSR-12) |
| Topic 05 | [topic-05/](topic-05/) | Mess detection | PHPMD |
| Topic 06 | [topic-06/](topic-06/) | Copy-paste detection | PHPCPD |

## The Sample App

One `Calculator` class (`add`, `isPrime`) plus its own `CalculatorTest`
class, both living in `app.php`. Each topic changes that single file just
enough for that stage's tool to have something new to say about it - a
bad format, an unused parameter, a copy-pasted method - and the guide
walks you through fixing it before moving on.

## Guided Learning Focus

Because everything lives in one file, there's nothing to "fall behind
on." If you want to jump straight to Topic 5, copy `topic-05/code/app.php`
in (assuming `setup/` was already done once) and you're caught up.
