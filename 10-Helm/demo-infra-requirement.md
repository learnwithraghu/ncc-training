# Demo Infra Requirement

## Infra Needed

- Helm CLI installed (`helm version`)
- Kubernetes cluster access through kubectl
- Network access to `https://charts.jenkins.io`
- Enough cluster capacity for one Jenkins controller (lab requests ~250m CPU / 512Mi)
- Free NodePort **32080** (and **32081** for the upgrade demo), or use port-forward

## Quick Validation

```bash
helm version
kubectl cluster-info
helm repo add jenkins https://charts.jenkins.io
helm repo update
helm search repo jenkins/jenkins | head -n 3
```

## Full Validation

```bash
bash ~/ncc-training/10-Helm/new-style/helpers/run-helm-lab.sh
```

The helper installs Signal Forge (official Jenkins chart), waits for Ready,
exercises upgrade/rollback and template/dry-run, then uninstalls and deletes
the `signal-forge` namespace.
