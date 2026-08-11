# Lesson 02 - Command-Based Jenkins Install

Install Jenkins on Amazon Linux EC2 with direct commands.

## Learn

- Install Java and Jenkins from the official repo
- Handle package conflicts with `--allowerasing` when needed
- Use `wget` to fetch the Jenkins repo file if `curl` conflicts on Amazon Linux
- Let Jenkins use the package defaults for its service config
- Enable the Jenkins service
- Start Jenkins with systemd

## Practice

```bash
sudo dnf update -y
sudo dnf install -y --allowerasing java-17-amazon-corretto git python3 wget
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo wget -qO /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo dnf install -y jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins
```

## Checkpoint

Why is the command-based install easy to show and repeat in class?
