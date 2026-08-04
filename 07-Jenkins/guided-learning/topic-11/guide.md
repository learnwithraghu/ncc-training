# Topic 11: Gitea Integration

This lesson connects Jenkins to a Gitea repository. The repository will contain both the shell lab and the Docker example used in Topic 12.

## Learning Objectives

- Create a repository in Gitea
- Upload the lab project and Docker example
- Add a Gitea access token to Jenkins credentials
- Create a Jenkins pipeline that reads a Jenkinsfile from Gitea

## Prerequisites

- Jenkins is running and accessible
- Gitea is running and accessible
- The `lab-project/` folder from this repository

## Step 1: Create a Gitea Repository

1. Log in to Gitea.
2. Click **+ → New Repository**.
3. Name the repository `jenkins-lab-project`.
4. Choose **Private** or **Public** and click **Create Repository**.

## Step 2: Upload the Project

Upload the contents of `lab-project/`, preserving this structure:

```text
Jenkinsfile
app.sh
run.sh
test.sh
VERSION
docker-example/Dockerfile
docker-example/README.md
docker-example/Jenkinsfile
```

Commit the files to the `main` branch.

## Step 3: Add the Gitea Credential

1. In Gitea, open **Settings → Applications**.
2. Create an access token named `jenkins-token` with at least `repo` scope.
3. Copy the token.
4. In Jenkins, open **Manage Jenkins → Credentials**.
5. Add a **Secret text** credential with ID `gitea-token`.

## Step 4: Create a Pipeline from SCM

1. Create a Pipeline job named `gitea-pipeline`.
2. Set **Definition** to **Pipeline script from SCM**.
3. Select **Git**.
4. Set the repository URL to `http://<GITEA_HOST>:3000/<USERNAME>/jenkins-lab-project.git`.
5. Select the `gitea-token` credential.
6. Set the branch to `*/main` and the script path to `Jenkinsfile`.
7. Save and click **Build Now**.

## Checkpoint

> Why should the Gitea token be stored in Jenkins credentials instead of the Jenkinsfile?

## Common Issues

### Jenkins Cannot Clone the Repository

- Verify the URL, username, branch, and token scope.
- Confirm Jenkins can reach the Gitea host from its network.

### Docker Example Files Are Missing

- Preserve the `docker-example/` folder during upload.
- Confirm the files are committed to `main`.

## Key Takeaways

- Jenkins can load a version-controlled Jenkinsfile from Gitea.
- Repository folders are available to later build stages.
- Credentials keep access tokens out of source code.

## Next Steps

[Lesson 12: Docker Build from Gitea](../topic-12/guide.md) builds the image from the repository without pushing it.
