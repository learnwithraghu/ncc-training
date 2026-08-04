# Lesson 4: Pipeline Basics

This lesson introduces Jenkins pipelines. A pipeline is a set of instructions written as code, usually in a file called `Jenkinsfile`.

## Learning Objectives

- Understand what a declarative pipeline is
- Create a pipeline job in the Jenkins UI
- Run a simple pipeline
- Read the console output and stage view

## Prerequisites

- Jenkins is running and accessible
- Basic understanding of the Jenkins dashboard

## Step 1: Create a Pipeline Job

1. Click **New Item**
2. Name: `pipeline-basics`
3. Select **Pipeline**
4. Click **OK**

## Step 2: Write a Simple Pipeline

Scroll to the **Pipeline** section. In the **Script** box, paste:

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

Click **Save**.

## Step 3: Run the Pipeline

1. Click **Build Now**
2. After the build starts, click the build number
3. Click **Console Output** to see the logs

You should see output like:

```text
[Pipeline] echo
Hello from Jenkins Pipeline!
[Pipeline] echo
Build number: 1
[Pipeline] echo
Job name: pipeline-basics
[Pipeline] echo
Pipeline finished.
```

## Step 4: View the Stage View

On the job page, Jenkins shows a **Stage View** with each stage as a box.

## Pipeline Structure

```groovy
pipeline {          // Start of the pipeline
    agent any       // Run on any available agent

    stages {        // Contains all stages
        stage('Name') {
            steps {
                // commands go here
            }
        }
    }

    post {          // Runs after stages finish
        always {
            // cleanup or notifications
        }
    }
}
```

## Checkpoint

> What happens if you remove the `agent any` line from the pipeline?

## Common Issues

### Syntax Error

- Jenkins validates the pipeline before running
- Look for missing braces or quotes in the error message
- Use **Pipeline Syntax** link in the job for help

## Key Takeaways

- Pipelines are written in Groovy using declarative syntax
- `stages` contain logical steps
- `post` runs after the main stages

## Next Steps

[Lesson 5: Pipeline Stages](./05-jenkins-pipeline-stages.md) adds environment variables, real build/test steps, and artifacts.
