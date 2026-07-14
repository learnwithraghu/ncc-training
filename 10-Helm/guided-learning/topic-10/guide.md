# Topic 10: Capstone Helm Mini Workflow

**Time:** 20 minutes

## Goal
Create a practical chart workflow for the document-search style application.

## Commands to Use
```bash
cd /workspaces/ncc-training/10-Helm/guided-learning/topic-10
mkdir -p workspace && cd workspace
helm create document-search
cp ../assets/document-search-values.yaml document-search/values.yaml
helm lint ./document-search
helm template doc-search ./document-search
helm install doc-search ./document-search --dry-run --debug
```

## Guided Steps
1. Generate a chart for the capstone app shape.
2. Replace starter values with app-focused values.
3. Lint and render manifests.
4. Dry-run install to confirm release readiness.

## Checkpoint
What additional chart changes would you make before deploying this to a shared cluster?
