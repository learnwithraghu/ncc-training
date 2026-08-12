# Topic 1: The Manual Way - Jenkins on EC2

**Time:** 20 minutes

## Goal
Install Jenkins by hand on a plain Amazon Linux EC2 instance, and feel the
pain of manual setup: OS packages, a JDK version, a Yum repo, a systemd
service, and a security group - all before you have created a single job.
This instance is **disposable**. You will not use it again after this
topic.

## Prerequisites
- Launch a fresh **Amazon Linux 2023** EC2 instance (`t2.micro` or
  `t3.micro` is enough), with a security group that allows inbound SSH
  (port 22) and port 8080 from your IP.
- SSH into it: `ssh -i your-key.pem ec2-user@<public-ip>`

## Commands to Use
```bash
sudo dnf update -y
sudo dnf install -y java-17-amazon-corretto
java -version

sudo wget -O /etc/yum.repos.d/jenkins.repo \
  https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo dnf install -y jenkins

sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
sudo journalctl -u jenkins --no-pager -n 50
```

## Guided Steps
1. Update the OS and install a JDK. Jenkins needs a specific Java major
   version - if you install the wrong one, Jenkins will fail to start and
   the error only shows up in `journalctl`, not in a friendly message.
2. Add the official Jenkins Yum repo and import its signing key. Notice
   how many manual, easy-to-mistype steps this is compared to
   `docker run`.
3. Install Jenkins with `dnf`, then enable and start the systemd service.
4. Open the security group for port 8080 from your IP, then browse to
   `http://<public-ip>:8080`. If it does not load, go back to
   `journalctl -u jenkins` and read the actual failure.
5. Once you have it running (or once you have spent ~10 minutes
   fighting it), stop and think about everything this required: choosing
   a JDK version, a package repo, a systemd unit, a firewall rule, and an
   EC2 instance you now have to remember to terminate. None of that had
   anything to do with building software.
6. Terminate this EC2 instance (or note it down to terminate at the end
   of the module). Every topic from here on runs Jenkins in Docker on a
   **different** EC2 instance - Topic 2 sets that up.

## Why We Switch to Docker
Everything you just did - the JDK version, the repo, the service file -
is baked into a single official image: `jenkins/jenkins:lts`. Docker
turns "match the exact JDK Jenkins expects" into "pull an image that
already has it." That is the whole motivation for the rest of this
module.

## Checkpoint
What is the exact error (from `journalctl -u jenkins`) if you point
Jenkins at the wrong Java version, and why does Docker make that class of
problem disappear entirely?
