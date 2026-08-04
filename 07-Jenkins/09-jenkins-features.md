# Lesson 9: Jenkins Features

This lesson reviews useful Jenkins features that help you manage and inspect builds.

## Learning Objectives

- View and download build artifacts
- Read build history and trends
- Add parameters to a job
- Replay a pipeline

## Prerequisites

- A pipeline job from previous lessons

## Step 1: View Build History

1. Open any job page
2. The left panel shows the **Build History**
3. Click a build number to see its details
4. Use the **Previous Build** and **Next Build** links to navigate

## Step 2: Download Artifacts

If your pipeline archives files with `archiveArtifacts`, they appear on the build page.

1. Open a build that produced artifacts
2. Click **Build Artifacts**
3. Click a file name to download it

For example, from `lab-project/Jenkinsfile`:

```groovy
post {
    always {
        archiveArtifacts artifacts: 'output.txt', allowEmptyArchive: true
    }
}
```

## Step 3: Add a Parameter to a Job

1. Open a pipeline job and click **Configure**
2. Check **This project is parameterized**
3. Click **Add Parameter → String Parameter**
4. Set:
   - Name: `GREETING`
   - Default Value: `Hello from Jenkins!`
5. Click **Save**

Now when you click **Build with Parameters**, you can change the value.

Use it in the pipeline:

```groovy
pipeline {
    agent any

    parameters {
        string(name: 'GREETING', defaultValue: 'Hello from Jenkins!', description: 'A greeting message')
    }

    stages {
        stage('Greet') {
            steps {
                echo "${params.GREETING}"
            }
        }
    }
}
```

## Step 4: Replay a Pipeline

1. Open a finished build
2. Click **Replay** on the left menu
3. Edit the pipeline script
4. Click **Run**

Replay is useful for testing small changes without editing the job configuration.

## Checkpoint

> When would you use **Replay** instead of editing the job configuration?

## Common Issues

### Parameter Not Found

- Use `params.PARAM_NAME` to read the value
- Make sure the parameter is defined in the job or with the `parameters` block

### Artifacts Missing

- Verify `archiveArtifacts` is inside a `post` or `steps` block
- Check that the file path is correct

## Key Takeaways

- Build history shows past runs and their status
- Artifacts preserve files from each build
- Parameters make jobs reusable
- Replay lets you test pipeline changes quickly

## Next Steps

[Lesson 10: Build on Push](./10-jenkins-build-on-push.md) configures automatic builds when code is pushed to Gitea.
