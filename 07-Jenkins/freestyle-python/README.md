# Freestyle-to-Pipeline Track: One Python File, Growing

This is a third, separate Jenkins track from `guided-learning/` and
`kode-kloud/`. It assumes you are working in **your own lab**, where the
infrastructure already exists:

- Jenkins is already running (any way you like - Docker or bare metal).
- `/root/sample-config` already exists on the Jenkins host as a git
  repository (`git init` already run there, or about to be).
- Python 3 is already installed wherever the build runs. Topics 1-3 use
  **Execute Shell** build steps only (Freestyle jobs, no Docker, no
  Pipeline/Jenkinsfile); Topics 4-7 introduce a checked-in `Jenkinsfile`
  (Pipeline jobs) against the same repo.

None of that infrastructure is created by this folder.

## How This Track Works

There is **one file**, `app.py`, that grows a little at each topic - it
stays well under 30 lines the whole way through. That's the only thing
you copy into `/root/sample-config` at every topic. From Topic 4 onward, a
`Jenkinsfile` grows alongside it the same way.

Because there's no remote Gitea/GitHub in this lab, Jenkins reads
`/root/sample-config` straight off disk via a **local git URL**
(`file:///root/sample-config`) - a commit on that repo is what a build
picks up, there is nothing to push anywhere.

1. For each topic: open its `guide.md`, copy that topic's `code/*` into
   `/root/sample-config`, `git add` and `git commit`.
2. Topics 1-3: add/edit the job's **Execute Shell** build step(s) with
   that topic's command. Topics 4-7: the Jenkinsfile change *is* the
   job's new behavior - no job configuration needed after the initial
   setup in Topic 4.
3. Trigger a build. Read the console output.

## Topic List

| Topic | Folder | Focus | Job Type |
|-------|--------|-------|----------|
| Topic 01 | [topic-01/](topic-01/) | Syntax check | Freestyle / Execute Shell |
| Topic 02 | [topic-02/](topic-02/) | Build parameters (user input) | Freestyle / Execute Shell |
| Topic 03 | [topic-03/](topic-03/) | Style lint (`flake8`) | Freestyle / Execute Shell |
| Topic 04 | [topic-04/](topic-04/) | Freestyle → your first Jenkinsfile | Pipeline / SCM |
| Topic 05 | [topic-05/](topic-05/) | Multi-stage Jenkinsfile | Pipeline / SCM |
| Topic 06 | [topic-06/](topic-06/) | Parameters in a Jenkinsfile - and a trap | Pipeline / SCM |
| Topic 07 | [topic-07/](topic-07/) | The fix: `environment {}` + quoted `sh` | Pipeline / SCM |

## The Sample App

A tiny stdlib-only `app.py` (`add`, then `is_prime` + a command
dispatcher). No separate "broken" or "messy" files - each topic either
ships the file already in the state that topic needs (e.g. Topic 3 ships
it deliberately badly formatted) or has you break/fix it live in the
repo, the same file the whole way through.

## Guided Learning Focus

Topics 1-3 and 4-7 tell the same story twice, on purpose: syntax check,
then user input, first as Freestyle jobs configured by hand, then as a
Jenkinsfile checked into git. Topics 6-7 go one step further and use that
retelling to show that "quote your shell variables" (Topic 2) isn't
automatically true inside a Jenkinsfile - Groovy string interpolation
into an `sh` step is a different, and worse, mistake with its own fix.
