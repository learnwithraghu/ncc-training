# Topic 8: The Rebuild Loop

**Time:** 20 minutes

## Goal
Practice the core workflow this whole module is built around: edit code on the host, rebuild the
Jenkins image, recreate the container, rerun the pipeline from the console.

## Commands to Use
```bash
cd /workspaces/ncc-training/07-Jenkins/jenkins
docker build -t ncc-jenkins:topic08 .
docker stop jenkins && docker rm jenkins
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  ncc-jenkins:topic08
docker exec jenkins cat /opt/lab-project/application/app.py | head -5
```

## Guided Steps
1. On the host, open `application/app.py` and make a small, visible change - for example, edit the
   docstring at the top of the file to add your name or today's date.
2. Rebuild the image, tagging it `ncc-jenkins:topic08`.
3. Stop and remove the running `jenkins` container.
4. Run a new container from the rebuilt image, using the **same** `jenkins_home` volume as before.
5. In the browser, open `lab-pipeline` (from Topic 7) - your job definition is still there, because
   it lives in the volume, not the image.
6. Click **Build Now**.
7. Confirm the new build's workspace has your edited file:
   `docker exec jenkins cat /opt/lab-project/application/app.py | head -5` should show your change,
   and so should the console output if your pipeline prints anything from it.

## Checkpoint
Which parts of Jenkins survived the rebuild because of the named volume, and which parts changed
because you built a new image? Be specific.
