#!/usr/bin/env bash
# Instructor helper: deploy Daypack from topic 05–06 manifests on an
# existing cluster. No Docker required on this host.
set -euo pipefail

readonly IMAGE="learnwithraghu/ai-k8-workshop:1.0"
readonly NS="daypack"
readonly PF_PORT="18501"
readonly SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
readonly NEW_STYLE=$(cd "${SCRIPT_DIR}/.." && pwd)
readonly DEPLOY_DIR="${NEW_STYLE}/05-k8s-deployment"
readonly SERVICE_DIR="${NEW_STYLE}/06-k8s-service"

PASS=0
FAIL=0
PF_PID=""

GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

pass() { echo -e "  ${GREEN}ok${NC}  $1"; PASS=$((PASS + 1)); }
fail() { echo -e "  ${RED}fail${NC} $1"; FAIL=$((FAIL + 1)); }

usage() {
    cat <<EOF
Usage: bash deploy-k8s.sh

Clone the repo on the teaching cluster host, point kubectl at that
cluster, then run this script. It applies topic 05–06 manifests and
prints the port-forward command for the Daypack UI.

  git clone https://github.com/learnwithraghu/ncc-training.git
  cd ncc-training
  kubectl get nodes
  bash 15-ai-k8-full-project/new-style/helpers/deploy-k8s.sh

Namespace: ${NS}
Image: ${IMAGE}
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit 0
fi

stop_pf() {
    if [[ -n "$PF_PID" ]]; then
        kill "$PF_PID" >/dev/null 2>&1 || true
        wait "$PF_PID" >/dev/null 2>&1 || true
        PF_PID=""
    fi
    pkill -f "port-forward .* ${PF_PORT}:8501" >/dev/null 2>&1 || true
}

trap stop_pf EXIT

echo "Daypack — deploy on Kubernetes"
echo

command -v kubectl >/dev/null 2>&1 || { echo "kubectl not found"; exit 1; }
kubectl get nodes >/dev/null || { echo "kubectl cannot reach the cluster"; exit 1; }
pass "cluster reachable"

[[ -f "${DEPLOY_DIR}/namespace.yaml" ]] || { echo "missing ${DEPLOY_DIR}/namespace.yaml"; exit 1; }
[[ -f "${DEPLOY_DIR}/deployment.yaml" ]] || { echo "missing ${DEPLOY_DIR}/deployment.yaml"; exit 1; }
[[ -f "${SERVICE_DIR}/service.yaml" ]] || { echo "missing ${SERVICE_DIR}/service.yaml"; exit 1; }

echo -e "${CYAN}[apply] namespace + deployment + service${NC}"
kubectl apply -f "${DEPLOY_DIR}/namespace.yaml"
kubectl apply -f "${DEPLOY_DIR}/deployment.yaml"
kubectl apply -f "${SERVICE_DIR}/service.yaml"
pass "applied manifests from 05-k8s-deployment and 06-k8s-service"

echo -e "${CYAN}[wait] deployment/${NS} ready${NC}"
if kubectl rollout status "deployment/daypack" -n "$NS" --timeout=180s; then
    pass "deployment daypack is Ready"
else
    fail "deployment did not become Ready"
    kubectl get pods -n "$NS" || true
    kubectl describe pod -n "$NS" -l app=daypack || true
    exit 1
fi

kubectl get svc,endpoints -n "$NS"
pass "service and endpoints listed"

stop_pf
echo -e "${CYAN}[validate] short port-forward on :${PF_PORT}${NC}"
kubectl port-forward -n "$NS" "svc/daypack" "${PF_PORT}:8501" >/dev/null 2>&1 &
PF_PID=$!
sleep 3

if curl -fsS "http://127.0.0.1:${PF_PORT}/_stcore/health" >/dev/null; then
    pass "health via port-forward"
else
    fail "health check via port-forward failed"
fi

# Streamlit serves a JS shell; "Daypack" is not in the initial HTML.
if curl -fsS "http://127.0.0.1:${PF_PORT}" 2>/dev/null | grep -q "Streamlit"; then
    pass "homepage serves Streamlit shell"
else
    fail "homepage did not contain Streamlit"
fi

stop_pf

echo
echo "=============================================="
echo " Open the UI (leave this running):"
echo
echo "   kubectl port-forward svc/daypack 8501:8501 -n daypack"
echo
echo " Then browse: http://localhost:8501"
echo "=============================================="
echo

if [[ "$FAIL" -gt 0 ]]; then
    echo -e "${RED}${FAIL} check(s) failed, ${PASS} passed${NC}"
    exit 1
fi

echo -e "${GREEN}All checks passed (${PASS})${NC}"
exit 0
