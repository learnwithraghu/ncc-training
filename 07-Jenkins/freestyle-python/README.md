# Freestyle Track: Python CI Against a Local Git Repo

This is a third, separate Jenkins track from `guided-learning/` and
`kode-kloud/`. It assumes you are working in **your own lab**, where the
infrastructure already exists:

- Jenkins is already running (any way you like - Docker or bare metal).
- `/root/sample-config` already exists on the Jenkins host as a git
  repository (`git init` already run there, or about to be).
- Python 3 is already installed wherever the build runs (this track uses
  **Execute Shell** build steps only - no Docker, no Pipeline/Jenkinsfile).

None of that infrastructure is created by this folder.

## How This Track Works

Unlike `kode-kloud/` (one file that grows across every topic), each topic
here is **self-contained**: it ships its own complete copy of whatever
`.py` files it needs under `code/`, even when that duplicates a file from
an earlier topic. Start at any topic without hunting for leftovers from a
previous one.

Because there's no remote Gitea/GitHub in this lab, Jenkins reads
`/root/sample-config` straight off disk via a **local git URL**
(`file:///root/sample-config`) - a commit on that repo is what a build
picks up, there is nothing to push anywhere.

1. For each topic: open its `guide.md`, copy that topic's `code/*.py`
   into `/root/sample-config`, `git add` and `git commit`.
2. In the Jenkins job configuration, add (or edit) the **Execute Shell**
   build step with that topic's command.
3. Save, then click **Build Now**. Read the console output.

## Topic List

| Topic | Folder | Focus | Tool |
|-------|--------|-------|------|
| Topic 01 | [topic-01/](topic-01/) | Syntax check | `python3 -m py_compile` |
| Topic 02 | [topic-02/](topic-02/) | Build parameters (user input) | Jenkins Choice/String params |
| Topic 03 | [topic-03/](topic-03/) | Style lint | `flake8` |

## The Sample App

A tiny stdlib-only `app.py` (`add`, `is_prime`), the same shape used
elsewhere in this module, plus a deliberately broken copy (`broken.py`,
syntax error) and a deliberately messy copy (`messy.py`, style problems
only) to prove each stage actually catches what it claims to.

## Guided Learning Focus

This track exists to grow with the lab - it currently only covers a
syntax-check stage and taking user input via build parameters, on
purpose. Add topics the same way `guided-learning/` and `kode-kloud/` did:
one focused Execute Shell step at a time, each with its own self-contained
`code/`.
