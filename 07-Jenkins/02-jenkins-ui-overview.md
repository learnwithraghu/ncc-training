# Lesson 2: Jenkins UI Overview

This lesson introduces the Jenkins web interface. If you are using the lab environment, log in to the Jenkins URL your instructor provided.

## Learning Objectives

- Log in and navigate the Jenkins dashboard
- Understand the main menu items
- Verify installed plugins
- Create and manage credentials

## Step 1: Log In

1. Open your Jenkins URL in a browser.
   - Local Docker: `http://localhost:8080`
   - Lab environment: URL provided by your instructor

2. Enter your username and password.

## Step 2: Explore the Dashboard

After logging in, you see the Jenkins dashboard. Key areas:

- **New Item** — create jobs
- **People** — user management
- **Build History** — recent builds
- **Manage Jenkins** — configuration, plugins, credentials
- **My Views / All** — lists of jobs

## Step 3: Verify Plugins

1. Go to **Manage Jenkins → Plugins → Installed plugins**
2. Search for:
   - `Git` — for Git repositories
   - `Pipeline` — for pipeline jobs
   - `Gitea` or generic Git support for Gitea
3. If any are missing, install them and restart Jenkins.

## Step 4: Check Credentials

Jenkins stores secrets (passwords, tokens) in **Credentials**.

1. Go to **Manage Jenkins → Credentials**
2. Click **System → Global credentials (unrestricted)**
3. Here you will later add your Gitea token.

## Checkpoint

> What is the difference between a **plugin** and a **credential** in Jenkins?

## Common Issues

### Cannot Log In

- Check the Jenkins URL and port
- If using Docker, verify the container is running: `docker ps`
- Retrieve the initial admin password again: `docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword`

### Missing Plugins

- Go to **Manage Jenkins → Plugins → Available plugins**
- Search for the plugin name and install it
- Restart Jenkins when prompted

## Key Takeaways

- The dashboard is the starting point for all Jenkins work
- Plugins add features like Git and Gitea support
- Credentials keep secrets safe

## Next Steps

In [Lesson 3: Freestyle Job](./03-jenkins-freestyle-job.md), you will create your first Jenkins job.
