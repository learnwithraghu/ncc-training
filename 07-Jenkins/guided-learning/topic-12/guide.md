# Topic 12: Docker Build from Gitea

This lesson checks out the Gitea repository and builds a Docker image from its `docker-example/Dockerfile`. The image is built locally only. It is not pushed to a registry.

## Learning Objectives

- Build a Docker image from a repository Dockerfile
- Pass a build argument from Jenkins
- Inspect the resulting local image
- Keep image builds separate from image publishing

## Prerequisites

- Topic 10 completed and `docker version` succeeds in Jenkins
- Topic 11 completed
- The `gitea-pipeline` job can check out the repository

## Step 1: Create the Docker Build Job

1. Create a Pipeline job named `gitea-docker-build`.
2. Choose **Pipeline script from SCM**.
3. Use the same Gitea URL, credential, and branch settings from Topic 11.
4. Set **Script Path** to `docker-example/Jenkinsfile`.

## Step 2: Add the Docker Build Pipeline

The repository contains `docker-example/Jenkinsfile`:

```groovy
pipeline {
    agent any

    parameters {
        string(name: 'IMAGE_TAG', defaultValue: 'training', description: 'Local image tag')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build --build-arg BUILD_NUMBER=${env.BUILD_NUMBER} -t jenkins-lab:${params.IMAGE_TAG} docker-example"
            }
        }

        stage('Inspect Image') {
            steps {
                sh "docker image inspect jenkins-lab:${params.IMAGE_TAG}"
            }
        }
    }
}
```

Click **Build with Parameters**, provide a simple tag such as `training-1`, and start the build.

## Step 3: Verify the Build

The console output should show the Dockerfile steps and a successful image inspection. On the Docker host, verify the local image:

```bash
docker image ls 'jenkins-lab'
```

This lesson intentionally does not use `docker login`, `docker tag` for a registry, or `docker push`.

## Checkpoint

> What is the difference between building a local image and publishing an image to a registry?

## Common Issues

### Dockerfile Not Found

- Confirm the path is `docker-example/Dockerfile`.
- Confirm the build context is `docker-example`.
- Confirm the folder was committed to Gitea.

### Image Tag Is Invalid

- Use lowercase letters, numbers, periods, dashes, or underscores.
- Do not include spaces in `IMAGE_TAG`.

### Build Works Locally but Not in Jenkins

- Run `docker version` in the same Jenkins agent.
- Check the Docker CLI and daemon configuration from Topic 10.

## Key Takeaways

- Jenkins can build images directly from source checked out from Gitea.
- Build arguments and parameters make the job reusable.
- A local Docker build does not publish the image.

## Next Steps

[Lesson 13: Jenkins Features](../topic-13/guide.md) reviews artifacts, history, parameters, and replay.
