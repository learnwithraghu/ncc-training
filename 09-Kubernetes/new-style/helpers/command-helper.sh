#!/usr/bin/env bash
# Instructor command helper: run every kubectl command from topics 01–07
# against the teaching cluster. Uses a scratch namespace and deletes it
# at the end. Does not need Docker on this machine.
set -uo pipefail

readonly IMAGE="learnwithraghu/ncc-workshop"
readonly NS="orbital-relay-lab"
readonly PF_PORT="18090"
readonly SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
readonly ROOT=$(cd "${SCRIPT_DIR}/.." && pwd)

PASS=0
FAIL=0
PF_PID=""
PREV_NS=""

GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

pass() { echo -e "  ${GREEN}ok${NC}  $1"; PASS=$((PASS + 1)); }
fail() { echo -e "  ${RED}fail${NC} $1"; FAIL=$((FAIL + 1)); }

usage() {
    cat <<EOF
Usage: bash command-helper.sh

Clone the repo on the teaching cluster host, point kubectl at that
cluster, then run this script. It applies every topic folder and runs
the kubectl commands from each guide (Pod, Deployment, Service,
rollout, ConfigMap/Secret, logs/exec, probes).

  git clone https://github.com/learnwithraghu/ncc-training.git
  cd ncc-training
  kubectl get nodes
  bash 09-Kubernetes/new-style/helpers/command-helper.sh

Scratch namespace: ${NS} (deleted when the script finishes).
Images: ${IMAGE}:1.0 and :2.0 (public Docker Hub).
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
    pkill -f "port-forward .* ${PF_PORT}:80" >/dev/null 2>&1 || true
    sleep 1
}

restore_ns() {
    stop_pf
    if [[ -n "$PREV_NS" ]]; then
        kubectl config set-context --current --namespace="$PREV_NS" >/dev/null 2>&1 || true
    fi
}

cleanup() {
    restore_ns
    kubectl delete namespace "$NS" --wait=false >/dev/null 2>&1 || true
}
trap cleanup EXIT

wait_ready_pods() {
    local want="$1"
    local i
    for i in $(seq 1 60); do
        local ready
        ready=$(kubectl get pods -l app=orbital-relay \
            --no-headers 2>/dev/null | awk '$2 ~ /1\/1/ && $3=="Running" {c++} END {print c+0}')
        if [[ "$ready" -ge "$want" ]]; then
            return 0
        fi
        if kubectl get pods -l app=orbital-relay --no-headers 2>/dev/null | grep -q ImagePullBackOff; then
            kubectl describe pods -l app=orbital-relay | tail -n 30
            return 1
        fi
        sleep 2
    done
    kubectl get pods -o wide
    return 1
}

wait_mark() {
    local url="$1"
    local mark="$2"
    local i
    for i in $(seq 1 20); do
        if curl -fsS "$url" 2>/dev/null | grep -q "$mark"; then
            return 0
        fi
        sleep 1
    done
    return 1
}

start_pf() {
    local target="$1"
    local i
    stop_pf
    for i in $(seq 1 8); do
        kubectl port-forward "$target" "${PF_PORT}:80" >/dev/null 2>&1 &
        PF_PID=$!
        sleep 2
        if curl -fsS -o /dev/null "http://127.0.0.1:${PF_PORT}" 2>/dev/null; then
            return 0
        fi
        stop_pf
    done
    return 1
}

curl_pf() {
    local target="$1"
    local mark="$2"
    if ! start_pf "$target"; then
        fail "port-forward ${target} on :${PF_PORT} never answered"
        return
    fi
    if wait_mark "http://127.0.0.1:${PF_PORT}" "$mark"; then
        pass "curl ${target} → '${mark}'"
    else
        echo "    body:"
        curl -sS "http://127.0.0.1:${PF_PORT}" 2>/dev/null | head -n 8 | sed 's/^/      /'
        fail "curl ${target} did not show '${mark}'"
    fi
    stop_pf
}

