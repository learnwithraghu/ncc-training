# Topic 4: Pipeline Basics

**Time:** 20 minutes

## Goal

Create a Jenkins pipeline job that prints a message and build information.

## Commands to Use

No new terminal commands.

## Guided Steps

1. Create a new pipeline job named `pipeline-basics`.
2. In the **Pipeline** script box, paste:

```groovy
pipeline {
    agent any

    stages {
        stage('Hello') {
            steps {
                echo 'Hello from Jenkins Pipeline!'
            }
        }
        stage('Info') {
            steps {
                echo "Build number: ${env.BUILD_NUMBER}"
                echo "Job name: ${env.JOB_NAME}"
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
    }
}
```

3. Save and click **Build Now**.
4. Read the console output.

## Checkpoint

What does `agent any` mean in a pipeline?

## Next Steps

Continue with [Lesson 5: Pipeline Stages](../../05-jenkins-pipeline-stages.md).
