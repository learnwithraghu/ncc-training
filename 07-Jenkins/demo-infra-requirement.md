# Demo Infra Requirement

## Infra Needed

- **Topic 1 only:** a disposable Amazon Linux 2023 EC2 instance
  (`t2.micro`/`t3.micro`), security group open on 22 and 8080 from your
  IP. Terminated at the end of the topic.
- **Topics 2-12:** a second, separate Amazon Linux 2023 EC2 instance
  (`t2.micro`/`t3.micro` is enough), security group open on 22, 8080, and
  50000 from your IP. This is the machine the rest of the module runs
  on.
- Docker Engine and git installed on the second instance (Topic 2 covers
  this).
- Free host ports **8080** (Jenkins web UI) and **50000** (agent port).
- Internet access on both instances, to pull OS packages, the
  `jenkins/jenkins:lts-jdk17` image, and `pip`/`apt` packages
  (`python3`, `flake8`, `pytest`, `docker.io`) installed inside the
  running container in later topics.
- A host folder for the bind mount, e.g. `~/jenkins-code` on the second
  instance (created in Topic 2, used from Topic 4 onward).
- From Topic 12 onward: `/var/run/docker.sock` on the second instance,
  bind-mounted into the Jenkins container so pipeline stages can drive
  the host's Docker daemon.

## Quick Validation

Run this on the second EC2 instance (the one running Jenkins in Docker):

```bash
docker --version
git --version
docker ps --filter name=jenkins
curl -sI http://localhost:8080 | head -1
```

## Full Validation

Run the module validator:
`/workspaces/ncc-training/07-Jenkins/helpers/validate-infra.sh`
