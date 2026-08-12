# Topic 2: Build Parameters (User Input)

**Time:** 20 minutes

## Goal
`app.py` grows a second function, `is_prime`, and a tiny command
dispatcher. Turn the job from "always run whatever's hard-coded" into one
that asks the user which command to run, using a Jenkins **build
parameter** - and see firsthand why the parameter *type* you pick matters
for more than convenience.

## File Provided
`code/app.py` - now 27 lines: `add` from Topic 1, plus `is_prime` and a
`main()` that dispatches on `sys.argv[1]` (`add` or `is_prime`).

## Guided Steps

### Part A - a safe parameter
1. Copy this topic's `code/app.py` over your existing one and commit:
   ```bash
   cp code/app.py /root/sample-config/app.py
   cd /root/sample-config && git add app.py && git commit -m "add is_prime + command dispatcher"
   ```
2. Open the `sample-config-check` job (from Topic 1) → **Configure**.
3. Check **This project is parameterized** → **Add Parameter** → **Choice
   Parameter**.
   - **Name:** `COMMAND`
   - **Choices:** one per line -
     ```
     add
     is_prime
     ```
4. Add a **second** Execute Shell step, after the syntax check, that
   actually runs the command - keeping the variable **quoted**:
   ```bash
   echo "== Stage: Run =="
   python3 app.py "$COMMAND" 2 3
   ```
5. Save. The job page now shows **Build with Parameters** instead of
   plain **Build Now**.
6. Click **Build with Parameters**, choose `add`, build → console output
   shows `5`. Build again with `is_prime` → console output shows `True`
   (`is_prime(2)` - the second argument, `3`, is simply ignored by that
   branch).
7. Look at **Build History**: each build is labeled with the parameter
   value it ran with, so you can tell at a glance which command a given
   build ran.

### Part B - why the parameter type matters
A **Choice** parameter can only ever be one of the values you listed - the
dropdown *is* the allowlist. A **String** parameter accepts anything the
person clicking "Build" types, and that text lands in your shell command.
See what that means in practice:

8. On the job, temporarily change `COMMAND` from a Choice Parameter to a
   **String Parameter** (same name, no default value needed).
9. Save, click **Build with Parameters**, and for `COMMAND` enter:
   ```
   add; whoami; echo done
   ```
10. Build it. Read the console output: with the shell step **quoted**
    (`"$COMMAND"`), the whole string - including the semicolons - is
    passed to `app.py` as a single argument, and Python's `main()`
    rejects it (`command == "add; whoami; echo done"` matches neither
    branch, nothing prints). Now edit the shell step to drop the quotes
    (`python3 app.py $COMMAND 2 3`) and rebuild with the same input:
    the shell instead splits it into three separate commands, and
    `whoami`'s output shows up in the console log even though it was
    never part of the intended command.
11. Put the quotes back (`"$COMMAND"`) and switch the parameter back to
    **Choice Parameter** with the original two values. Rebuild once more
    with `add` to confirm you're back to a clean, safe state.

## Guided Explanation
Quoting (`"$COMMAND"`) stops a value like `add; whoami` from being
*split* by the shell into multiple arguments or commands - it's necessary
hygiene any time a shell variable holds user input. But quoting alone
doesn't stop someone from legitimately being a valid-looking-but-wrong
value - only a **Choice** parameter's fixed allowlist prevents that,
because the job simply refuses to run with a value that isn't one of the
ones you listed. Prefer Choice (or a validated pattern) over free-text
String whenever the set of valid inputs is small and known ahead of time,
which is exactly the case here.

## Checkpoint
Quoting stopped the shell from splitting `add; whoami` into separate
commands. What's the difference between a problem quoting solves and one
only an allowlist (Choice parameter) solves? Keep this pair of fixes in
mind - Topic 6 revisits the exact same question inside a Jenkinsfile,
where it turns out quoting alone isn't even enough.
