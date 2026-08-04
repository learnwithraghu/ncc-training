# Topic 1: Jenkins Docker Setup

This lesson shows how to run Jenkins locally with Docker.

> **Lab note:** If your instructor already provided a Jenkins instance, you can skip this lesson and start with [Lesson 2: Jenkins UI Overview](../topic-02/guide.md).

## Learning Objectives

- Pull the official Jenkins Docker image
- Run Jenkins in a container with persistent storage
- Expose Jenkins on port 8080
- Complete the first-run setup wizard

## Prerequisites

- Docker installed
- Ports 8080 and 50000 free on your machine
- About 4 GB of free RAM

## Step 1: Pull the Jenkins Image

```bash
docker pull jenkins/jenkins:lts-jdk17
```

This downloads the latest Jenkins Long-Term Support image.

## Step 2: Create a Volume for Jenkins Data

Jenkins stores jobs, plugins, and configuration in `/var/jenkins_home`. Use a named volume so data survives container restarts.

```bash
docker volume create jenkins-home
```

## Step 3: Run the Jenkins Container

```bash
docker run -d --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins-home:/var/jenkins_home \
  jenkins/jenkins:lts-jdk17
```

What the flags do:

- `-d` — run in the background
- `--name jenkins` — friendly container name
- `-p 8080:8080` — web UI port
- `-p 50000:50000` — Jenkins agent port
- `-v jenkins-home:/var/jenkins_home` — persistent data

## Step 4: Check the Logs

```bash
docker logs -f jenkins
```

Wait for the message:

```text
Jenkins is fully up and running
```

Press `Ctrl+C` to stop following the logs.

## Step 5: Get the Initial Admin Password

```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

Copy the password.

## Step 6: Complete the Setup Wizard

1. Open `http://localhost:8080`
2. Paste the initial admin password
3. Choose **Install suggested plugins**
4. Create an admin user
5. Keep the default Jenkins URL

## Checkpoint

> Why is the volume `-v jenkins-home:/var/jenkins_home` important? What happens if you delete the container without using a volume?

## Key Commands

```bash
# View running containers
docker ps

# View Jenkins logs
docker logs jenkins

# Restart Jenkins
docker restart jenkins

# Stop Jenkins
docker stop jenkins

# Remove the container (data stays in the volume)
docker rm jenkins
```

## Next Steps

If you are using the lab environment, continue with [Lesson 2: Jenkins UI Overview](../topic-02/guide.md).