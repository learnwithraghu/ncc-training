# Topic 9: Bind-Mount Instead of Rebuild

**Time:** 20 minutes

## Goal
Learn the alternative to Topic 8's rebuild loop: bind-mount the host's `application/` folder
straight into the container so edits are picked up immediately, no image build required.

## Commands to Use
```bash
cd /workspaces/ncc-training/07-Jenkins
docker stop jenkins && docker rm jenkins
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v "$(pwd)/application:/opt/lab-project/application" \
  ncc-jenkins:topic08
```

## Guided Steps
1. Stop and remove the current `jenkins` container.
2. Start a new one from the same image as Topic 8, but this time add a **second** volume flag that
   bind-mounts the host's `application/` folder over the baked-in copy at
   `/opt/lab-project/application`.
3. On the host, edit `application/app.py` again - add another visible change.
4. In the browser, run `lab-pipeline` with **Build Now** - do **not** rebuild the image first.
5. Confirm the new build sees your change immediately (`docker exec jenkins cat
   /opt/lab-project/application/app.py`).
6. Compare the two workflows:

   | | Rebuild (Topics 4-8) | Bind-mount (this topic) |
   |---|---|---|
   | Speed of picking up a change | Slow - full `docker build` + recreate | Instant |
   | What ships to production | Exactly what's in the image | Depends on whatever's on the host at run time |
   | Reproducible on another machine | Yes - the image is self-contained | No - needs the host folder too |
   | Matches how real CI/CD ships code | Yes | No |

## Checkpoint
When would you reach for a bind mount in real life, and when would you insist on the rebuild-and-
bake pattern instead?

## Before You Move On
The rest of this module uses the rebuild-and-bake pattern from Topic 8, not the bind mount. Switch
back before Topic 10:
```bash
docker stop jenkins && docker rm jenkins
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  ncc-jenkins:topic08
```
