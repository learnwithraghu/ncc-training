# Topic 8: Linting With flake8

**Time:** 20 minutes

## Goal
Add a **Lint** stage after the syntax check. Style problems are legal
Python (they compile fine) but flake8 flags them as warnings you can act
on before you'd ever notice them in code review.

## Files Provided
- `files/code/app.py` (clean), `files/code/messy.py` (compiles fine, but
  full of style problems: unused imports, no spaces around operators, an
  unused variable, a line far past 79 characters).
- `files/Jenkinsfile` - `Syntax Check` stage (from Topic 7) followed by a
  new `Lint` stage.

## Commands to Use
```bash
docker exec -u root jenkins bash -c "apt-get update && apt-get install -y python3 python3-pip"
docker exec -u root jenkins pip install --break-system-packages flake8
docker exec jenkins flake8 --version
```

## Guided Steps
1. Install `flake8` inside the container as shown above (in addition to
   `python3` from Topic 7 - repeat that install too if you're on a fresh
   container).
2. Copy `files/code/app.py` and `files/code/messy.py` onto
   `~/jenkins-code` on the host. Leave `broken.py` out this time - a
   syntax error would fail the pipeline before the `Lint` stage ever
   runs.
3. Create a Pipeline job, e.g. `python-lint`, and paste in this topic's
   `files/Jenkinsfile`.
4. Click **Build Now**. `Syntax Check` passes (both files compile), but
   `Lint` fails - read the flake8 output: unused imports (`F401`),
   missing whitespace around operators (`E225`), an unused variable
   (`F841`), and a line-too-long error (`E501`).
5. Open `messy.py` on the host and fix the issues flake8 reported one at
   a time, rebuilding between fixes so you can see the warning count drop.
6. Once `messy.py` is clean, the build goes green end to end.

## Guided Explanation
`Syntax Check` and `Lint` are separate stages on purpose: if the code
doesn't even parse, there is no point asking flake8's opinion on its
style. Ordering stages from "fastest and most fundamental" to "slower and
more opinionated" is a common Jenkins pipeline pattern, and it's why
Topic 10 will put unit tests *after* both of these.

## Checkpoint
Why does the `Lint` stage never run for a build where `broken.py` is
present in `~/jenkins-code`?
