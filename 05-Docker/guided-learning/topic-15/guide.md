# Topic 15: Security and Non-Root Users

**Time:** 20 minutes

## Goal
Reduce container risk by running as a non-root user.

## Commands to Use
```bash
cd /workspaces/ncc-training/05-Docker/application
vi Dockerfile
docker build -t ncc-training-app:secure .
docker run --rm ncc-training-app:secure id
```

## Guided Steps
1. Open the Dockerfile and review user settings.
2. Explain why running as root is risky.
3. Add or confirm a non-root user strategy.
4. Rebuild the image.
5. Check the user identity inside the container.

## Checkpoint
Why should production containers avoid running as root whenever possible?
