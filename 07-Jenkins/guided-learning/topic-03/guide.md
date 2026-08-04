# Topic 3: Freestyle Job

**Time:** 20 minutes

## Goal

Create a Freestyle project that runs a shell script.

## Commands to Use

```bash
# Example commands used in the build step
echo "Starting build ${BUILD_NUMBER}"
date
whoami
```

## Guided Steps

1. Click **New Item** and name the job `freestyle-lab-job`.
2. Choose **Freestyle project** and click OK.
3. Under **Build Steps**, add **Execute shell**.
4. Enter a simple script:

```bash
#!/bin/bash
set -euo pipefail

echo "Starting build ${BUILD_NUMBER}"
echo "Current date: $(date)"
echo "Running as: $(whoami)"
echo "Build complete"
```

5. Save the job.
6. Click **Build Now**.
7. Open the build and read **Console Output**.

## Checkpoint

What does the **Console Output** show you after a build?

## Next Steps

Continue with [Lesson 4: Pipeline Basics](../../04-jenkins-pipeline-basics.md).
