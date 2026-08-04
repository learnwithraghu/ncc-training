# Lesson 3: Create a Freestyle Job

This lesson shows how to create a Freestyle project in Jenkins. Freestyle jobs are a simple way to run shell commands, scripts, or tests.

## Learning Objectives

- Create a Freestyle project
- Add a shell build step
- Run a build manually
- Read the console output

## Prerequisites

- Jenkins is running and accessible

## Step 1: Create the Job

1. From the Jenkins dashboard, click **New Item**
2. Enter item name: `freestyle-lab-job`
3. Select **Freestyle project**
4. Click **OK**

## Step 2: Add a Build Step

1. Scroll down to the **Build Steps** section
2. Click **Add build step → Execute shell**
3. Paste the following:

```bash
#!/bin/bash
set -euo pipefail

echo "Starting build ${BUILD_NUMBER}"
echo "Current date: $(date)"
echo "Running as: $(whoami)"
echo "Build complete"
```

This prints build information using shell commands.

## Step 3: Save and Build

1. Click **Save**
2. On the job page, click **Build Now**
3. Watch the build appear in the **Build History** panel

## Step 4: View Console Output

1. Click the build number, for example `#1`
2. Click **Console Output**
3. You should see:

```text
Starting build 1
Current date: ...
Running as: jenkins
Build complete
```

## Checkpoint

> What is the difference between clicking **Build Now** and configuring a build trigger?

## Common Issues

### Commands Not Found

- Make sure the commands you use are available on the Jenkins agent
- Use full paths if needed, for example `/usr/bin/date`

### Empty Output

- Check that the build step is saved correctly
- Read the console output for syntax errors

## Key Takeaways

- Freestyle jobs are quick to set up through the UI
- **Execute shell** runs commands on the Jenkins agent
- Console output shows exactly what happened during the build

## Next Steps

[Lesson 4: Pipeline Basics](./04-jenkins-pipeline-basics.md) introduces pipelines as code.
