# Topic 9: Parameterized Pipelines

**Time:** 20 minutes

## Goal
Turn the hard-coded "check every file" pipeline into one that asks the
user which file to check, using a Jenkins **build parameter**.

## Files Provided
- `files/code/app.py`, `files/code/messy.py`, `files/code/broken.py` -
  drop all three onto `~/jenkins-code`.
- `files/Jenkinsfile` - declares a `choice` parameter, `TARGET_FILE`, and
  runs `Syntax Check` and `Lint` against only that file.

## Prerequisites
`python3`, `pip`, and `flake8` installed in the container (Topics 7-8).

## Guided Steps
1. Copy this topic's `files/code/*.py` onto `~/jenkins-code`.
2. Create a Pipeline job, e.g. `python-check-parameterized`, and paste in
   this topic's `files/Jenkinsfile`. Save it.
3. Notice the job page now shows **Build with Parameters** instead of
   plain **Build Now** - Jenkins read the `parameters { }` block and
   built a form for it.
4. Click **Build with Parameters**, choose `app.py`, and build. Both
   stages pass.
5. Build again with `messy.py` selected. `Syntax Check` passes, `Lint`
   fails - same behavior as Topic 8, but now driven by a dropdown instead
   of editing the Jenkinsfile.
6. Build again with `broken.py` selected. `Syntax Check` fails
   immediately, and `Lint` never runs.
7. Look at **Build History** in the left sidebar: each build is now
   labeled with the parameter value it ran with, so you can tell at a
   glance which file each red or green build was checking.

## Guided Explanation
A `choice` parameter is one of several Jenkins parameter types (`string`,
`booleanParam`, `text` are others). Parameters turn a pipeline from "one
fixed thing this job does" into "a tool a teammate can point at different
inputs" - the same Jenkinsfile, reused for `app.py` today and a file that
doesn't exist yet next week.

## Checkpoint
What would you change in the `Jenkinsfile` to let someone type an
arbitrary filename instead of picking from a fixed dropdown - which
parameter type would you use, and what's the tradeoff of allowing free
text here?
