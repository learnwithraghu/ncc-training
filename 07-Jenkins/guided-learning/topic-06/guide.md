# Topic 6: Groovy Basics in Pipelines

This lesson introduces Groovy scripting inside the `script` block. You can use Groovy to add logic to your pipelines.

## Learning Objectives

- Use the `script` block in a declarative pipeline
- Create and use variables
- Write conditional statements
- Call built-in Jenkins methods

## Prerequisites

- You can create a pipeline job
- You understand basic pipeline stages

## Step 1: Create a New Pipeline Job

1. Click **New Item**
2. Name: `groovy-basics`
3. Select **Pipeline**
4. Click **OK**

## Step 2: Use a `script` Block

Paste this pipeline:

```groovy
pipeline {
    agent any

    stages {
        stage('Variables') {
            steps {
                script {
                    def name = 'Jenkins'
                    def build = env.BUILD_NUMBER
                    echo "Hello, ${name}!"
                    echo "This is build ${build}."
                }
            }
        }

        stage('Condition') {
            steps {
                script {
                    def number = env.BUILD_NUMBER.toInteger()
                    if (number % 2 == 0) {
                        echo 'Build number is even.'
                    } else {
                        echo 'Build number is odd.'
                    }
                }
            }
        }

        stage('Read File') {
            steps {
                writeFile file: 'version.txt', text: '1.0.0'
                script {
                    def version = readFile('version.txt').trim()
                    echo "Version is ${version}"
                }
            }
        }
    }

    post {
        always {
            echo 'Done with Groovy basics.'
        }
    }
}
```

Click **Save** and then **Build Now**.

## Step 3: View the Output

Open the console output. You should see:

- A greeting using the `name` variable
- Whether the build number is even or odd
- The version from `version.txt`

## Checkpoint

> What is the difference between `def` (Groovy) and `env.BUILD_NUMBER` (Jenkins environment)?

## Common Issues

### Type Errors

- `env.BUILD_NUMBER` is a String. Use `.toInteger()` for math.
- `readFile` returns a String. Use `.trim()` to remove trailing newlines.

### File Not Found

- Make sure the path is correct relative to the workspace
- Use `fileExists('path')` to check before reading

## Key Takeaways

- `script {}` lets you write Groovy inside a declarative pipeline
- `def` creates a local variable
- You can use `if/else`, loops, and built-in functions

## Next Steps

[Lesson 7: More Groovy](../topic-07/guide.md) covers loops, functions, and the `when` directive.