# Topic 7: Fixing It - environment {} and Single-Quoted sh Steps

**Time:** 20 minutes

## Goal
Fix Topic 6's injection properly: move the parameter into an
`environment { }` block, then reference it inside a **single-quoted**
`sh` step so the shell - not Groovy - does the substitution. That's
exactly the point where Topic 2's quoting lesson becomes relevant again.

## Files Provided
- `code/app.py` - unchanged.
- `code/Jenkinsfile` - `choice` parameter, `environment { COMMAND =
  "${params.COMMAND}" }`, and a `Run` stage using `sh 'python3 app.py
  "$COMMAND" 2 3'` (single-quoted).

## Guided Steps
1. Copy both files into `/root/sample-config` and commit:
   ```bash
   cp code/app.py code/Jenkinsfile /root/sample-config/
   cd /root/sample-config && git add app.py Jenkinsfile && git commit -m "fix Run stage: environment block + quoted sh"
   ```
2. On `sample-config-pipeline`, click **Build with Parameters**, choose
   `add`, build. Console output shows `5`, same result as Topic 6 - the
   fix doesn't change legitimate behavior at all.
3. Compare the two lines side by side:
   - Topic 6 (vulnerable): `sh "python3 app.py ${params.COMMAND} 2 3"`
   - Topic 7 (fixed): `sh 'python3 app.py "$COMMAND" 2 3'`

   The outer quote changed from `"` to `'`. A single-quoted Groovy string
   is **literal** - Groovy performs no substitution on it at all, so
   `$COMMAND` reaches the shell untouched, exactly as written. The shell
   is what expands `$COMMAND`, and because it's inside double quotes
   *in the shell's own syntax*, the shell treats whatever value it holds
   as one argument - the same protection Topic 2 relied on.
4. Try to break it the same way as Topic 6: temporarily switch `COMMAND`
   to a `string` parameter, build with `add 2 3; whoami #` again.
5. Read the console output. This time the whole string is passed to
   `app.py` as a single (nonsensical) argument - `main()` doesn't match
   either branch, nothing prints, and `whoami` never runs. The
   `environment { }` block still uses `"${params.COMMAND}"` to *set*
   `COMMAND`'s value, but setting a variable's text is harmless; the
   danger in Topic 6 was specifically handing Groovy-interpolated text to
   `sh` as script source.
6. Revert `COMMAND` back to the `choice` parameter and commit, so both
   defenses - environment block + shell quoting, and a fixed allowlist -
   are back in place together.

## Guided Explanation
Two independent fixes stack here: the **environment block** keeps
parameter substitution at the Groovy layer confined to *setting a
variable*, never to *building a command string*; **shell quoting**
(`"$COMMAND"`) then does the same job it did in Topic 2, once the value
finally reaches the shell as an actual shell variable instead of literal
script text. Neither one alone is a complete story - a Groovy interpolated
string with no shell involved at all can still be dangerous elsewhere
(e.g., in a `groovy.lang.GString` used to build a filename), and shell
quoting means nothing if the value was already baked into the script.
Knowing *which layer* a piece of user input is crossing - Groovy vs.
shell - is the actual skill this pair of topics was building toward.

## Checkpoint
This module has now shown the same category of bug twice: an unquoted
`$COMMAND` in a shell script (Topic 2), and an interpolated
`${params.COMMAND}` in a Groovy string handed to `sh` (Topic 6). If you
had to explain the common thread to a teammate in one sentence - what
makes both of these "the same mistake" despite looking so different in
the two Jenkinsfiles?
