# Lesson 10: Build on Push to Main

This lesson configures Gitea to automatically trigger a Jenkins build whenever code is pushed to the `main` branch.

## Learning Objectives

- Understand how webhooks work
- Configure a Gitea webhook
- Enable a webhook trigger in a Jenkins job
- Test the integration by pushing a change

## Prerequisites

- Jenkins connected to a Gitea repository (Lesson 8)
- The `gitea-pipeline` job exists

## Step 1: Find the Jenkins Webhook URL

Jenkins accepts webhook requests at:

```text
http://<JENKINS_URL>/gitea-webhook/post
```

For example:

```text
http://jenkins-server:8080/gitea-webhook/post
```

## Step 2: Add a Webhook in Gitea

1. Open your Gitea repository
2. Click **Settings → Webhooks → Add Webhook → Gitea**
3. Configure:
   - **Target URL**: `http://<JENKINS_URL>/gitea-webhook/post`
   - **HTTP Method**: `POST`
   - **Post Content Type**: `application/json`
   - **Trigger On**: `Push Events`
   - **Active**: checked
4. Click **Add Webhook**

## Step 3: Enable the Trigger in Jenkins

1. Open the `gitea-pipeline` job
2. Click **Configure**
3. Scroll to **Build Triggers**
4. Check **Build when a change is pushed to Gitea**
   - If you do not see this option, the generic trigger is:
   - Check **Poll SCM** and set schedule to `H/5 * * * *` (polls every 5 minutes)
5. Click **Save**

## Step 4: Test the Webhook

1. In Gitea, open a file in the repository
2. Click the edit icon
3. Make a small change, for example update `VERSION` to `1.0.1`
4. Commit directly to the `main` branch
5. Go back to Jenkins
6. Within a few seconds, a new build should start automatically

## Step 5: Verify the Build

1. Click the new build number
2. Open **Console Output**
3. Confirm Jenkins checked out the latest commit and ran the pipeline

## Checkpoint

> What is the difference between a webhook trigger and polling SCM?

## Common Issues

### Webhook Test Fails in Gitea

- Check the webhook URL and port
- Make sure Jenkins is reachable from the Gitea server
- Look at the webhook **Recent Deliveries** in Gitea for error details

### Build Does Not Start

- Verify the job trigger is enabled
- Check that the commit was pushed to the `main` branch
- Make sure the webhook secret matches if one is configured

## Key Takeaways

- Webhooks notify Jenkins about repository events
- Gitea can push events to Jenkins on every commit
- `main` branch pushes can trigger builds automatically

## Module Complete

You have now:

- Set up Jenkins with Docker (or used a lab instance)
- Created freestyle and pipeline jobs
- Learned Groovy basics
- Integrated Jenkins with Gitea
- Triggered builds automatically on push

## Key Commands Reference

```bash
# Docker Jenkins
 docker pull jenkins/jenkins:lts-jdk17
 docker volume create jenkins-home
 docker run -d --name jenkins -p 8080:8080 -p 50000:50000 \
   -v jenkins-home:/var/jenkins_home jenkins/jenkins:lts-jdk17
 docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

Great work! You are ready to use Jenkins in real CI/CD workflows.
