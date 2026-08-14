# Topic 5: A Multi-Stage Jenkinsfile

**Time:** 20 minutes

## Goal
Add the `Lint` stage from Topic 3 into the Jenkinsfile, right after
`Syntax Check` - the same two commands, now chained together as code
instead of two separately-configured Execute Shell steps.

## Files Provided
- `code/app.py` - unchanged from Topic 4 (clean, formatted).
- `code/Jenkinsfile` - `Syntax Check` (Topic 4) followed by a new `Lint`
  stage running `flake8 app.py`.

## Guided Steps
1. Copy both files into `/root/sample-config` and commit:
   ```bash
   cp code/app.py code/Jenkinsfile /root/sample-config/
   cd /root/sample-config && git add app.py Jenkinsfile && git commit -m "add Lint stage to Jenkinsfile"
   ```
2. On `sample-config-pipeline`, click **Build Now**. No job
   configuration to touch - the new stage exists purely because it's now
   in `Jenkinsfile`.
3. Open the build. The **Stage View** (or, on older Jenkins, the
   left-hand pipeline graph) now shows two boxes, `Syntax Check` then
   `Lint`, each colored by its own result.
4. Both should be green - `app.py` is already clean. If you want to see
   `Lint` fail, temporarily reintroduce one of Topic 3's style problems
   (drop a space around an operator, say), commit, rebuild, and watch
   only the `Lint` box go red while `Syntax Check` stays green. Revert
   when you're done.
5. Notice the stage **order** in the file is the run order: `flake8`
   never runs before `py_compile` because that's the order the `stages {
   }` block lists them in - nothing implicit about it.

## Guided Explanation
This is the same "fail fast, cheap checks first" idea from Topic 3, just
expressed differently: in a Freestyle job the order was "whichever
Execute Shell step is listed first in the UI"; in a Jenkinsfile it's
"whichever `stage { }` block appears first in the file," which is far
easier to review in a pull request than a list of build steps buried in
job configuration.

## Checkpoint
If `Syntax Check` fails, Jenkins skips `Lint` entirely by default. Where
does that behavior actually come from - is it something declared
explicitly in this `Jenkinsfile`, or a default Jenkins applies unless you
tell it otherwise?
