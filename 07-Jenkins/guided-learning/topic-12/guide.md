# Topic 12: Docker-in-Jenkins - Build & Tag the App Image

**Time:** 20 minutes

## Goal
Let a pipeline stage run `docker build` against the **host's** Docker
daemon from inside the Jenkins container, so a build that passes its
tests also produces a real, taggable image - then recap the two kinds of
volumes this whole module has used.

## Files Provided
`files/code/app.py`, `test_app.py`, `requirements.txt`, `Dockerfile` -
drop all four onto `~/jenkins-code`. `files/Jenkinsfile` - `Syntax Check`
→ `Unit Tests` → `Docker Build` → `Docker Smoke Test`.

## Commands to Use
```bash
# recreate the container with the host's Docker socket mounted in
docker rm -f jenkins
docker run -d --name jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v ~/jenkins-code:/var/jenkins_code \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts-jdk17

docker exec -u root jenkins bash -c "apt-get update && apt-get install -y docker.io python3"
docker exec -u root jenkins chmod 666 /var/run/docker.sock
docker exec jenkins docker version
```

## Guided Steps
1. Recreate the `jenkins` container with a **third** `-v` mount:
   `/var/run/docker.sock:/var/run/docker.sock`. This is the socket the
   Docker CLI talks to - by bind-mounting the host's socket into the
   container, commands run *inside* the container control the *host's*
   Docker daemon. Jenkins is not running "Docker inside Docker"; it's
   reusing the one daemon that's already there.
2. Because `-v jenkins_home:/var/jenkins_home` is a **named volume**, all
   your jobs, users, and plugins from earlier topics come back untouched
   - only the container itself was replaced.
3. Install the `docker.io` package (gives you the `docker` CLI binary)
   inside the container, along with `python3` from Topic 7 if this is a
   fresh container.
4. The socket is normally owned by `root:docker` on the host; the
   simplest way to let the non-root `jenkins` user talk to it in this
   training environment is `chmod 666` on the socket, shown above. Say
   out loud why this is a **shortcut you would not use in a real
   environment** (anyone with container access can now control the host
   daemon) - a production setup would add the `jenkins` user to a
   matching `docker` group instead.
5. Copy this topic's `files/code/*` onto `~/jenkins-code`.
6. Create a Pipeline job, e.g. `python-build-and-package`, paste in this
   topic's `files/Jenkinsfile`, and save.
7. Click **Build Now**. Watch `Docker Build` run `docker build` and
   `Docker Smoke Test` run the freshly built image with `docker run
   --rm`. Confirm the image now exists on the **host** with `docker
   images | grep python-app` - proving the build really happened against
   the host daemon, not something private to the container.
8. Recap the three mounts this container now runs with:
   - `jenkins_home` (named volume) - Jenkins's own state, Docker-managed.
   - `~/jenkins-code` (bind mount) - your source code, host-managed,
     used by every topic since Topic 4.
   - `/var/run/docker.sock` (bind mount) - lets pipeline steps drive the
     host's Docker daemon directly.

## Checkpoint
If you ran `docker rmi python-app:<build-number>` on the host right now,
would the next pipeline run be affected? What would `docker rm -f
jenkins` followed by the `docker run` command from step 1 restore, and
what (if anything) would still be missing afterward?
