# Topic 9: Image Tagging and Lifecycle

**Time:** 20 minutes

## Goal
Tag images clearly and manage image versions.

## Commands to Use
```bash
docker tag ncc-training-app:1.0 ncc-training-app:latest
docker images | grep ncc-training-app
docker rmi ncc-training-app:latest
docker rmi ncc-training-app:1.0
```

## Guided Steps
1. Create a second tag for the same image.
2. List the image tags.
3. Remove one tag and explain what changed.
4. Remove the final tag.
5. Talk about versioned tags in CI/CD.

## Checkpoint
Why is `latest` not a good only tag for production images?
