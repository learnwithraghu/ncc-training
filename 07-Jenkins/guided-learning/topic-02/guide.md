# Topic 2: Meet Jenkins in Docker

**Time:** 20 minutes

## Goal
Launch a **second, fresh** EC2 instance, install Docker and git on it, and
run Jenkins as a container with its web port exposed. This is the machine
you will use for the rest of the module.

## Prerequisites
- Launch a fresh **Amazon Linux 2023** EC2 instance (`t2.micro` or
  `t3.micro`), security group open on port 22 (SSH) and 8080 (Jenkins UI)
  from your IP.
- SSH into it: `ssh -i your-key.pem ec2-user@<public-ip>`

## Commands to Use
```bash
sudo dnf update -y
sudo dnf install -y docker git
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user
# log out and back in so the group change applies
docker --version
git --version

mkdir -p ~/jenkins-code
docker run -d --name jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v ~/jenkins-code:/var/jenkins_code \
  jenkins/jenkins:lts-jdk17

docker ps
docker logs -f jenkins
```

## Guided Steps
1. Install Docker and git with `dnf`, enable the Docker service, and add
   `ec2-user` to the `docker` group so you don't need `sudo` for every
   `docker` command. Log out and back in (or run `newgrp docker`) for the
   group change to take effect.
2. Create a folder on the host, `~/jenkins-code`, before you start the
   container. This is the **local volume** you will keep coming back to
   in later topics - it is where you will drop Python files for Jenkins
   pipelines to read.
3. Run `jenkins/jenkins:lts-jdk17` with two `-v` mounts:
   - `jenkins_home` (a **named volume**) → `/var/jenkins_home`, so
     Jenkins's own configuration, jobs, and plugins survive a container
     restart.
   - `~/jenkins-code` (a **bind mount**) → `/var/jenkins_code`, so files
     you edit on the host EC2 instance are immediately visible inside the
     container, and files the container writes show up on the host.
4. Publish both ports: `8080` is the web UI, `50000` is used for Jenkins
   agents to connect (you won't use it yet, but it costs nothing to
   expose now).
5. Watch `docker logs -f jenkins` until you see "Jenkins is fully up and
   running." Then browse to `http://<public-ip>:8080`.
6. Compare this to Topic 1: one `docker run` command replaced a JDK
   install, a Yum repo, a signing key import, and a systemd service.

## Checkpoint
Which of the two `-v` mounts would lose data if you ran
`docker rm -f jenkins` right now, and which one wouldn't? Why?
