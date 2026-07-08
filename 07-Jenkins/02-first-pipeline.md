# Lesson 2: Your First Jenkins Pipeline

This lesson introduces you to Jenkins pipelines. You'll create a simple "Hello World" pipeline to understand the basic concepts before moving to more complex scenarios.

## Learning Objectives

- Understand what a Jenkins pipeline is
- Create a simple pipeline job
- Learn basic pipeline syntax
- Execute and view pipeline results
- Understand pipeline stages and steps

## Prerequisites

- Jenkins installed and accessible (from Lesson 1)
- Basic understanding of YAML/Groovy syntax (helpful but not required)

## What is a Jenkins Pipeline?

A **pipeline** is a series of automated steps that Jenkins executes. Pipelines are defined as code (usually in Groovy) and can be:

- **Simple**: Just a few commands
- **Complex**: Multi-stage builds with testing, deployment, etc.
- **Version Controlled**: Stored in your repository as `Jenkinsfile`

## Step 1: Create Your First Pipeline (Web UI)

### Create a New Pipeline Job

1. **In Jenkins Dashboard**: Click "New Item"

2. **Enter Job Name**: `my-first-pipeline`

3. **Select Job Type**: Choose **"Pipeline"**

4. **Click OK**

### Write a Simple Pipeline

1. **Scroll to Pipeline section**

2. **In the Script box**, paste this simple pipeline:

```groovy
pipeline {
    agent any
    
    stages {
        stage('Hello') {
            steps {
                echo 'Hello, Jenkins!'
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
            echo 'Pipeline execution completed!'
        }
    }
}
```

3. **Click Save**

### Run the Pipeline

1. **Click "Build Now"** on the job page

2. **Watch the build progress**:
   - You'll see stages executing
   - Each stage shows in the pipeline view

3. **View Results**:
   - Click on the build number (#1)
   - Click "Console Output" to see detailed logs

## Step 2: Understanding the Pipeline Structure

Let's break down the pipeline you just created:

```groovy
pipeline {                    // Declarative pipeline syntax
    agent any                 // Run on any available agent
    
    stages {                  // Define pipeline stages
        stage('Hello') {      // First stage named "Hello"
            steps {           // Steps to execute
                echo 'Hello, Jenkins!'
            }
        }
        // ... more stages
    }
    
    post {                    // Post-build actions
        always {              // Always execute
            echo 'Pipeline execution completed!'
        }
    }
}
```

### Key Concepts

- **`pipeline`**: Declarative pipeline block
- **`agent any`**: Run on any available Jenkins agent/node
- **`stages`**: Collection of stage definitions
- **`stage`**: A named block containing steps
- **`steps`**: Individual commands to execute
- **`post`**: Actions to run after stages complete

## Step 3: Add More Stages

Let's enhance your pipeline with more stages:

```groovy
pipeline {
    agent any
    
    stages {
        stage('Preparation') {
            steps {
                echo 'Preparing build environment...'
                sh 'pwd'
                sh 'whoami'
            }
        }
        
        stage('Build') {
            steps {
                echo 'Building application...'
                sh 'echo "Build step would go here"'
            }
        }
        
        stage('Test') {
            steps {
                echo 'Running tests...'
                sh 'echo "Tests would run here"'
            }
        }
        
        stage('Deploy') {
            steps {
                echo 'Deploying application...'
                sh 'echo "Deployment would happen here"'
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline succeeded! ✅'
        }
        failure {
            echo 'Pipeline failed! ❌'
        }
        always {
            echo 'Pipeline execution completed!'
        }
    }
}
```

**Update your pipeline** with this code and run it again.

## Step 4: Using Environment Variables

Jenkins provides many built-in environment variables:

```groovy
pipeline {
    agent any
    
    stages {
        stage('Environment Info') {
            steps {
                echo "Build Number: ${env.BUILD_NUMBER}"
                echo "Job Name: ${env.JOB_NAME}"
                echo "Build URL: ${env.BUILD_URL}"
                echo "Workspace: ${env.WORKSPACE}"
                echo "Node Name: ${env.NODE_NAME}"
            }
        }
        
        stage('Custom Variables') {
            steps {
                script {
                    def customVar = "Hello from script!"
                    echo customVar
                    echo "Current time: ${new Date()}"
                }
            }
        }
    }
}
```

## Step 5: Conditional Stages

You can make stages conditional:

```groovy
pipeline {
    agent any
    
    stages {
        stage('Always Run') {
            steps {
                echo 'This always runs'
            }
        }
        
        stage('Conditional Stage') {
            when {
                expression { 
                    return env.BUILD_NUMBER.toInteger() % 2 == 0 
                }
            }
            steps {
                echo 'This only runs on even build numbers'
            }
        }
    }
}
```

## Step 6: Practice Exercise

Create a pipeline that:

1. Prints "Starting build"
2. Shows current date and time
3. Lists files in workspace
4. Shows system information (uname -a)
5. Prints "Build complete"

**Solution** (try on your own first!):

```groovy
pipeline {
    agent any
    
    stages {
        stage('Start') {
            steps {
                echo 'Starting build...'
            }
        }
        
        stage('Date/Time') {
            steps {
                script {
                    def now = new Date()
                    echo "Current time: ${now}"
                }
            }
        }
        
        stage('List Files') {
            steps {
                sh 'ls -la'
            }
        }
        
        stage('System Info') {
            steps {
                sh 'uname -a'
            }
        }
        
        stage('Complete') {
            steps {
                echo 'Build complete!'
            }
        }
    }
}
```

## Common Pipeline Commands

### Shell Commands

```groovy
sh 'command'                    // Execute shell command
sh 'command', returnStdout: true // Return output
sh script: 'command', returnStatus: true // Return exit code
```

### File Operations

```groovy
readFile 'path/to/file'         // Read file content
writeFile file: 'path', text: 'content' // Write file
fileExists 'path'               // Check if file exists
```

### Echo and Print

```groovy
echo 'Message'                  // Print message
println 'Message'              // Print with newline
```

## Troubleshooting

### Pipeline Syntax Errors

**Problem**: Pipeline fails with syntax error

**Solution**: 
- Check Groovy syntax
- Use Jenkins Pipeline Syntax helper: Pipeline → Pipeline Syntax
- Validate syntax before saving

### Commands Not Found

**Problem**: `sh` command fails with "command not found"

**Solution**:
- Use full path: `sh '/usr/bin/command'`
- Check PATH: `sh 'echo $PATH'`
- Install required tools on Jenkins server

### Permission Denied

**Problem**: Permission errors when running commands

**Solution**:
- Check file permissions
- Use `sudo` if needed (configure sudoers)
- Check Jenkins user permissions

## Key Takeaways

✅ **Pipelines are code**: Defined in Groovy syntax  
✅ **Stages organize work**: Logical grouping of steps  
✅ **Steps execute commands**: Individual actions  
✅ **Post actions run always**: Cleanup, notifications, etc.  
✅ **Environment variables**: Access build information  

## Next Steps

Great job! You've created your first pipeline. 

**In the next lesson**, you'll connect Jenkins to GitHub so pipelines can automatically trigger when code changes.

**Before moving on**, make sure you can:
- ✅ Create a pipeline job
- ✅ Write basic pipeline syntax
- ✅ Execute and view pipeline results
- ✅ Understand stages and steps

---

**Ready for the next lesson?** Move to [03-github-integration.md](./03-github-integration.md) to connect Jenkins with GitHub!

