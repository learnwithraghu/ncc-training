# Topic 3: Style Lint With flake8

**Time:** 20 minutes

## Goal
Add a second **Execute Shell** step after the syntax check. Style
problems are legal Python (they compile fine), but `flake8` flags them as
warnings you can act on before they'd ever come up in code review.

## Files Provided
- `code/app.py` (clean) - same file as Topic 1/2.
- `code/messy.py` (compiles fine, but full of style problems: unused
  imports, no spaces around operators, an unused variable, a line far
  past 79 characters).

## Commands to Use
```bash
# one-time: give the Jenkins host/agent flake8
python3 -m pip install --user flake8
flake8 --version
```

## Execute Shell Command
Add this as a **new** step, placed **after** "Python Syntax Check":

```bash
echo "== Stage: Lint =="
flake8 app.py messy.py
```

## Guided Steps
1. Install `flake8` as shown above, wherever the job's Execute Shell
   steps actually run (the Jenkins agent/master itself, since this track
   doesn't use Docker).
2. Copy both files into `/root/sample-config` and commit:
   ```bash
   cp code/app.py code/messy.py /root/sample-config/
   cd /root/sample-config && git add app.py messy.py && git commit -m "add messy.py"
   ```
   Leave `broken.py` out this time - a syntax error would fail the first
   step before `flake8` ever runs.
3. On the `sample-config-check` job, add the **Lint** Execute Shell step
   above, after the existing "Python Syntax Check" step.
4. If Topic 2's `TARGET_FILE` parameter is still in place, either remove
   it for this topic or update the syntax-check step back to a fixed
   `python3 -m py_compile app.py` - this topic checks both files
   unconditionally.
5. Click **Build Now**. `Python Syntax Check` passes (both files compile),
   but `Lint` fails - read the `flake8` output: unused imports (`F401`),
   missing whitespace around operators (`E225`), an unused variable
   (`F841`), and a line-too-long error (`E501`).
6. Open `/root/sample-config/messy.py` and fix the issues one at a time,
   committing and rebuilding between fixes so you can see the warning
   count drop.
7. Once `messy.py` is clean, commit it and confirm the build goes green
   end to end.

## Guided Explanation
Syntax check and lint are separate steps on purpose: if the code doesn't
even parse, there's no point asking `flake8`'s opinion on its style.
Ordering steps from "fastest and most fundamental" to "slower and more
opinionated" is a common pattern for any CI job, freestyle or pipeline.

## Checkpoint
Why does the `Lint` step never get a chance to report anything for a
commit where `app.py` has a syntax error? What would you have to change
about how these two Execute Shell steps are configured to make `flake8`
still run and report its findings even when the syntax check fails?
