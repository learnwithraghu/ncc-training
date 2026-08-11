# Topic 7: A Real Jenkinsfile for the Lab Project

**Time:** 20 minutes

## Goal
Replace the "Hello" script with a real `Jenkinsfile` for the lab project, and learn the
copy-into-workspace pattern the rest of the module builds on.

## Pipeline Script
```groovy
pipeline {
    agent any

    environment {
        LAB_SRC = '/opt/lab-project/application'
    }

    stages {
        stage('Prepare') {
            steps {
                sh 'rm -rf app && mkdir -p app'
                sh "cp -r ${LAB_SRC}/. app/"
            }
        }

        stage('Build') {
            steps {
                sh 'cd app && python3 --version'
                sh 'cd app && pip3 install -r requirements.txt --user'
            }
        }
    }
}
```

## Guided Steps
1. Create a new Pipeline job named `lab-pipeline` (New Item -> Pipeline).
2. Paste the script above as an inline **Pipeline script**, same as Topic 6.
3. Notice the new **Prepare** stage: it copies everything from `/opt/lab-project/application`
   (baked into the image, owned by root, effectively read-only to the `jenkins` user) into an
   `app/` folder inside the job's own **workspace** (writable, and cleaned/reused per job).
4. Every later stage - Lint, Test, Package, Docker Build - works against `app/`, never against
   `/opt/lab-project/application` directly. Keep this pattern in mind for the rest of the module.
5. Save and click **Build Now**.
6. Open **Console Output** and confirm `python3 --version` and the `pip3 install` both succeed.

## Checkpoint
Why copy the baked-in code into the workspace instead of running pip/pytest/tar directly against
`/opt/lab-project/application`?
