# Topic 5: Your First Pipeline Job

**Time:** 20 minutes

## Goal
Create a Jenkins **Pipeline** job from the console, paste in an inline
pipeline script, run it with "Build Now," and read the console output.

## Files Provided
`files/Jenkinsfile` - a minimal one-stage pipeline you'll paste into the
job configuration.

## Guided Steps
1. From the Jenkins dashboard, click **New Item**.
2. Enter a name, e.g. `hello-pipeline`, select **Pipeline**, click OK.
3. Scroll to the **Pipeline** section at the bottom of the job
   configuration page. Set **Definition** to **Pipeline script** (not
   "Pipeline script from SCM" - you are not using git for this job yet).
4. Open this topic's `files/Jenkinsfile`, copy its contents, and paste
   them into the script box.
5. Click **Save**, then click **Build Now** on the job page.
6. Click the build number (e.g. `#1`) in the build history, then
   **Console Output**. Read through it - you should see each `sh` step
   run in order, with its output inline.
7. Click **Build Now** again to create build `#2`. Notice Jenkins keeps a
   history of every run, each with its own console output.

## Guided Explanation
A `pipeline { agent any { ... } }` block is the smallest valid Jenkins
Pipeline. `agent any` tells Jenkins to run the stages on any available
executor (here, the Jenkins container itself, since you haven't
configured any external agents). Each `stage` groups related `steps`; a
`sh` step runs a shell command inside the container.

## Checkpoint
Where does `pwd` say the pipeline is running, and why does that matter
for the next topic, where you'll read files from `/var/jenkins_code`?