wipe_workloads() {
    kubectl delete pod,deploy,svc,cm,secret -l app=orbital-relay --wait=true --timeout=60s >/dev/null 2>&1 || true
    kubectl delete pod orbital-relay --wait=true --timeout=60s >/dev/null 2>&1 || true
}

echo "NCC Kubernetes — command helper"
echo "Cluster commands from topics 01–07, namespace ${NS}"
echo

echo -e "${CYAN}[pre] cluster${NC}"
if ! command -v kubectl >/dev/null; then
    fail "kubectl is not on PATH"
    exit 1
fi
pass "kubectl $(kubectl version --client -o yaml 2>/dev/null | awk '/gitVersion:/ {print $2; exit}')"

if kubectl cluster-info >/dev/null 2>&1; then
    pass "kubectl cluster-info"
else
    fail "kubectl cluster-info (kubeconfig not pointed at a cluster)"
    exit 1
fi

if kubectl get nodes >/dev/null 2>&1; then
    pass "kubectl get nodes"
    kubectl get nodes
else
    fail "kubectl get nodes"
    exit 1
fi

for verb_res in \
    "create namespaces" \
    "create pods" \
    "create deployments" \
    "create services" \
    "create configmaps" \
    "create secrets"; do
    if kubectl auth can-i $verb_res >/dev/null 2>&1; then
        pass "can-i ${verb_res}"
    else
        fail "can-i ${verb_res}"
    fi
done

PREV_NS=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null || true)
[[ -z "$PREV_NS" ]] && PREV_NS="default"

kubectl delete namespace "$NS" --wait=true --timeout=90s >/dev/null 2>&1 || true

echo
echo -e "${CYAN}[01] run a pod${NC}"
if kubectl create namespace "$NS"; then
    pass "kubectl create namespace ${NS}"
else
    fail "kubectl create namespace ${NS}"
    exit 1
fi
if kubectl config set-context --current --namespace="$NS" >/dev/null; then
    pass "kubectl config set-context --namespace=${NS}"
else
    fail "kubectl config set-context"
fi

kubectl apply -f "${ROOT}/01-run-a-pod/pod.yaml"
if kubectl wait --for=condition=Ready pod/orbital-relay --timeout=120s >/dev/null 2>&1; then
    pass "pod/orbital-relay Ready"
else
    kubectl describe pod orbital-relay | tail -n 40
    fail "pod/orbital-relay did not become Ready (image pull?)"
fi
kubectl get pods -o wide >/dev/null && pass "kubectl get pods -o wide"
curl_pf pod/orbital-relay "Ground link v1"

echo
echo -e "${CYAN}[02] deployment and scaling${NC}"
kubectl delete pod orbital-relay --wait=true --timeout=60s >/dev/null 2>&1 || true
kubectl apply -f "${ROOT}/02-deployment-and-scaling/deployment.yaml"
if wait_ready_pods 2; then
    pass "deployment at 2 Ready replicas"
else
    fail "deployment did not reach 2 Ready replicas"
fi
kubectl get deployments,replicasets,pods >/dev/null && pass "kubectl get deployments,replicasets,pods"
kubectl scale deployment/orbital-relay --replicas=4
if wait_ready_pods 4; then
    pass "kubectl scale --replicas=4"
else
    fail "scale to 4 failed"
fi
ONE=$(kubectl get pods -l app=orbital-relay -o jsonpath='{.items[0].metadata.name}')
kubectl delete pod "$ONE" >/dev/null
if wait_ready_pods 4; then
    pass "deleted ${ONE}; ReplicaSet restored 4 pods"
else
    fail "self-heal after pod delete failed"
fi

echo
echo -e "${CYAN}[03] expose with a service${NC}"
wipe_workloads
kubectl apply -f "${ROOT}/03-expose-with-service/deployment.yaml"
kubectl apply -f "${ROOT}/03-expose-with-service/service.yaml"
wait_ready_pods 2 || fail "topic 3 pods not Ready"
kubectl get svc orbital-relay >/dev/null && pass "kubectl get svc orbital-relay"
EP=$(kubectl get endpoints orbital-relay -o jsonpath='{.subsets[0].addresses}' 2>/dev/null || true)
if [[ -n "$EP" ]]; then
    pass "kubectl get endpoints orbital-relay"
