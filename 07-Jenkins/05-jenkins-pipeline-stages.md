# Lesson 5: Pipeline Stages

This lesson expands your pipeline with environment variables, build/test stages, and artifact archiving.

## Learning Objectives

- Use the `environment` block
- Add multiple stages
- Archive build artifacts
- Handle success and failure with `post`

## Prerequisites

- A pipeline job created in Lesson 4

## Step 1: Create a New Pipeline Job

1. Click **New Item**
2. Name: `pipeline-stages`
3. Select **Pipeline**
4. Click **OK**

## Step 2: Write a Multi-Stage Pipeline

In the **Pipeline** script box, paste:

```groovy
pipeline {
    agent any

    environment {
        APP_NAME = 'jenkins-lab-app'
        VERSION = '1.0.0'
    }

    stages {
        stage('Prepare') {
            steps {
                echo "Building ${env.APP_NAME} version ${env.VERSION}"
                sh 'pwd'
                sh 'ls -la'
            }
        }

        stage('Build') {
            steps {
                echo 'Running build...'
                sh 'echo "Build ${BUILD_NUMBER} for ${APP_NAME}" > output.txt'
                sh 'echo "Version: ${VERSION}" >> output.txt'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                sh 'grep "Build" output.txt'
                sh 'grep "Version" output.txt'
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
            archiveArtifacts artifacts: 'output.txt', allowEmptyArchive: true
        }
        success {
            echo 'Build succeeded!'
        }
        failure {
            echo 'Build failed!'
        }
    }
}
```

Click **Save**.

## Step 3: Run and Inspect

1. Click **Build Now**
2. Open the build and click **Console Output**
3. Check the **Stage View** on the job page
4. Click **Build Artifacts** to download `output.txt`

## Checkpoint

> Why is it useful to archive `output.txt` after every build?

## Common Issues

### Artifacts Not Saved

- Make sure `allowEmptyArchive: true` is set, or the file must exist
- Verify the path matches the actual file location

## Key Takeaways

- `environment` defines variables available to all stages
- Each `stage` groups related steps
- `archiveArtifacts` saves files for later review
- `post` can react to success, failure, or always run

## Next Steps

[Lesson 6: Groovy Basics](./06-jenkins-groovy-part1.md) introduces Groovy scripting inside pipelines.
