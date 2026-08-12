# Topic 3: Style Lint With flake8

**Time:** 20 minutes

## Goal
Add a third **Execute Shell** step. `app.py` still parses fine and still
runs correctly - this topic's copy only violates PEP 8 style, and this is
the first stage that has any reason to care.

## File Provided
`code/app.py` - same `add`, `is_prime`, and `main()` as Topic 2, but
reformatted badly on purpose: no spaces around commas or operators,
missing blank lines between functions, and an unused `import os`.

## Commands to Use
```bash
# one-time: give the Jenkins host/agent flake8
python3 -m pip install --user flake8
flake8 --version
```

## Execute Shell Command
Add this as a **new** step, after "Python Syntax Check" and before "Run":

```bash
echo "== Stage: Lint =="
flake8 app.py
```

## Guided Steps
1. Install `flake8` as shown above, wherever the job's Execute Shell
   steps actually run (the Jenkins agent/master itself, since this track
   doesn't use Docker).
2. Copy this topic's `code/app.py` over your existing one and commit:
   ```bash
   cp code/app.py /root/sample-config/app.py
   cd /root/sample-config && git add app.py && git commit -m "reformat app.py badly (on purpose)"
   ```
3. Add the **Lint** step above to the `sample-config-check` job, between
   "Python Syntax Check" and "Run". Save.
4. If Topic 2's `COMMAND` parameter is still a Choice Parameter, leave it
   as-is - it doesn't interfere with this step.
5. Click **Build with Parameters** (choose either command). "Python
   Syntax Check" passes - the file is valid, working Python. "Lint"
   fails - read the `flake8` report: an unused import (`F401`), missing
   whitespace around operators and after commas (`E225`/`E231`), and
   missing blank lines between top-level functions (`E302`).
6. Open `/root/sample-config/app.py` and fix the issues one at a time -
   remove `import os`, add spaces around `,`/`+`/`<`/`%`/`**`/`==`, and a
   blank line before each `def` - committing and rebuilding between fixes
   so you can watch the warning count in the `flake8` report go down.
7. Once clean, "Run" still works exactly as it did in Topic 2 - style
   fixes didn't change behavior, only how the source reads.

## Guided Explanation
Syntax check and lint are separate steps on purpose: if the code doesn't
even parse, there's no point asking `flake8`'s opinion on its style.
Ordering steps from "fastest and most fundamental" to "slower and more
opinionated" is a common pattern for any CI job, Freestyle or Pipeline -
exactly the order you'll see again in Topic 5's Jenkinsfile.

## Checkpoint
Why does the `Lint` step never get a chance to report anything for a
commit where `app.py` has a syntax error? What would you have to change
about how these Execute Shell steps are configured to make `flake8` still
run and report its findings even when the syntax check fails?
