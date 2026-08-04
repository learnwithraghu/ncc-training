# Lesson 8: Gitea Integration

This lesson connects Jenkins to a Gitea repository. You will create a repo in Gitea, upload the `lab-project/` files through the Gitea web console, and configure Jenkins to use the `Jenkinsfile` from that repo.

## Learning Objectives

- Create a repository in Gitea
- Upload files using the Gitea web console
- Add a Gitea access token to Jenkins credentials
- Create a Jenkins pipeline that reads a `Jenkinsfile` from Gitea

## Prerequisites

- Jenkins is running
- Gitea is running and accessible
- The `lab-project/` folder from this repository

## Step 1: Create a Gitea Repository

1. Log in to your Gitea server
2. Click the **+** icon → **New Repository**
3. Enter:
   - Owner: your username
   - Repository name: `jenkins-lab-project`
   - Visibility: **Private** or **Public** (your choice)
   - Check **Initialize Repository** (optional)
4. Click **Create Repository**

## Step 2: Upload the Lab Project Files

1. In the new repo, click **Add File → Upload files**
2. Upload the contents of the `lab-project/` folder from this repository:
   - `README.md`
   - `app.sh`
   - `run.sh`
   - `test.sh`
   - `VERSION`
   - `Jenkinsfile`
3. Make sure the files land at the root of the repo (same folder structure as `lab-project/`)
4. Add a commit message such as `Initial commit of lab project`
5. Click **Commit changes**

## Step 3: Create a Gitea Access Token

1. In Gitea, click your profile picture → **Settings → Applications**
2. Under **Manage Access Tokens**, create a new token:
   - Token name: `jenkins-token`
   - Select at least **repo** scope
3. Click **Generate Token**
4. Copy the token immediately (you will not see it again)

## Step 4: Add the Token to Jenkins Credentials

1. In Jenkins, go to **Manage Jenkins → Credentials**
2. Click **System → Global credentials (unrestricted)**
3. Click **Add Credentials**
4. Choose:
   - Kind: **Secret text**
   - Secret: paste the Gitea token
   - ID: `gitea-token`
   - Description: `Gitea access token`
5. Click **OK**

## Step 5: Create a Jenkins Pipeline from SCM

1. Click **New Item**
2. Name: `gitea-pipeline`
3. Select **Pipeline**
4. Click **OK**

In the pipeline configuration:

1. Scroll to **Pipeline**
2. Definition: **Pipeline script from SCM**
3. SCM: **Git**
4. Repository URL: `http://<GITEA_HOST>:3000/<USERNAME>/jenkins-lab-project.git`
   - Replace the host, port, and username
5. Credentials: select `gitea-token`
6. Branch specifier: `*/main`
7. Script path: `Jenkinsfile`
8. Click **Save**

## Step 6: Build the Pipeline

1. Click **Build Now**
2. Jenkins will clone the repo and run the `Jenkinsfile`
3. Open the console output to verify the pipeline ran

## Checkpoint

> Why is it better to store the Gitea token in Jenkins credentials instead of pasting it directly into the pipeline?

## Common Issues

### Cannot Connect to Gitea

- Verify the Gitea URL and port
- Make sure the repository name and username are correct
- Check that the token has the `repo` scope

### Jenkinsfile Not Found

- Make sure `Jenkinsfile` is at the root of the Gitea repo
- Verify the **Script Path** field says `Jenkinsfile`

## Key Takeaways

- Gitea repos can be created through the web UI
- Files can be uploaded directly in Gitea
- Jenkins credentials keep tokens secure
- **Pipeline script from SCM** lets Jenkins use the repo's `Jenkinsfile`

## Next Steps

[Lesson 9: Jenkins Features](./09-jenkins-features.md) explores artifacts, parameters, and build history.
