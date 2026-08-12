# Topic 1: Python Syntax Check

**Time:** 20 minutes

## Goal
Get the very first CI stage working against your own lab: commit Python
code into the local git repo at `/root/sample-config`, point a Jenkins
**Freestyle** job at it, and have a single **Execute Shell** build step
fail the build the moment `app.py` doesn't parse.

## Files Provided
- `code/app.py` - valid, stdlib-only, `add` and `is_prime`.
- `code/broken.py` - a real syntax error (missing colon), used to prove
  the stage actually fails builds.

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
7. Now break it on purpose:
   ```bash
   cp code/broken.py /root/sample-config/app.py
   cd /root/sample-config && git add app.py && git commit -m "break app.py"
   ```
8. Click **Build Now** again. Watch the build go **red**. Open the
   console output and find the exact line `py_compile` reports the
   `SyntaxError` on.
9. Restore the good copy and confirm green again:
   ```bash
   cp code/app.py /root/sample-config/app.py
   cd /root/sample-config && git add app.py && git commit -m "fix app.py"
   ```
   Click **Build Now**, confirm the build is green.

## Guided Explanation
`python3 -m py_compile` only parses the file - it does not run it or
check its style. That boundary matters: a syntax-check stage is cheap and
should run first, before anything slower gets a chance to waste time on
code that can't even be imported. Because the job pulls from a **local**
git URL, every build is really re-reading whatever you last committed at
`/root/sample-config` - there is no push step in this lab, just commit
and build.

## Checkpoint
The Execute Shell step ran `python3 -m py_compile app.py` with a
hard-coded filename. What happens to this build the day someone adds a
second `.py` file to `/root/sample-config` that also has a syntax error -
does this stage catch it? What would you change in the shell step so it
checks every `.py` file in the repo, not just one hard-coded name?
