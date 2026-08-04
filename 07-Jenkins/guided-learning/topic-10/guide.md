# Topic 10: Build on Push

**Time:** 20 minutes

## Goal

Configure Gitea to automatically trigger a Jenkins build when code is pushed to `main`.

## Commands to Use

No new terminal commands.

## Guided Steps

1. In Gitea, add a webhook to `http://<JENKINS_URL>/gitea-webhook/post`.
2. In the `gitea-pipeline` job, enable the Gitea webhook trigger.
3. Edit a file in Gitea, for example `VERSION`, and commit to `main`.
4. Watch Jenkins start a new build automatically.
5. Verify the build console output shows the latest commit.

## Checkpoint

What is the difference between a webhook trigger and polling SCM?

## Next Steps

Module complete! Review the full lessons if needed.