else
    fail "no endpoints for svc/orbital-relay"
fi
NODEPORT=$(kubectl get svc orbital-relay -o jsonpath='{.spec.ports[0].nodePort}')
[[ "$NODEPORT" == "30080" ]] && pass "NodePort 30080" || fail "NodePort was ${NODEPORT}, expected 30080"
curl_pf svc/orbital-relay "Ground link v1"
ONE=$(kubectl get pods -l app=orbital-relay -o jsonpath='{.items[0].metadata.name}')
kubectl delete pod "$ONE" >/dev/null
wait_ready_pods 2 || true
if kubectl get endpoints orbital-relay -o jsonpath='{.subsets[0].addresses}' | grep -q .; then
    pass "endpoints updated after pod delete"
else
    fail "endpoints empty after pod replace"
fi

echo
echo -e "${CYAN}[04] rolling update and rollback${NC}"
wipe_workloads
kubectl apply -f "${ROOT}/04-rolling-update-and-rollback/deployment.yaml"
kubectl apply -f "${ROOT}/04-rolling-update-and-rollback/service.yaml"
wait_ready_pods 2 || fail "topic 4 pods not Ready"
curl_pf svc/orbital-relay "Ground link v1"
kubectl set image deployment/orbital-relay web="${IMAGE}:2.0"
if kubectl rollout status deployment/orbital-relay --timeout=120s >/dev/null && wait_ready_pods 2; then
    pass "kubectl set image …:2.0 + rollout status"
    sleep 3
    curl_pf svc/orbital-relay "Night Pass v2"
else
    fail "rollout to :2.0 failed"
fi
kubectl rollout history deployment/orbital-relay >/dev/null && pass "kubectl rollout history"
kubectl rollout undo deployment/orbital-relay >/dev/null
if kubectl rollout status deployment/orbital-relay --timeout=120s >/dev/null && wait_ready_pods 2; then
    pass "kubectl rollout undo"
    sleep 3
    curl_pf svc/orbital-relay "Ground link v1"
else
    fail "rollout undo failed"
fi

echo
echo -e "${CYAN}[05] configmap and secret${NC}"
wipe_workloads
kubectl apply -f "${ROOT}/05-configmap-and-secret/station-config.yaml"
kubectl apply -f "${ROOT}/05-configmap-and-secret/station-secret.yaml"
kubectl apply -f "${ROOT}/05-configmap-and-secret/deployment.yaml"
kubectl apply -f "${ROOT}/05-configmap-and-secret/service.yaml"
wait_ready_pods 2 || fail "topic 5 pods not Ready"
ENVS=$(kubectl exec deploy/orbital-relay -- env 2>/dev/null || true)
echo "$ENVS" | grep -q STATION_NAME=Svalbard-2 && pass "exec env STATION_NAME" || fail "STATION_NAME missing in exec env"
echo "$ENVS" | grep -q STATION_REGION && pass "exec env STATION_REGION" || fail "STATION_REGION missing"
echo "$ENVS" | grep -q RELAY_API_TOKEN && pass "exec env RELAY_API_TOKEN" || fail "RELAY_API_TOKEN missing"
kubectl get configmap station-config -o yaml >/dev/null && pass "kubectl get configmap -o yaml"
DECODED=$(kubectl get secret station-secret -o jsonpath='{.data.RELAY_API_TOKEN}' | base64 -d)
[[ "$DECODED" == "orbital-lab-token-not-real" ]] && pass "secret decode RELAY_API_TOKEN" || fail "secret decode mismatch"

