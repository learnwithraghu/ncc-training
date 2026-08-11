# Lesson 09 - Local Repo Pipeline Job

Use Jenkins with a local clone of this repository on the EC2 host.

## Learn

- Clone the repo on the same EC2 server as Jenkins
- Use `Pipeline script from SCM`
- Set the Script Path to the lesson Jenkinsfile

## Practice

```bash
git clone https://github.com/learnwithraghu/ncc-training.git /home/ec2-user/ncc-training
```

Then in Jenkins UI:

- Job type: **Pipeline**
- Definition: **Pipeline script from SCM**
- SCM: **Git**
- Repository URL: `/home/ec2-user/ncc-training`
- Branch: `main`
- Script Path: `07-Jenkins/lab-project/Jenkinsfile`

## Checkpoint

Can Jenkins load the Jenkinsfile from the local cloned repo?
