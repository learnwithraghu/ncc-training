# Topic 11: Docker Hello World Pipeline

This lesson runs Docker's official `hello-world` image from a Jenkins pipeline. It is the first practical test that Jenkins can use Docker successfully.

## Learning Objectives

- Create a Jenkins pipeline that runs a Docker command
- Pull and run the `hello-world` image
- Read container output in Jenkins console logs
- Remove the temporary container after the run

## Prerequisites

- Topic 10 completed
- `docker version` succeeds from a Jenkins build agent
- Jenkins is running and accessible

## Step 1: Create the Pipeline Job

1. Click **New Item**.
2. Name the job `docker-hello-world`.
3. Select **Pipeline**, then click **OK**.
4. In the **Pipeline** section, choose **Pipeline script**.

## Step 2: Add the Pipeline

Paste this script:

```groovy
pipeline {
    agent any

    stages {
        stage('Check Docker') {
            steps {
                sh 'docker version'
            }
        }

        stage('Run Hello World') {
            steps {
                sh 'docker run --rm hello-world'
            }
        }
    }
}
```

Click **Save**, then **Build Now**.

## Step 3: Read the Build Output

Open **Console Output**. The log should show Docker information, the `hello-world` image pull if needed, the Hello from Docker message, and a successful pipeline result.

The `--rm` option removes the stopped container after it finishes. The image remains cached on the Docker host for later runs.

## Checkpoint

> Why does this pipeline use `docker run --rm hello-world` instead of installing Docker inside the Jenkins job?

## Common Issues

### Cannot Connect to the Docker Daemon

- Confirm Topic 10's Docker access test succeeds on the same agent.
- Check the Docker socket or remote Docker endpoint.
- Verify Docker Engine is running.

### Image Pull Fails

- Confirm the agent has network access to Docker Hub.
- Retry after checking Docker Hub availability.

### The Hello World Message Is Missing

- Open the build's full **Console Output**.
- Confirm the `docker run` command completed successfully.

## Key Takeaways

- A Jenkins pipeline can run Docker commands on its agent.
- `hello-world` is a simple end-to-end Docker access test.
- `--rm` keeps temporary containers from accumulating.

## Next Steps

[Lesson 12: Gitea Integration](../topic-12/guide.md) connects Jenkins to the repository used for the Docker build.
