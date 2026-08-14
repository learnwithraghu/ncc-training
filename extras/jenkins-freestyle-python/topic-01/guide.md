# Topic 1: Python Syntax Check

**Time:** 20 minutes

## Goal
Get the very first CI stage working against your own lab: commit a tiny
Python file into the local git repo at `/root/sample-config`, point a
Jenkins **Freestyle** job at it, and have a single **Execute Shell** build
step fail the build the moment `app.py` doesn't parse.

## File Provided
`code/app.py` - 10 lines, one `add` function plus a `sys.argv` CLI. This
is the whole app for this track - it grows a little at each topic, the
same file the whole way through, never swapped out for a different one.

## Execute Shell Command
Add this as the job's first **Execute Shell** build step:

```bash
echo "== Stage: Python Syntax Check =="
python3 -m py_compile app.py
```

## Guided Steps
1. On the Jenkins host, confirm `/root/sample-config` is a git repo:
   ```bash
   cd /root/sample-config && git status
   ```
   If it says "not a git repository," run `git init` there first (and
   `git config user.email "you@example.com"` / `git config user.name
   "you"` if this is a fresh box - commits need an identity).
2. Copy this topic's `code/app.py` into `/root/sample-config`. Commit it:
   ```bash
   cp code/app.py /root/sample-config/app.py
   cd /root/sample-config && git add app.py && git commit -m "add app.py"
   ```
3. From the Jenkins dashboard, **New Item** → name it e.g.
   `sample-config-check` → **Freestyle project** → OK.
4. Under **Source Code Management**, select **Git** and set
   **Repository URL** to `file:///root/sample-config` (a local git URL -
   there's no remote, Jenkins just reads the repo straight off disk).
   Leave the branch as whatever `git branch --show-current` reports
   (commonly `master` or `main` depending on your git version's default).
5. Under **Build Steps**, **Add build step** → **Execute Shell**, and
   paste the command above. Save.
6. Click **Build Now**. It should be **green** - `app.py` compiles fine.
7. Now break it on purpose, directly in the repo:
   ```bash
   cd /root/sample-config
   ```
   Open `app.py` and delete the colon at the end of `def add(a, b):`, so
   the line reads `def add(a, b)`. Commit:
   ```bash
   git commit -am "break app.py on purpose"
   ```
8. Click **Build Now** again. Watch the build go **red**. Open the
   console output and find the exact line `py_compile` reports the
   `SyntaxError` on.
9. Put the colon back, commit again, and confirm the build is green:
   ```bash
   git commit -am "fix app.py"
   ```
   Click **Build Now** to confirm.

## Guided Explanation
`python3 -m py_compile` only parses the file - it does not run it or
check its style. That boundary matters: a syntax-check stage is cheap and
should run first, before anything slower gets a chance to waste time on
code that can't even be imported. Because the job pulls from a **local**
git URL, every build is really re-reading whatever you last committed at
`/root/sample-config` - there is no push step in this lab, just commit
and build.

## Checkpoint
`app.py` is going to keep growing over the next few topics, all inside
this same file and this same repo. Why does that matter more for a real
project than it did for a one-off script - what goes wrong if every
topic instead shipped an unrelated, disconnected example file?
