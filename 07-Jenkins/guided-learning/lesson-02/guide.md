# Lesson 02 - Command-Based Jenkins Install

Install Jenkins on Ubuntu Server with direct commands.

## Learn

- Install Java and Jenkins from the official Ubuntu repo
- Add the Jenkins apt key and repository
- Enable the Jenkins service
- Start Jenkins with systemd

## Practice

```bash
sudo apt-get update -y
sudo apt-get install -y openjdk-17-jre git python3 wget curl gnupg ca-certificates
sudo mkdir -p /etc/apt/trusted.gpg.d
sudo wget -qO- https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/jenkins.gpg
echo "deb https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins
```

## Checkpoint

Why is the command-based install easy to show and repeat in class?
