# Topic 6: Reading Code From the Mounted Folder

**Time:** 20 minutes

## Goal
Point a Pipeline job at the bind-mounted folder from Topic 4 and have it
list and read files that live on the host EC2 instance, not inside the
image.

## Files Provided
- `files/code/app.py`, `files/code/broken.py` - drop these onto the host
  volume (same two files as Topic 4; copied here so this topic works even
  if you start fresh).
- `files/Jenkinsfile` - a pipeline that lists `/var/jenkins_code` and
  prints one file's contents.

## Guided Steps
1. On the host, make sure `~/jenkins-code/app.py` and
   `~/jenkins-code/broken.py` exist (copy this topic's `files/code/*` in
   if you're starting fresh here).
2. Create a new Pipeline job, e.g. `read-mounted-code`.
3. Paste this topic's `files/Jenkinsfile` into the **Pipeline script**
   box and save.
4. Run **Build Now**. In the console output you should see the same file
   listing you'd get from `ls -la ~/jenkins-code` on the host, plus the
   full text of `app.py`.
5. Now edit a file **on the host** directly - `echo "# edited on host" >>
   ~/jenkins-code/app.py` - and re-run the build without touching
   Jenkins configuration at all. The new line shows up in the console
   output immediately, because the pipeline reads the live bind-mounted
   path, not a copy.
6. This is the core trick for the rest of the module: instead of using
   "Pipeline script from SCM" to pull code from a git repository, every
   pipeline here reads straight from `/var/jenkins_code` - the same
   folder you edit on the host as `~/jenkins-code`.

## Checkpoint
If two people SSH into this EC2 instance and both edit files under
`~/jenkins-code`, does the *next* Jenkins build see both sets of changes?
Why?
