# Topic 15: Capstone - Full Rebuild-Bake-Run Cycle

**Time:** 20 minutes

## Goal
Run the entire workflow end to end, from a real code change through a full pipeline, using the
final `Jenkinsfile` in `../../jenkins/Jenkinsfile` as your reference.

## Commands to Use
```bash
cd /workspaces/ncc-training/07-Jenkins/jenkins
docker build -t ncc-jenkins:topic15 .
docker stop jenkins && docker rm jenkins
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --group-add "$(stat -c '%g' /var/run/docker.sock)" \
  ncc-jenkins:topic15
```

## Guided Steps
1. On the host, make one more real change to `application/app.py` (for example, add a new
   subcommand or tweak `fizzbuzz`) and add a matching test in `application/test_app.py`.
2. Rebuild the image and recreate the container with the command above - the full rebuild loop
   from Topic 8, now with the Docker socket mount from Topic 14.
3. Open `lab-pipeline` -> **Configure** and paste in `jenkins/Jenkinsfile` in full (it matches what
   you built incrementally across Topics 7-14: Prepare, Build, Lint, Test, Package, Docker Build,
   parameters, and the credentials-backed stage).
4. Click **Build with Parameters**, leave the defaults, and run it.
5. Walk the stage view left to right and confirm each stage: Prepare copies the code, Build installs
   deps, Lint checks syntax, Test runs pytest and publishes JUnit results, Package archives a
   tarball, Docker Build produces `lab-app:<build number>` using the host's daemon.
6. Run through the completion checklist below.

## Completion Checklist
- [ ] Jenkins runs from a custom image (`jenkins/Dockerfile`), not the stock image
- [ ] `JENKINS_HOME` is a named volume - jobs and credentials survive container recreation
- [ ] Plugins are baked in via `plugins.txt`, not installed by hand
- [ ] The lab project and a reference `Jenkinsfile` are baked into the image
- [ ] You can explain the rebuild loop (Topic 8) and when to use a bind mount instead (Topic 9)
- [ ] `lab-pipeline` has Prepare, Build, Lint, Test, Package, and Docker Build stages
- [ ] Test results show up under **Test Result** thanks to the `junit` step
- [ ] `lab-app.tar.gz` is downloadable from **Build Artifacts**
- [ ] `Build with Parameters` changes what the pipeline does (`RUN_TESTS`)
- [ ] A secret is read from the Jenkins credentials store, not hardcoded in the script
- [ ] `docker images` on the host shows an image the pipeline built inside the container

## What's Next
Every build in this module started with a manual **Build Now** / **Build with Parameters** click.
[08-GitHub-Actions](../../../08-GitHub-Actions/README.md) picks up from here and automates the
trigger - a `git push` starts the pipeline instead of a click, and the built image gets pushed to
Amazon ECR instead of staying local.

## Checkpoint
List three things you'd want to automate next if this pipeline had to run on every `git push`
instead of a manual **Build Now** click.
