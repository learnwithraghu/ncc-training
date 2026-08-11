# Topic 6: Your First Pipeline Job from the Console

**Time:** 20 minutes

## Goal
Create a Pipeline job entirely through the Jenkins UI: New Item, paste a script, Save, Build Now.

## Pipeline Script
```groovy
pipeline {
    agent any
    stages {
        stage('Hello') {
            steps {
                sh 'echo Hello from the baked-in Jenkins image'
                sh 'ls -la /opt/lab-project/application'
            }
        }
    }
}
```

## Guided Steps
1. From the Jenkins dashboard, click **New Item**.
2. Name it `hello-pipeline`, select **Pipeline** as the type, click **OK**.
3. Scroll to the **Pipeline** section. Look at the **Definition** dropdown - it defaults to
   "Pipeline script". The other option, "Pipeline script from SCM", would have Jenkins `git clone`
   a repo before every run.
4. We're intentionally using **Pipeline script** (inline) for this whole module: the code is
   already baked into the image from Topic 5, so there's nothing to clone, and pasting the script
   in the console makes every edit visible and manual - matching how you'll iterate through the
   rest of this module.
5. Paste the script above into the script box.
6. Click **Save**.
7. Click **Build Now** in the left sidebar.
8. Click the build number that appears under **Build History**, then **Console Output**.
9. Confirm you see "Hello from the baked-in Jenkins image" and the `ls` output listing the lab
   project files.

## Checkpoint
What's the practical difference between "Pipeline script" and "Pipeline script from SCM", and why
does this module use the inline option?
