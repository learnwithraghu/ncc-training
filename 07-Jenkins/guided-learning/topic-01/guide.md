# Topic 1: Manual Jenkins Install on EC2 Amazon Linux - and Why It Fails

**Time:** 20 minutes

## Goal
Install Jenkins directly on an EC2 Amazon Linux host using the commands a typical tutorial gives
you, hit a real failure, and diagnose it. This is the "why" for the rest of the module.

## Environment
This topic only: an EC2 instance running Amazon Linux, with `sudo` access. You will not use this
host again after this topic - Topic 2 onward moves to Docker on whatever machine has it installed.

## Commands to Use
```bash
sudo dnf update -y
sudo dnf install -y java-11-amazon-corretto wget
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo dnf install -y jenkins
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
```

## Guided Steps
1. SSH into the EC2 Amazon Linux instance.
2. Run the update, Java, and Jenkins repo commands above exactly as shown - this is what many
   older guides still tell you to do.
3. Install and start Jenkins, then check its status. It fails.
4. Read the real error:
   ```bash
   sudo journalctl -u jenkins -n 50 --no-pager
   ```
   Look for a message like `UnsupportedClassVersionError` or Jenkins refusing to start because the
   Java runtime is too old. Current Jenkins LTS requires Java 17+, but the command above installed
   Java 11 - a very plausible copy-paste mistake from an outdated doc.
5. Try to fix it live: install Java 17 and point Jenkins at it.
   ```bash
   sudo dnf install -y java-17-amazon-corretto
   sudo alternatives --config java
   sudo systemctl restart jenkins
   sudo systemctl status jenkins
   ```
6. Notice what you just did: hand-patched the host's Java version to match what one piece of
   software expects. Ask what happens the next time a different tool on this same host needs
   Java 11.
7. Clean up so this host doesn't fight with anything later in the course:
   ```bash
   sudo systemctl stop jenkins
   sudo systemctl disable jenkins
   sudo dnf remove -y jenkins java-11-amazon-corretto java-17-amazon-corretto
   ```

## Why We Switch to Docker
- The failure came from a **host-level dependency conflict** (Java version), not from Jenkins
  itself - and it's exactly the kind of thing that's invisible until it isn't.
- Fixing it meant **mutating the host** (installing/removing packages, switching `alternatives`).
  That fix is not written down anywhere reproducible.
- A different app on the same host, or a teammate following the same "working" doc a month later
  with a newer OS image, can hit a completely different failure.
- Docker fixes this by pinning the entire runtime - OS packages, Java version, Jenkins version -
  inside one image. `docker run jenkins/jenkins:lts-jdk17` gives every student the exact same,
  already-correct environment, and you already have the Docker skills from Day 3 to build on it.

## Checkpoint
Why did commands that "look right" fail here, and what does that tell you about installing
software directly on a shared, long-lived host instead of inside a container?
