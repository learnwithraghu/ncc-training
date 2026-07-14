# Topic 6: Service and Deployment Templating

**Time:** 20 minutes

## Goal
Customize deployment and service settings in a chart and validate output.

## Commands to Use
```bash
cd /workspaces/ncc-training/10-Helm/guided-learning/topic-06
mkdir -p workspace && cd workspace
helm create app-lab
cat app-lab/templates/deployment.yaml
cat app-lab/templates/service.yaml
helm template app-lab ./app-lab --set image.repository=nginx --set image.tag=1.25 --set service.port=8080
```

## Guided Steps
1. Inspect deployment and service templates.
2. Override image and service values during rendering.
3. Validate generated ports and container image fields.
4. Describe how templates stay reusable across environments.

## Checkpoint
How does templating reduce duplication across dev, staging, and prod?
