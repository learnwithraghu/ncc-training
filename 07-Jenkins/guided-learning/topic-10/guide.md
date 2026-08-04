# Topic 10: Docker Pipeline Plugin and Agent Setup

This lesson prepares Jenkins to run a Docker build. The Jenkins plugin provides pipeline integration, while the Jenkins agent still needs Docker CLI access and a reachable Docker daemon.

## Learning Objectives

- Install the Docker Pipeline plugin
- Distinguish a Jenkins plugin from Docker Engine
- Verify Docker access from a Jenkins build agent
- Understand the Docker socket security tradeoff

## Prerequisites

- Topic 9 completed
- Docker Engine running on the machine used by the Jenkins agent
- Administrator access to Jenkins

## Step 1: Install Docker Pipeline

1. Open **Manage Jenkins → Plugins**.
2. Search for **Docker Pipeline**.
3. Install it and restart Jenkins if requested.
4. Confirm it appears under **Installed plugins**.

The plugin adds Docker-related pipeline steps. It does not install Docker Engine.

## Step 2: Provide Docker Access to the Agent

For a local Docker-based Jenkins installation, the agent needs the Docker CLI and access to the Docker daemon. A common lab setup mounts the host socket and exposes the CLI in the Jenkins container:

```bash
docker run -d --name jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins-home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts-jdk17
```

The official Jenkins image may not include the Docker CLI. Use a custom Jenkins agent image with a compatible Docker CLI, or use a separate Docker-enabled agent instead.

> **Security note:** Access to `/var/run/docker.sock` is effectively powerful access to the Docker host. Use this only in an isolated training environment or use a dedicated Docker-enabled agent.

## Step 3: Verify Docker from Jenkins

Create a temporary Pipeline job with this script:

```groovy
pipeline {
    agent any

    stages {
        stage('Check Docker') {
            steps {
                sh 'docker version'
                sh 'docker info'
            }
        }
    }
}
```

Run the job. Both commands must succeed before continuing to Topic 11 and Topic 12.

## Checkpoint

> Why can a Docker Pipeline plugin be installed successfully while `docker version` still fails?

## Common Issues

### `docker: not found`

- Install the Docker CLI in the agent image.
- Confirm the job is running on the intended agent.

### Cannot Connect to the Docker Daemon

- Confirm Docker Engine is running.
- Check the socket mount or the configured remote Docker endpoint.
- Verify the Jenkins agent has permission to use the socket.

## Key Takeaways

- Docker Pipeline and Docker Engine are separate dependencies.
- Verify Docker access with a Jenkins job before writing the build pipeline.
- Avoid exposing a production Docker host to an untrusted Jenkins job.

## Next Steps

[Lesson 11: Docker Hello World Pipeline](../topic-11/guide.md) runs a simple Docker container from Jenkins.
