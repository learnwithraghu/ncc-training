# Topic 5: Bake the Lab Project into the Image

**Time:** 20 minutes

## Goal
`COPY` the lab project's code and a reference `Jenkinsfile` into the image so pipelines can use
them without any Git checkout step.

## Commands to Use
```bash
cd /workspaces/ncc-training/07-Jenkins/jenkins
docker build -t ncc-jenkins:topic05 .
docker stop jenkins && docker rm jenkins
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  ncc-jenkins:topic05
docker exec jenkins ls -la /opt/lab-project/application
docker exec jenkins cat /opt/lab-project/Jenkinsfile
```

## Guided Steps
1. In `jenkins/Dockerfile`, find the two `COPY` lines near the bottom:
   ```dockerfile
   COPY application /opt/lab-project/application
   COPY Jenkinsfile /opt/lab-project/Jenkinsfile
   ```
   These copy `../application/` (the lab app) and `../Jenkinsfile` (the reference pipeline) into
   the image at build time.
2. Rebuild the image and recreate the container as shown above.
3. Exec into the running container and list `/opt/lab-project/application` - confirm `app.py`,
   `test_app.py`, `requirements.txt`, and `check_syntax.sh` are all there.
4. Cat the baked-in `Jenkinsfile` - you'll build this up stage by stage starting in Topic 7.
5. Notice this code arrived with the **image**, not with a `git clone` inside a job. There is no
   SCM configured on this Jenkins instance yet.

## Checkpoint
Where does the "code" a Jenkins pipeline is about to run actually live right now, and how did it
get there?
