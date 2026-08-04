# Topic 1: Jenkins Docker Setup

**Time:** 20 minutes

## Goal

Run Jenkins locally in a Docker container and log in to the web UI.

## Commands to Use

```bash
# Pull the Jenkins image
docker pull jenkins/jenkins:lts-jdk17

# Create a volume for Jenkins data
docker volume create jenkins-home

# Run Jenkins in a container
docker run -d --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins-home:/var/jenkins_home \
  jenkins/jenkins:lts-jdk17

# Watch the logs
docker logs -f jenkins

# Get the initial admin password
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword

# Stop Jenkins
docker stop jenkins
```

## Guided Steps

1. Pull the Jenkins image.
2. Create the `jenkins-home` volume.
3. Run the container with ports 8080 and 50000 exposed.
4. Follow the logs until you see `Jenkins is fully up and running`.
5. Retrieve the initial admin password.
6. Open `http://localhost:8080` and complete the setup wizard.
7. Install the suggested plugins and create an admin user.

## Checkpoint

Why do we use a Docker volume for `/var/jenkins_home`?

## Next Steps

If you are using the lab environment, continue with [Lesson 2: Jenkins UI Overview](../../02-jenkins-ui-overview.md).
