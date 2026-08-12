# KodeKloud Track: PHP CI, Stage by Stage

This is a second, separate Jenkins track from `guided-learning/`. It
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

None of that infrastructure is created by this folder - only the PHP code
and the shell commands you paste into **Execute Shell** build steps are.

## How This Track Works

Unlike `guided-learning/` (Docker-based, one throwaway job per topic),
this track builds **one job, incrementally**, across all six topics:

1. Open a topic's `guide.md`.
2. Copy that topic's `code/` files into your local `simple-project`
   folder (files accumulate - each topic ships the **full** set of files
   needed up to that point, so copying always leaves you in a consistent
   state).
3. Commit and push to `master` on Gitea.
4. Jenkins triggers automatically. Watch the build.
5. In the Jenkins job configuration, **add a new Execute Shell build
   step** with that topic's command (previous steps stay in place - you
   are growing one pipeline of shell steps, stage by stage, not
   replacing it).
6. Save the job, and either push a trivial change or click **Build Now**
   to see the new stage run.

## Topic List

| Topic | Folder | Stage | Tool |
|-------|--------|-------|------|
| Topic 01 | [topic-01/](topic-01/) | Syntax check | `php -l` |
| Topic 02 | [topic-02/](topic-02/) | Dependencies & autoloading | Composer |
| Topic 03 | [topic-03/](topic-03/) | Unit tests | PHPUnit |
| Topic 04 | [topic-04/](topic-04/) | Code style | PHP_CodeSniffer (PSR-12) |
| Topic 05 | [topic-05/](topic-05/) | Mess detection | PHPMD |
| Topic 06 | [topic-06/](topic-06/) | Copy-paste detection | PHPCPD |

## The Sample App

A tiny PHP `Calculator` class (`add`, `isPrime`, `fizzbuzz` - the same
three operations used in the Python app back in `guided-learning/`, on
purpose, so the CI *concepts* transfer even though the *tools* are
completely different per language). Each topic adds exactly one more file
or one more problem for that topic's tool to catch, on top of what came
before.

## Guided Learning Focus

Each topic's `code/` folder is a complete, drop-in snapshot of
`simple-project` at that stage - not a diff. If you fall behind or want
to jump straight to Topic 5, copy `topic-05/code/` in and you're caught
up.
