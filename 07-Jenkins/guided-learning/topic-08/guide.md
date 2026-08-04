# Topic 8: Interactive User Input

This lesson pauses a running Jenkins pipeline and asks a user to decide whether the build should continue. The response controls which stage runs.

## Learning Objectives

- Use the Pipeline `input` step
- Capture a user's choice in a pipeline
- Run a build stage conditionally
- Abort a waiting build safely

## Prerequisites

- Topic 7 completed
- Jenkins is running and accessible
- The Pipeline: Input Step plugin is installed

## Step 1: Create the Pipeline Job

1. Click **New Item**.
2. Name the job `interactive-build`.
3. Select **Pipeline**, then click **OK**.
4. In the **Pipeline** section, choose **Pipeline script**.

## Step 2: Add the Pipeline

Paste this script:

```groovy
pipeline {
    agent any

    stages {
        stage('Prepare') {
            steps {
                echo 'Preparing the build...'
            }
        }

        stage('Request Approval') {
            steps {
                script {
                    def decision = input(
                        message: 'Should Jenkins run the build?',
                        ok: 'Continue',
                        parameters: [
                            choice(
                                name: 'BUILD_TARGET',
                                choices: ['test', 'release'],
                                description: 'Choose the build target'
                            )
                        ]
                    )
                    env.BUILD_TARGET = decision
                    echo "Selected target: ${env.BUILD_TARGET}"
                }
            }
        }

        stage('Build') {
            when {
                expression { env.BUILD_TARGET != null }
            }
            steps {
                echo "Building the ${env.BUILD_TARGET} target..."
            }
        }
    }
}
```

Click **Save**, then **Build Now**. Open the build page and select **Proceed** or **Abort** when Jenkins pauses.

## Checkpoint

> What happens to the build when the user chooses **Abort** instead of **Proceed**?

## Common Issues

### The Input Step Is Not Available

- Install **Pipeline: Input Step** from **Manage Jenkins → Plugins**.
- Restart Jenkins if the plugin manager requests it.

### The Choice Is Not Stored

- Assign the return value from `input` to a variable.
- Store it in `env` or use it in the same `script` block.

## Key Takeaways

- `input` pauses a pipeline for a human decision.
- The response can control later stages.
- Aborting an input step stops the build rather than silently continuing.

## Next Steps

[Lesson 9: General Plugin Installation](../topic-09/guide.md) explains how to manage Jenkins plugins.
