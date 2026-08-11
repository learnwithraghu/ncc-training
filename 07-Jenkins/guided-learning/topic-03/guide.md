# Topic 3: Don't Lose Your Data (Named Volume)

**Time:** 20 minutes

## Goal
See what happens to Jenkins configuration when a container is removed, then fix it with a named
volume for `JENKINS_HOME`.

## Commands to Use
```bash
docker stop jenkins-quickstart && docker rm jenkins-quickstart
docker run -d --name jenkins-noviolume -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts-jdk17
docker stop jenkins-noviolume && docker rm jenkins-noviolume
docker volume create jenkins_home
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts-jdk17
```

## Guided Steps
1. Remove the `jenkins-quickstart` container from Topic 2 (its admin user and setup are about to
   be gone with it).
2. Start a brand-new container with no volume attached, unlock it, and create an admin user again.
3. Stop and remove that container, then start another one the exact same way (still no volume).
4. Open the browser again - you're back at "Unlock Jenkins" from scratch. All configuration lived
   only inside the removed container's writable layer, and it's gone.
5. Now create a Docker named volume and mount it at `/var/jenkins_home`, the directory where
   Jenkins keeps everything: users, jobs, plugins, credentials.
6. Unlock and set up this instance once.
7. Stop and remove the container, then start a new one with the **same** `-v jenkins_home:...`
   flag. Confirm your admin user and setup are still there - no setup wizard this time.

## Checkpoint
What would happen to your jobs and credentials if you forgot the
`-v jenkins_home:/var/jenkins_home` flag the next time you recreate this container?
