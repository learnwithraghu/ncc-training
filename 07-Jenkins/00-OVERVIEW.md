# Jenkins CI/CD - Overview

## What is Jenkins?

Jenkins is an open-source automation server. It helps teams build, test, and deploy software automatically. Jenkins is one of the most widely used CI/CD tools.

## Why Use Jenkins?

- **Automation**: Run tests, builds, and deployments without manual steps
- **CI/CD**: Build and test code on every change
- **Extensible**: Thousands of plugins for Git, Gitea, Docker, cloud platforms, and more
- **Pipeline as Code**: Store build logic in a `Jenkinsfile` inside your repository

## Core Concepts

### Jobs

A **job** is a task that Jenkins runs. Common job types include:

- **Freestyle project**: configured through the web UI
- **Pipeline**: defined as code in Groovy

### Pipelines

A **pipeline** is a series of stages and steps:

```
Checkout → Build → Test → Archive → Deploy
```

### Jenkinsfile

A `Jenkinsfile` is a text file that defines a Jenkins pipeline. It lives in the source repository, so the pipeline is version-controlled.

Example:

```groovy
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building...'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing...'
            }
        }
    }
}
```

### Agents

An **agent** is a machine that runs Jenkins jobs. In this module, jobs run on the built-in agent (`agent any`).

### Plugins

Plugins add features to Jenkins. Examples:

- `Git` — clone Git repositories
- `Pipeline` — run pipeline jobs
- `Gitea` — Gitea integration

### Credentials

Jenkins stores secrets such as passwords and access tokens in **Credentials**. This keeps sensitive data out of job scripts.

## Jenkins and Gitea

In this module, Jenkins pulls source code from Gitea. The typical flow is:

```
Developer pushes to Gitea
        |
        v
Gitea sends webhook to Jenkins
        |
        v
Jenkins pulls code and runs Jenkinsfile
        |
        v
Build result is shown in Jenkins
```

## Learning Path

This module has 10 guided topics:

1. Jenkins Docker setup
2. Jenkins UI overview
3. Freestyle job
4. Pipeline basics
5. Pipeline stages
6. Groovy basics
7. More Groovy
8. Gitea integration
9. Jenkins features
10. Build on push

Each topic builds on the previous one.

## Sample Project

The `lab-project/` folder contains a small shell-based project used throughout the module. You will upload it to Gitea in Topic 8.

## Prerequisites

Before starting this module:

- Basic Linux command line skills
- Basic Git knowledge
- Access to a Jenkins instance (Docker or lab-provided)
- Access to a Gitea server

## Best Practices

1. Store pipelines in a `Jenkinsfile` inside the repository
2. Use Jenkins credentials for secrets
3. Keep stages small and focused
4. Archive useful build artifacts
5. Use webhooks instead of polling when possible

## Resources

- [Jenkins Official Docs](https://www.jenkins.io/doc/)
- [Jenkins Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [Gitea Documentation](https://docs.gitea.com/)

---

Ready to start? Go to [Topic 1: Jenkins Docker Setup](./guided-learning/topic-01/guide.md).