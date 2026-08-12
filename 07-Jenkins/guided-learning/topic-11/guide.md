# Topic 11: Archiving Artifacts & Build History

**Time:** 20 minutes

## Goal
Keep evidence of what each build actually tested: archive the test
report and a snapshot of the code alongside every build, and cap how many
old builds Jenkins keeps around.

## Files Provided
- `files/code/app.py`, `files/code/test_app.py`, `files/code/requirements.txt`
- `files/Jenkinsfile` - adds an `Archive` stage on top of Topic 10's
  `Syntax Check` and `Unit Tests`, plus a `buildDiscarder` retention
  policy.

## Prerequisites
`python3` and `pytest` installed in the container (Topics 7 and 10).

## Guided Steps
1. Copy this topic's `files/code/*` onto `~/jenkins-code`.
2. Create a Pipeline job, e.g. `python-tested-and-archived`, paste in
   this topic's `files/Jenkinsfile`, and save.
3. Click **Build Now** a few times (feel free to tweak `app.py` slightly
   between runs, e.g. change the `fizzbuzz` boundary). After each build,
   open the build page and click **Archived Artifacts** - you'll find
   `app-snapshot.py` and `build-info.txt` for that specific run.
4. Compare `app-snapshot.py` across two different build numbers. Because
   Jenkins keeps each build's artifacts separately, you have a record of
   exactly which version of the code produced each pass/fail result -
   even though there's no git history backing any of this.
5. Look at **Test Result Trend** on the job's main page - it charts pass
   counts across recent builds, built entirely from the JUnit XML each
   build archived via the `junit` step in Topic 10.
6. Read the `options { buildDiscarder(logRotator(numToKeepStr: '10')) }`
   block. It tells Jenkins to keep only the 10 most recent builds (and
   their artifacts), so a job you run for months doesn't quietly fill the
   `jenkins_home` volume.

## Checkpoint
`archiveArtifacts` and `junit` both read from paths under `${WORKSPACE}`,
never from `/var/jenkins_code`. Given what Topic 10 said about
workspace-vs-source, why would archiving files straight from
`/var/jenkins_code` be the wrong instinct here?
