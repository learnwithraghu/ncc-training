# Topic 12: Parameterized Builds

**Time:** 20 minutes

## Goal
Add build parameters and trigger the pipeline manually with different values from the console's
**Build with Parameters** screen.

## Pipeline Script
Add a `parameters` block at the top of the pipeline, and wrap the `Test` stage's steps in a
`when` condition:
```groovy
pipeline {
    agent any

    parameters {
        choice(name: 'RUN_TESTS', choices: ['yes', 'no'], description: 'Run the Test stage?')
        string(name: 'GREETING', defaultValue: 'Hello NCC', description: 'Message printed by the Build stage')
    }

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
                sh "echo '${params.GREETING}'"
                sh 'cd app && python3 --version'
                sh 'cd app && pip3 install -r requirements.txt --user'
            }
        }

        stage('Lint') {
            steps {
                sh 'cd app && bash check_syntax.sh'
            }
        }

        stage('Test') {
            when {
                expression { params.RUN_TESTS == 'yes' }
            }
            steps {
                sh 'cd app && python3 -m pytest --junitxml=results.xml'
            }
            post {
                always {
                    junit 'app/results.xml'
                }
            }
        }

        stage('Package') {
            steps {
                sh 'cd app && tar -czf lab-app.tar.gz app.py requirements.txt'
            }
        }
    }

    post {
        success {
            archiveArtifacts artifacts: 'app/lab-app.tar.gz', fingerprint: true
        }
    }
}
```

## Guided Steps
1. Update `lab-pipeline` with the script above and **Save**.
2. Notice the left sidebar now says **Build with Parameters** instead of **Build Now** - Jenkins
   detected the `parameters` block on the last run and updated the job.
3. Click **Build with Parameters**, leave `RUN_TESTS` as `yes`, change `GREETING` to something of
   your own, and run it. Confirm your greeting appears in the Build stage's console output and the
   Test stage still runs.
4. Click **Build with Parameters** again, this time set `RUN_TESTS` to `no`, and run it. Confirm
   the Test stage is skipped (Jenkins shows it grayed out in the stage view) but Lint and Package
   still run.

## Checkpoint
Where did the `RUN_TESTS` choice actually change the pipeline's behavior, and how does that differ
from just commenting out the Test stage in the script?