echo
echo -e "${CYAN}[06] logs and exec${NC}"
wipe_workloads
kubectl apply -f "${ROOT}/06-logs-and-exec/deployment.yaml" -f "${ROOT}/06-logs-and-exec/service.yaml"
wait_ready_pods 2 || fail "topic 6 pods not Ready"
curl_pf svc/orbital-relay "Ground link v1"
kubectl logs deploy/orbital-relay >/dev/null && pass "kubectl logs deploy/orbital-relay"
kubectl exec deploy/orbital-relay -- ls /usr/share/nginx/html >/dev/null && pass "kubectl exec -- ls html"
kubectl set image deployment/orbital-relay web=nginx:1.27-alpine
if kubectl rollout status deployment/orbital-relay --timeout=120s >/dev/null && wait_ready_pods 2; then
    pass "set image nginx:1.27-alpine"
else
    fail "break-with-nginx rollout failed"
fi
kubectl describe pod -l app=orbital-relay >/dev/null && pass "kubectl describe pod"
NGINX_POD=$(kubectl get pods -l app=orbital-relay -o jsonpath='{range .items[*]}{.metadata.name}{" "}{.spec.containers[0].image}{"\n"}{end}' | awk '/nginx:1.27/ {print $1; exit}')
HTML=""
if [[ -n "$NGINX_POD" ]]; then
    HTML=$(kubectl exec "$NGINX_POD" -- cat /usr/share/nginx/html/index.html 2>/dev/null || true)
fi
echo "$HTML" | grep -qiE 'welcome to nginx|nginx' && pass "exec cat index.html shows stock nginx" || fail "broken image did not look like stock nginx"
kubectl apply -f "${ROOT}/06-logs-and-exec/deployment.yaml" >/dev/null
kubectl rollout status deployment/orbital-relay --timeout=120s >/dev/null
wait_ready_pods 2
sleep 3
curl_pf svc/orbital-relay "Ground link v1"

echo
echo -e "${CYAN}[07] health checks and limits${NC}"
wipe_workloads
kubectl apply -f "${ROOT}/07-health-checks-and-limits/deployment.yaml" -f "${ROOT}/07-health-checks-and-limits/service.yaml"
wait_ready_pods 2 || fail "topic 7 pods not Ready"
DESC=$(kubectl describe pod -l app=orbital-relay)
echo "$DESC" | grep -q Liveness && pass "describe shows Liveness" || fail "no Liveness in describe"
echo "$DESC" | grep -q Readiness && pass "describe shows Readiness" || fail "no Readiness in describe"
echo "$DESC" | grep -q Limits && pass "describe shows Limits" || fail "no Limits in describe"
kubectl patch deployment orbital-relay --type=json \
    -p='[{"op":"replace","path":"/spec/template/spec/containers/0/readinessProbe/httpGet/port","value":81}]' >/dev/null
broken=0
for i in $(seq 1 45); do
    not_ready=$(kubectl get pods -l app=orbital-relay --no-headers 2>/dev/null | awk '$2=="0/1" && $3=="Running" {c++} END {print c+0}')
    still_ready=$(kubectl get pods -l app=orbital-relay --no-headers 2>/dev/null | awk '$2=="1/1" {c++} END {print c+0}')
    ep=$(kubectl get endpoints orbital-relay -o jsonpath='{.subsets[0].addresses}' 2>/dev/null || true)
    if [[ "$not_ready" -ge 2 && "$still_ready" -eq 0 && -z "$ep" ]]; then
        broken=1
        break
    fi
    sleep 2
done
if [[ "$broken" -eq 1 ]]; then
    pass "broken readiness: Running but 0/1 READY, endpoints empty"
else
    kubectl get pods -l app=orbital-relay
    kubectl get endpoints orbital-relay
    fail "readiness break did not drain Ready pods / endpoints"
fi
kubectl apply -f "${ROOT}/07-health-checks-and-limits/deployment.yaml" >/dev/null
if wait_ready_pods 2; then
    pass "restored probes, pods 1/1 READY"
else
    fail "restore after readiness break failed"
fi

echo
echo "============================================================"
echo "  passed: ${PASS}    failed: ${FAIL}"
echo "============================================================"
if [[ "$FAIL" -gt 0 ]]; then
    echo "Fix the failures before teaching. Namespace ${NS} will be deleted."
    exit 1
fi
echo "Lab commands are ready. Teach from 01-run-a-pod."
exit 0
