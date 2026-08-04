# Topic 7: More Groovy in Pipelines

This lesson covers more Groovy patterns: loops, functions, file operations, and the `when` directive.

## Learning Objectives

- Write loops and functions in Groovy
- Use file operations inside a pipeline
- Use the `when` directive to run stages conditionally

## Prerequisites

- Lesson 6 completed
- A pipeline job created

## Step 1: Create a New Pipeline Job

1. Click **New Item**
2. Name: `groovy-advanced`
3. Select **Pipeline**
4. Click **OK**

## Step 2: Loops, Functions, and `when`

Paste this pipeline:

```groovy
pipeline {
    agent any

    stages {
        stage('Loop Example') {
            steps {
                script {
                    def tools = ['Git', 'Jenkins', 'Gitea', 'Docker']
                    for (tool in tools) {
                        echo "Tool: ${tool}"
                    }
                }
            }
        }

        stage('Function Example') {
            steps {
                script {
                    def result = greet('Jenkins Lab')
                    echo result
                }
            }
        }

        stage('Conditional Stage') {
            when {
                expression {
                    return env.BUILD_NUMBER.toInteger() > 1
                }
            }
            steps {
                echo 'This stage only runs after the first build.'
            }
        }

        stage('Write File') {
            steps {
                script {
                    writeFile file: 'build-info.txt', text: "Build ${env.BUILD_NUMBER} at ${new Date()}"
                    echo 'Wrote build-info.txt'
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'build-info.txt', allowEmptyArchive: true
        }
    }
}

def greet(String name) {
    return "Hello from ${name}!"
}
```

Click **Save** and then **Build Now**.

## Step 3: Run the Pipeline Twice

Run the job once. The conditional stage will be skipped because the build number is 1.
Run it again. The conditional stage will run.

## Checkpoint

> Why did the conditional stage run on the second build but not the first?

## Common Issues

### Missing Function Definition

- Functions defined at the bottom of the file are available in the pipeline
- Make sure they are outside the `pipeline {}` block

### `when` Skips Unexpectedly

- The `expression` must return a boolean
- Use `return` explicitly for clarity

## Key Takeaways

- Groovy supports loops and functions
- `when` controls whether a stage runs
- You can read and write files with built-in steps

## Next Steps

[Lesson 8: Gitea Integration](../topic-08/guide.md) connects Jenkins to a Gitea repository.