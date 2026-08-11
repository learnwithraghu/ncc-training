# Topic 14: Docker-in-Jenkins - Build the App's Own Image

**Time:** 20 minutes

## Goal
Let a pipeline stage build a Docker image for the lab app itself, by giving the Jenkins container
access to the host's Docker daemon. This bridges back to the Day 3 Docker artifact.

## Files
- `../../jenkins/Dockerfile` already has the Docker CLI layer for this topic
- `../../application/Dockerfile` - the image the pipeline will build

## Commands to Use
```bash
cd /workspaces/ncc-training/07-Jenkins/jenkins
docker build -t ncc-jenkins:topic14 .
docker stop jenkins && docker rm jenkins
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --group-add "$(stat -c '%g' /var/run/docker.sock)" \
  ncc-jenkins:topic14
docker exec jenkins docker version
```

## Guided Steps
1. Open `jenkins/Dockerfile` and find the Docker CLI layer - it downloads Docker's apt repo and
   installs `docker-ce-cli` only (no daemon; the container will talk to the **host's** daemon).
2. Rebuild the image, tagging it `ncc-jenkins:topic14`.
3. Stop and remove the running `jenkins` container.
4. Start a new one: same `jenkins_home` volume as always, plus a second mount for
   `/var/run/docker.sock`, plus `--group-add` so the non-root `jenkins` user inside the container
   can use that socket.
5. Confirm the Docker CLI inside the container can talk to the host's daemon:
   `docker exec jenkins docker version` should print both a Client and a Server section.
6. Open `application/Dockerfile` on the host - a small image that runs the lab app's `fizzbuzz`
   command.
7. Add a `Docker Build` stage to `lab-pipeline` after `Package`:
   ```groovy
        stage('Docker Build') {
            steps {
                sh "cd app && docker build -t lab-app:${env.BUILD_NUMBER} ."
            }
        }
   ```
8. Save, then **Build Now**.
9. On the **host** (not inside the Jenkins container), run `docker images | grep lab-app`.

## Checkpoint
Jenkins itself is running inside a container - so whose Docker daemon just built `lab-app:N`, and
why does `docker images` on the host show it too?
