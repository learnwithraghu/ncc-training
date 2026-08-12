# Topic 2: Build Parameters (User Input)

**Time:** 20 minutes

## Goal
Turn the hard-coded "always check `app.py`" job into one that asks the
user which file to check, using a Jenkins **build parameter** - and see
firsthand why the parameter *type* you pick matters for more than
convenience.

## Files Provided
- `code/app.py` (valid), `code/broken.py` (syntax error) - same pair as
  Topic 1, duplicated here on purpose so this topic is self-contained.

## Guided Steps

### Part A - a safe parameter
1. Copy both files into `/root/sample-config` and commit:
   ```bash
   cp code/app.py code/broken.py /root/sample-config/
   cd /root/sample-config && git add app.py broken.py && git commit -m "add broken.py"
   ```
2. Open the `sample-config-check` job (from Topic 1) → **Configure**.
3. Check **This project is parameterized** → **Add Parameter** → **Choice
   Parameter**.
   - **Name:** `TARGET_FILE`
   - **Choices:** one per line -
     ```
     app.py
     broken.py
     ```
4. Update the **Execute Shell** step to use it, keeping the variable
   **quoted**:
   ```bash
   echo "== Stage: Python Syntax Check =="
   python3 -m py_compile "$TARGET_FILE"
   ```
5. Save. The job page now shows **Build with Parameters** instead of
   plain **Build Now**.
6. Click **Build with Parameters**, choose `app.py`, build → green.
   Build again with `broken.py` → red, same `SyntaxError` as Topic 1, now
   driven by a dropdown instead of editing files by hand.
7. Look at **Build History**: each build is labeled with the parameter
   value it ran with, so you can tell at a glance which file a given red
   or green build checked.

### Part B - why the parameter type matters
A **Choice** parameter can only ever be one of the values you listed - the
dropdown *is* the allowlist. A **String** parameter accepts anything the
person clicking "Build" types, and that text lands in your shell command.
See what that means in practice:

8. On the job, temporarily change `TARGET_FILE` from a Choice Parameter
   to a **String Parameter** (same name, no default value needed).
9. Save, click **Build with Parameters**, and for `TARGET_FILE` enter:
   ```
   app.py; whoami; echo done
   ```
10. Build it. Read the console output: `python3 -m py_compile` errors out
    on `app.py; whoami; echo done` as a filename (there's no space
    escaping happening) - but if you unquote the variable in the shell
    step (`python3 -m py_compile $TARGET_FILE`, no quotes) and rebuild
    with the same input, the shell instead splits it into three
    commands, and `whoami`'s output shows up in the console log even
    though it was never part of the intended command.
11. Put the quotes back (`"$TARGET_FILE"`) and switch the parameter back
    to **Choice Parameter** with the original two values. Rebuild once
    more with `app.py` to confirm you're back to a clean, safe state.

## Guided Explanation
Quoting (`"$TARGET_FILE"`) stops a value like `app.py; whoami` from being
*split* by the shell into multiple arguments or commands - it's necessary
hygiene any time a shell variable holds user input. But quoting alone
doesn't stop someone from pointing the build at a file that legitimately
exists elsewhere on disk (`../../etc/passwd`, say) - only a **Choice**
parameter's fixed allowlist prevents that, because the job simply refuses
to run with a value that isn't one of the ones you listed. Prefer Choice
(or a validated pattern) over free-text String whenever the set of valid
inputs is small and known ahead of time, which is exactly the case for
"which file in this repo do you want checked."

## Checkpoint
Quoting stopped the shell from splitting `app.py; whoami` into separate
commands. Would quoting alone have stopped a `TARGET_FILE` value of
`/etc/passwd` from being passed straight to `py_compile`? What's the
difference between a problem quoting solves and one only an allowlist
(Choice parameter) solves?
