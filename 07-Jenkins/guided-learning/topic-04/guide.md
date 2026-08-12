# Topic 4: The Local Volume - Where Your Code Lives

**Time:** 20 minutes

## Goal
Understand the bind mount you created in Topic 2 well enough to use it as
a working "drop zone": files you edit on the EC2 host appear instantly
inside the Jenkins container, and every job you build from here on reads
its code from that folder.

## Files Provided
This topic's `files/code/` folder contains the two files you'll drop onto
the volume: `app.py` (valid) and `broken.py` (has a syntax error, on
purpose). Copy both to the host.

## Commands to Use
```bash
# on the EC2 host, outside any container
ls -la ~/jenkins-code
cp files/code/app.py ~/jenkins-code/
cp files/code/broken.py ~/jenkins-code/

docker exec jenkins ls -la /var/jenkins_code
docker exec jenkins cat /var/jenkins_code/app.py

echo "print('added from inside the container')" | \
  docker exec -i jenkins tee -a /var/jenkins_code/scratch.py
cat ~/jenkins-code/scratch.py
```

## Guided Steps
1. Confirm `~/jenkins-code` exists on the host (created in Topic 2) and
   copy this topic's `files/code/app.py` and `files/code/broken.py` into
   it.
2. From inside the container, list `/var/jenkins_code` - the same two
   files should already be there. No restart, no rebuild, nothing to
   sync: the bind mount makes the host folder and the container path the
   *same* directory on disk.
3. Write a file from **inside** the container and confirm it shows up on
   the **host**. This is the direction that matters for Jenkins: a
   pipeline running inside the container can write reports, logs, or
   built artifacts that you can inspect from the host without an extra
   `docker cp`.
4. Contrast this with the `jenkins_home` **named volume** from Topic 2:
   that one is managed by Docker, lives under
   `/var/lib/docker/volumes/...`, and you generally don't touch it by
   hand. `~/jenkins-code` is a **bind mount** - a real folder you own and
   edit directly. That's exactly why it's the right choice for "code I'm
   actively working on," while a named volume is the right choice for
   "state I want Docker to manage for me" (like `jenkins_home`).
5. Every remaining topic in this module assumes `~/jenkins-code` on the
   host = `/var/jenkins_code` inside the container. Keep that path in
   mind - pipeline stages will reference it directly.

## Checkpoint
If you deleted the `jenkins` container right now with `docker rm -f
jenkins` and started a brand-new one with the same two `-v` flags, which
files would still be there, and which would come back automatically vs.
need to be recreated?
