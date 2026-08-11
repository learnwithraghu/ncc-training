# Lesson 07 - Simple Pipeline Stages

Create a Pipeline job in the Jenkins UI and point it to the local cloned repo on EC2.

## Learn

- Create a Pipeline job from the Jenkins dashboard
- Use `Pipeline script from SCM`
- Point Jenkins to the local cloned repo
- Run two simple stages: syntax check and unit tests

## Jenkins UI Steps

1. Open Jenkins in the browser.
2. Click **New Item**.
3. Enter a job name like `python-pipeline`.
4. Select **Pipeline** and click **OK**.
5. In **Pipeline**:
   - Definition: **Pipeline script from SCM**
   - SCM: **Git**
   - Repository URL: `/home/ec2-user/ncc-training`
   - Branch: `main`
   - Script Path: `07-Jenkins/lab-project/Jenkinsfile`
6. Click **Save**.
7. Click **Build Now**.

## Pipeline Flow

The Jenkinsfile runs two stages:

- **Syntax Check** — validates Python syntax
- **Unit Tests** — runs `unittest`

## Checkpoint

Can you create the Pipeline job from the UI and point it to the local repo path?
