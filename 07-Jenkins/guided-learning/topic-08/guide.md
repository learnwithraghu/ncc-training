# Topic 8: Gitea Integration

**Time:** 20 minutes

## Goal

Create a Gitea repository, upload the lab project files, and connect Jenkins to it.

## Commands to Use

No new terminal commands.

## Guided Steps

1. In Gitea, create a new repository named `jenkins-lab-project`.
2. Upload the files from `lab-project/` to the root of the repo via the Gitea console.
3. Create a Gitea access token with `repo` scope.
4. Add the token to Jenkins as a Secret text credential with ID `gitea-token`.
5. In Jenkins, create a new pipeline job named `gitea-pipeline`.
6. Choose **Pipeline script from SCM**, set SCM to Git, and point to the Gitea repo.
7. Run **Build Now**.

## Checkpoint

Why is the `Jenkinsfile` stored in the repository instead of inside the Jenkins job?

## Next Steps

Continue with [Lesson 9: Jenkins Features](../../09-jenkins-features.md).
