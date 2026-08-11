# Topic 2: Run Jenkins in Docker (Quickstart)

**Time:** 20 minutes

## Goal
Launch the official Jenkins image in Docker and complete the setup wizard from the browser -
compare this to how long Topic 1 took.

## Commands to Use
```bash
docker --version
docker run -d --name jenkins-quickstart -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts-jdk17
docker logs -f jenkins-quickstart
```

## Guided Steps
1. Confirm Docker is available on this machine.
2. Start the official `jenkins/jenkins:lts-jdk17` image, publishing the web UI port (8080) and the
   agent port (50000).
3. Watch the container logs until you see the initial admin password printed between two lines of
   asterisks. Stop following logs with `Ctrl+C`.
4. Open `http://<host>:8080` in a browser.
5. Retrieve the password another way too, so you know both options exist:
   ```bash
   docker exec jenkins-quickstart cat /var/jenkins_home/secrets/initialAdminPassword
   ```
6. Paste the password into "Unlock Jenkins".
7. Choose "Install suggested plugins" and wait for it to finish.
8. Create your first admin user and confirm the Jenkins URL.
9. Land on the Jenkins dashboard.

## Checkpoint
How long did this take compared to Topic 1's manual install, and what did you *not* have to think
about this time (Java version, OS package manager, repo keys)?
