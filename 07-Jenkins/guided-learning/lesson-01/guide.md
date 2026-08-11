# Lesson 01 - EC2 Boot and Repo Clone

Start with the Amazon Linux EC2 host and make sure the students have this repository locally.

## Learn

- SSH into the EC2 instance
- Update the system
- Install Git and Python
- Clone this repo for the full lab

## Practice

```bash
sudo dnf update -y
sudo dnf install -y git python3
cd /home/ec2-user
git clone https://github.com/learnwithraghu/ncc-training.git
cd ncc-training/07-Jenkins
```

## Checkpoint

Can you confirm the repo is cloned and the Jenkins module files are visible?
