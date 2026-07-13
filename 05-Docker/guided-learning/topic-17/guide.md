# Topic 17: Registry and ECR Concepts

**Time:** 20 minutes

## Goal
Understand how images move from a local build to a registry.

## Commands to Use
```bash
docker login
docker tag ncc-training-app:1.0 your-registry.example.com/ncc-training-app:1.0
docker push your-registry.example.com/ncc-training-app:1.0
```

## Guided Steps
1. Explain what a container registry stores.
2. Show how to tag an image for a registry.
3. Talk through the push workflow.
4. Connect the idea to ECR and CI/CD.
5. Mention how tags support release versions.

## Checkpoint
Why do teams tag images before they push them to a registry?
