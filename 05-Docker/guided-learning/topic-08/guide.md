# Topic 8: Build the Sample App Image

**Time:** 20 minutes

## Goal
Build the sample Flask app image from the repository Dockerfile.

## Commands to Use
```bash
cd /workspaces/ncc-training/05-Docker/application
vi Dockerfile
docker build -t ncc-training-app:1.0 .
docker images | grep ncc-training-app
```

## Guided Steps
1. Open the sample Dockerfile in `vi`.
2. Review the base image, workdir, copy steps, and health check.
3. Build the app image.
4. Confirm the image exists locally.
5. Explain how the Dockerfile turns source code into a runnable artifact.

## Checkpoint
Why do we copy `requirements.txt` before the application code in the Dockerfile?
