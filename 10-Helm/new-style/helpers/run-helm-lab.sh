#!/usr/bin/env bash
# Instructor helper: exercise the Signal Forge (Jenkins) Helm lab end-to-end.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NS="signal-forge"
RELEASE="signal-forge"
VALUES_LAB="${ROOT_DIR}/03-install-jenkins/values-lab.yaml"
VALUES_UPG="${ROOT_DIR}/06-upgrade-and-rollback/values-upgrade.yaml"

echo "==> Checking tools"
helm version
kubectl cluster-info >/dev/null

echo "==> Namespace + Jenkins repo"
kubectl create namespace "${NS}" --dry-run=client -o yaml | kubectl apply -f -
helm repo add jenkins https://charts.jenkins.io 2>/dev/null || true
helm repo update

echo "==> Clean any previous release"
helm uninstall "${RELEASE}" -n "${NS}" 2>/dev/null || true

echo "==> Install Signal Forge with lab values"
helm install "${RELEASE}" jenkins/jenkins -n "${NS}" -f "${VALUES_LAB}"

echo "==> Wait for Jenkins controller"
# Chart creates a StatefulSet named <release>-jenkins
if kubectl get statefulset "${RELEASE}-jenkins" -n "${NS}" >/dev/null 2>&1; then
  kubectl rollout status statefulset/"${RELEASE}-jenkins" -n "${NS}" --timeout=600s
else
  echo "Waiting for pods labeled app.kubernetes.io/instance=${RELEASE}..."
  kubectl wait --for=condition=Ready pod -l "app.kubernetes.io/instance=${RELEASE}" -n "${NS}" --timeout=600s
fi

echo "==> Smoke-check Service"
kubectl get svc -n "${NS}"
helm status "${RELEASE}" -n "${NS}"

echo "==> Upgrade then rollback"
helm upgrade "${RELEASE}" jenkins/jenkins -n "${NS}" -f "${VALUES_UPG}"
helm history "${RELEASE}" -n "${NS}"
helm rollback "${RELEASE}" 1 -n "${NS}"
helm history "${RELEASE}" -n "${NS}"

echo "==> Template + dry-run"
helm template "${RELEASE}" jenkins/jenkins -n "${NS}" -f "${VALUES_LAB}" | grep -q "32080"
helm upgrade "${RELEASE}" jenkins/jenkins -n "${NS}" -f "${VALUES_UPG}" --dry-run >/dev/null

echo "==> Uninstall"
helm uninstall "${RELEASE}" -n "${NS}"
kubectl delete namespace "${NS}" --wait=false

echo "==> Helm lab check complete"
