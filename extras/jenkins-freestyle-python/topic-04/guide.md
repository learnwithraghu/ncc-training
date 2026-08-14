# Topic 4: From Freestyle to Your First Jenkinsfile

**Time:** 20 minutes

## Goal
Same syntax-check command as Topic 1, but this time it lives as **code**,
checked into `/root/sample-config` alongside `app.py`, instead of typed
into a Freestyle job's configuration page. Create a Jenkins **Pipeline**
job that reads its instructions straight from the repo.

## Files Provided
- `code/app.py` - the clean, formatted version from the end of Topic 3
  (`add`, `is_prime`, `main()`).
- `code/Jenkinsfile` - one stage, `Syntax Check`, running the same
  `python3 -m py_compile app.py` command from Topic 1.

## Guided Steps
1. Copy both files into `/root/sample-config` and commit:
   ```bash
   cp code/app.py code/Jenkinsfile /root/sample-config/
   cd /root/sample-config && git add app.py Jenkinsfile && git commit -m "add Jenkinsfile"
   ```
2. From the Jenkins dashboard, **New Item** → name it e.g.
   `sample-config-pipeline` → **Pipeline** → OK. (Leave the Topic 1-3
   `sample-config-check` Freestyle job alone - this is a second, separate
   job.)
3. Scroll to the **Pipeline** section. Set **Definition** to **Pipeline
   script from SCM** (not "Pipeline script" - you want Jenkins to read
   the `Jenkinsfile` out of the repo, not out of a text box).
4. **SCM:** Git. **Repository URL:** `file:///root/sample-config`, same
   local URL as the Freestyle job. **Script Path:** leave it as
   `Jenkinsfile` (the default - that's the filename you just committed).
5. Save, then click **Build Now**. Open the console output: it should
   look a lot like Topic 1's, but notice the very first thing Jenkins
   does is check out the repo, then it finds and parses `Jenkinsfile`
   before running anything.
6. Prove the "code" part matters: open `Jenkinsfile` and change the
   `sh` command to add an extra `echo` line, e.g.
   ```groovy
   sh 'echo about to check syntax; python3 -m py_compile app.py'
   ```
   Commit it - **do not touch the job configuration at all**. Click
   **Build Now** again. The new `echo` shows up in the console output.
   The job's behavior changed because the repo changed, with zero clicks
   in Jenkins itself.
7. Revert that change and commit again, so the Jenkinsfile is back to
   just the syntax check.

## Guided Explanation
"Pipeline script from SCM" is what people mean by **pipeline as code**:
the build instructions are versioned, reviewed, and diffed exactly like
`app.py` is, in the same commit history, on the same branch. A Freestyle
job's configuration lives only inside Jenkins itself - there's no `git
log` for it. That difference is the whole reason Topics 4-7 exist: the
same lessons from Topics 1-3 (syntax check, then user input), but now as
something you can `git blame`.

## Checkpoint
The `sample-config-check` Freestyle job from Topics 1-3 still exists and
still works. What would you lose - or gain - by deleting it now that
`sample-config-pipeline` covers the same syntax check?
