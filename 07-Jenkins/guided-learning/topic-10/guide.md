# Topic 10: Unit Tests With pytest + JUnit Reports

**Time:** 20 minutes

## Goal
Add a real test stage: run `pytest` against `test_app.py`, produce a
JUnit-format XML report, and have Jenkins parse it into a visual pass/fail
breakdown per test.

## Files Provided
- `files/code/app.py`, `files/code/test_app.py`, `files/code/requirements.txt`
- `files/Jenkinsfile` - `Syntax Check` stage, then a `Unit Tests` stage
  that runs `pytest --junitxml=...` and publishes it with the `junit`
  step.

## Commands to Use
```bash
docker exec -u root jenkins pip install --break-system-packages pytest
docker exec jenkins python3 -m pytest --version
```

## Guided Steps
1. Install `pytest` in the container (in addition to `python3` from
   Topic 7).
2. Copy this topic's `files/code/*` onto `~/jenkins-code`.
3. Create a Pipeline job, e.g. `python-unit-tests`, paste in this topic's
   `files/Jenkinsfile`, and save.
4. Click **Build Now**. Read the `Unit Tests` console output: pytest
   lists each test function in `test_app.py` with pass/fail.
5. Open the finished build page. You'll see a **Test Result** link with a
   pass count - click it to see each test broken out individually,
   generated from the `results.xml` the `junit` step parsed.
6. Notice the `Jenkinsfile` writes the XML report to
   `${WORKSPACE}/reports/results.xml`, **not** into
   `/var/jenkins_code`. The pipeline's own workspace (managed by Jenkins,
   one per job) is where build **outputs** belong; the bind-mounted
   `/var/jenkins_code` is where your **source** lives. Keeping those
   separate is why the `junit` step can find the report using a path
   relative to the workspace.
7. Break a test on purpose - edit `test_app.py` on the host so
   `test_fizzbuzz` asserts the wrong value - and rebuild. The stage still
   completes (pytest ran and produced a report) but the build goes red
   and the Test Result trend shows one failure.

## Checkpoint
Why does the `Unit Tests` stage still succeed at *running* pytest even
when a test fails, but the overall build still reports red?
