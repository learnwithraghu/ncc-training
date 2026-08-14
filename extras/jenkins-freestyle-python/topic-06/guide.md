# Topic 6: Parameters in a Jenkinsfile - and a Trap

**Time:** 20 minutes

## Goal
Bring Topic 2's user-input idea into the Jenkinsfile with a declarative
`parameters { }` block, add a `Run` stage that uses it - and then see why
the *shape* of that stage is a much worse mistake than Topic 2's unquoted
shell variable ever was.

## Files Provided
- `code/app.py` - unchanged.
- `code/Jenkinsfile` - adds a `choice` parameter, `COMMAND`, and a `Run`
  stage. **This `Jenkinsfile` is intentionally vulnerable** - that's the
  point of this topic. Do not copy this pattern into anything real.

## Guided Steps
1. Copy both files into `/root/sample-config` and commit:
   ```bash
   cp code/app.py code/Jenkinsfile /root/sample-config/
   cd /root/sample-config && git add app.py Jenkinsfile && git commit -m "add parameters + Run stage"
   ```
2. On `sample-config-pipeline`, click **Configure**, save without
   changing anything (this refreshes the job so it notices the new
   `parameters { }` block), then go back to the job page. It now offers
   **Build with Parameters**.
3. Click it, choose `add`, build. Console output shows `5`, same as
   Topic 2's Freestyle version.
4. Look closely at the `Run` stage in `Jenkinsfile`:
   ```groovy
   sh "python3 app.py ${params.COMMAND} 2 3"
   ```
   This is a **double-quoted Groovy string**. Groovy substitutes
   `${params.COMMAND}` into the string *before* the `sh` step ever hands
   anything to a shell - the shell receives the finished text as literal
   script, not as a variable it substitutes itself. That's a completely
   different (and worse) mechanism than Topic 2's `$COMMAND` inside a
   shell script.
5. Prove it. In the Jenkins job configuration, change `COMMAND` from a
   `choice` parameter to a `string` parameter in `Jenkinsfile` (edit the
   file, don't reconfigure the job):
   ```groovy
   parameters {
       string(name: 'COMMAND', defaultValue: 'add', description: 'Which app.py command to run')
   }
   ```
   Commit, then on the job page click **Build with Parameters** and enter
   this for `COMMAND`:
   ```
   add 2 3; whoami #
   ```
6. Build it. Read the console output: `whoami`'s output appears in the
   log. Unlike Topic 2, **there was no unquoted shell variable to blame**
   - the injected text was assembled by Groovy into the pipeline's
   *script itself* before the shell even started. Quoting `${params.COMMAND}`
   with extra `"` characters inside the Groovy string would not have
   helped; the substitution happens at the wrong layer entirely.
7. Revert `Jenkinsfile` back to the `choice` parameter version from step
   1 and commit. With `choice`, the dropdown is a fixed allowlist, so
   this particular hole is unreachable through the UI - but the `Run`
   stage's *code* is still written the dangerous way, waiting for the
   next person who "just needs a quick string param."

## Guided Explanation
Topic 2 taught "quote your shell variables." This topic shows that lesson
doesn't transfer directly to Jenkinsfiles: a double-quoted Groovy string
that interpolates `params.X` (or `env.X`) directly into an `sh` step's
script text hands an attacker-controlled value straight to Groovy's
string builder, with the result fed to the shell as trusted code. This is
one of the most common real-world Jenkins pipeline security mistakes -
Topic 7 fixes it properly.

## Checkpoint
The `choice` parameter made this specific attack unreachable through the
Jenkins UI. Does that mean the `Run` stage's `sh "...${params.COMMAND}..."`
line is now safe to leave as-is? What's still wrong with it, independent
of which parameter type is configured today?
