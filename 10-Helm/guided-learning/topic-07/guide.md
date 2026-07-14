# Topic 7: Lint, Template, and Dry Run Validation

**Time:** 20 minutes

## Goal
Validate charts before cluster install using linting and dry-run workflows.

## Commands to Use
```bash
cd /workspaces/ncc-training/10-Helm/guided-learning/topic-07
mkdir -p workspace && cd workspace
helm create validate-lab
helm lint ./validate-lab
helm template validate-lab ./validate-lab -f ../assets/values-dev.yaml
helm install validate-lab ./validate-lab --dry-run --debug -f ../assets/values-dev.yaml
```

## Guided Steps
1. Lint a generated chart to catch common issues.
2. Render templates with development overrides.
3. Simulate installation with dry-run and debug output.
4. Explain why validation should happen before real deployment.

## Checkpoint
What does --dry-run protect you from during deployment?
