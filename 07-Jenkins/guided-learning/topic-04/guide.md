# Topic 4: Build a Custom Jenkins Image

**Time:** 20 minutes

## Goal
Move from `docker run` against the stock image to a `Dockerfile` so the plugins this module needs
are baked in and reproducible, instead of clicked through the Plugin Manager by hand.

## Files
- `../../jenkins/Dockerfile`
- `../../jenkins/plugins.txt`

## Commands to Use
```bash
cd /workspaces/ncc-training/07-Jenkins/jenkins
docker build -t ncc-jenkins:topic04 .
docker stop jenkins && docker rm jenkins
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  ncc-jenkins:topic04
```

## Guided Steps
1. Open `jenkins/Dockerfile` and read it top to bottom. At this point in the module, only the
   `FROM`, the `apt-get install python3 ...` layer, and the `plugins.txt` / `jenkins-plugin-cli`
   layer matter - ignore the Docker CLI and `COPY application` lines, they belong to later topics.
2. Open `jenkins/plugins.txt` and read the plugin list: `git`, `workflow-aggregator` (Pipeline),
   `pipeline-stage-view`, `junit`, `credentials-binding`, `docker-workflow`.
3. Build the image and tag it `ncc-jenkins:topic04`.
4. Stop and remove the running `jenkins` container - the volume from Topic 3 keeps your admin user
   and setup safe.
5. Run a new container from your custom image, same volume.
6. In the browser, go to **Manage Jenkins -> Plugins -> Installed plugins** and confirm the
   Pipeline-related plugins are already there - you never opened the Plugin Manager's "Available"
   tab to install them.

## Checkpoint
Why is baking plugins into the image with `plugins.txt` better than installing them by hand every
time you start a fresh Jenkins container?
