# Topic 10: Add a Test Stage (pytest + JUnit)

**Time:** 20 minutes

## Goal
Add Lint and Test stages to `lab-pipeline`, and publish pytest results with the JUnit plugin baked
into the image back in Topic 4.

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

        stage('Lint') {
            steps {
                sh 'cd app && bash check_syntax.sh'
            }
        }

        stage('Test') {
            steps {
                sh 'cd app && python3 -m pytest --junitxml=results.xml'
            }
            post {
                always {
                    junit 'app/results.xml'
                }
            }
        }
    }
}
```

## Guided Steps
1. Open `lab-pipeline` -> **Configure** and replace the script with the one above.
2. Save, then **Build Now**.
3. Open **Console Output** and watch the Lint stage run `check_syntax.sh` (py_compile + flake8).
4. Watch the Test stage run pytest, writing `results.xml` in JUnit XML format.
5. Back on the job's build page, look for the **Test Result** link/graph - this comes from the
   `junit` step in `post { always { ... } }`, which runs whether the tests pass or fail.
6. Break a test on purpose: edit `application/test_app.py` on the host to assert something false,
   rebuild the image (Topic 8's loop), recreate the container, and run the pipeline again. Confirm
   the build goes red and the Test Result page shows the failing test. Revert your change and
   rebuild once more before moving on.

## Checkpoint
Why does `junit` sit inside `post { always { ... } }` instead of directly inside the `Test` stage's
`steps` block?
