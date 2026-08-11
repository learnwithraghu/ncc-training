# Topic 11: Multi-Stage Pipeline: Lint -> Test -> Package

**Time:** 20 minutes

## Goal
Add a Package stage that archives a build artifact, downloadable from the Jenkins console.

## Pipeline Script
Add this stage after `Test`, and this `post` block at the pipeline level (same level as `stages`):
```groovy
        stage('Package') {
            steps {
                sh 'cd app && tar -czf lab-app.tar.gz app.py requirements.txt'
            }
        }
    }

    post {
        success {
            archiveArtifacts artifacts: 'app/lab-app.tar.gz', fingerprint: true
        }
    }
}
```

## Guided Steps
1. Open `lab-pipeline` -> **Configure** and add the `Package` stage plus the top-level `post` block
   shown above (it goes after `stages { ... }`, not inside it).
2. Save, then **Build Now**.
3. Notice `tar` runs inside `app/` (the workspace copy from Topic 7's Prepare stage), and
   `archiveArtifacts` refers to `app/lab-app.tar.gz` - a path **relative to the workspace**, not
   the absolute `/opt/lab-project/...` path. `archiveArtifacts` only understands workspace-relative
   paths, which is exactly why everything got copied into `app/` in Topic 7.
4. On the build's page, find the **Build Artifacts** link and download `lab-app.tar.gz` straight
   from the browser.
5. Run the pipeline a second time and confirm each build keeps its own archived artifact.

## Checkpoint
Why archive the artifact with `archiveArtifacts` instead of just leaving `lab-app.tar.gz` sitting
in the workspace?
