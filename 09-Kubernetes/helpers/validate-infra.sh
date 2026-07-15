#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_NAME="NCC Kubernetes Training - Infrastructure Validator"
readonly SEP="============================================================"
readonly SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
readonly MODULE_DIR="${SCRIPT_DIR}/.."
readonly SANDBOX="/tmp/ncc-k8s-validation-$$"
readonly NAMESPACE="ncc-k8s-val-$$"
readonly ORIGINAL_NAMESPACE=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null || echo 'default')
readonly LABEL="ncc-training-validator=true"

PASS=0
WARN=0
FAIL=0

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

cleanup() {
    echo ""
    echo -e "${CYAN}[cleanup]${NC} Removing validation resources..."

    kubectl delete namespace "$NAMESPACE" --ignore-not-found=true --wait=false &>/dev/null || true
    for ns in dev staging production testing backend frontend; do
        kubectl delete namespace "$ns" --ignore-not-found=true --wait=false &>/dev/null || true
    done

    kubectl delete pv my-pv --ignore-not-found=true --wait=false &>/dev/null || true

    if [ -n "$ORIGINAL_NAMESPACE" ]; then
        kubectl config set-context --current --namespace="$ORIGINAL_NAMESPACE" &>/dev/null || true
    else
        kubectl config set-context --current --namespace=default &>/dev/null || true
    fi

    rm -rf "$SANDBOX"
}
trap cleanup EXIT

rm -rf "$SANDBOX"
mkdir -p "$SANDBOX"

echo -e "${CYAN}${SEP}${NC}"
echo -e "${CYAN}  ${SCRIPT_NAME}${NC}"
echo -e "${CYAN}${SEP}${NC}"
echo ""

# ── Environment info ──────────────────────────────────────────────────

echo -e "${CYAN}[info]${NC} Environment"
echo "  User      : $(whoami 2>/dev/null || echo 'unknown')"
echo "  Hostname  : $(hostname 2>/dev/null || echo 'unknown')"
echo "  Kernel    : $(uname -srm 2>/dev/null || echo 'unknown')"
echo "  Namespace : ${NAMESPACE}"
echo ""

# ── Helpers ───────────────────────────────────────────────────────────

check_cmd() {
    local cmd="$1" tag="${2:-}"
    if command -v "$cmd" &>/dev/null; then
        echo -e "  ${GREEN}[PASS]${NC} ${tag} ${cmd}"
        PASS=$((PASS + 1)); return 0
    else
        echo -e "  ${RED}[FAIL]${NC} ${tag} ${cmd}  (not found)"
        FAIL=$((FAIL + 1)); return 1
    fi
}

warn_cmd() {
    local cmd="$1" tag="${2:-}"
    if command -v "$cmd" &>/dev/null; then
        echo -e "  ${GREEN}[PASS]${NC} ${tag} ${cmd}"
        PASS=$((PASS + 1))
    else
        echo -e "  ${YELLOW}[WARN]${NC} ${tag} ${cmd}  (not found — optional)"
        WARN=$((WARN + 1))
    fi
}

k8s_ok() {
    local desc="$1" cmd="$2" tag="${3:-k8s}"
    local out
    out=$(eval "$cmd" 2>&1) && true
    local rc=$?
    if [ "$rc" -eq 0 ]; then
        echo -e "  ${GREEN}[PASS]${NC} ${tag} ${desc}"
        PASS=$((PASS + 1)); return 0
    else
        echo -e "  ${RED}[FAIL]${NC} ${tag} ${desc}  (${out})"
        FAIL=$((FAIL + 1)); return 1
    fi
}

k8s_expect() {
    local desc="$1" cmd="$2" expected="$3" tag="${4:-k8s}"
    local out
    out=$(eval "$cmd" 2>&1) && true
    local rc=$?
    if [ "$rc" -eq 0 ] && echo "$out" | grep -qF "$expected"; then
        echo -e "  ${GREEN}[PASS]${NC} ${tag} ${desc}"
        PASS=$((PASS + 1)); return 0
    else
        echo -e "  ${RED}[FAIL]${NC} ${tag} ${desc}  (expected \"${expected}\", rc=${rc}, got \"${out}\")"
        FAIL=$((FAIL + 1)); return 1
    fi
}

k8s_warn() {
    local desc="$1" cmd="$2" expected="$3" tag="${4:-k8s}"
    local out
    out=$(eval "$cmd" 2>&1) && true
    local rc=$?
    if [ "$rc" -eq 0 ] && echo "$out" | grep -qF "$expected"; then
        echo -e "  ${GREEN}[PASS]${NC} ${tag} ${desc}"
        PASS=$((PASS + 1)); return 0
    else
        echo -e "  ${YELLOW}[WARN]${NC} ${tag} ${desc}  (expected \"${expected}\", rc=${rc}, got \"${out}\")"
        WARN=$((WARN + 1)); return 1
    fi
}

run_topic_script() {
    local topic="$1" script="$2"
    local script_path="${MODULE_DIR}/guided-learning/${topic}/assets/${script}"
    if [ ! -f "$script_path" ]; then
        echo -e "  ${RED}[FAIL]${NC} script ${script} not found in ${topic}/assets"
        FAIL=$((FAIL + 1))
        return 1
    fi

    local out rc
    out=$(cd "$(dirname "$script_path")" && timeout 180 bash "$(basename "$script_path")" 2>&1) && true
    rc=$?
    if [ "$rc" -eq 0 ]; then
        echo -e "  ${GREEN}[PASS]${NC} script ${topic}/${script} completed"
        PASS=$((PASS + 1)); return 0
    else
        echo -e "  ${YELLOW}[WARN]${NC} script ${topic}/${script} exited rc=${rc}"
        echo "           (this may be expected if the script needs a TTY or cluster add-on)"
        echo "$out" | sed 's/^/             /' | tail -n 8
        WARN=$((WARN + 1)); return 1
    fi
}

wait_for_pod() {
    local name="$1" ns="${2:-$NAMESPACE}" timeout_sec="${3:-60}"
    local i status
    for i in $(seq 1 "$timeout_sec"); do
        status=$(kubectl get pod "$name" -n "$ns" -o jsonpath='{.status.phase}' 2>/dev/null || echo '')
        if [ "$status" = "Running" ] || [ "$status" = "Succeeded" ]; then
            return 0
        fi
        sleep 1
    done
    return 1
}

wait_for_deployment() {
    local name="$1" ns="${2:-$NAMESPACE}" timeout_sec="${3:-60}"
    kubectl wait --for=condition=available --timeout="${timeout_sec}s" "deployment/${name}" -n "$ns" 2>/dev/null
}

wait_for_pvc() {
    local name="$1" ns="${2:-$NAMESPACE}" timeout_sec="${3:-60}"
    local i status
    for i in $(seq 1 "$timeout_sec"); do
        status=$(kubectl get pvc "$name" -n "$ns" -o jsonpath='{.status.phase}' 2>/dev/null || echo '')
        if [ "$status" = "Bound" ]; then
            return 0
        fi
        sleep 1
    done
    return 1
}

# ── Local cluster detection ───────────────────────────────────────────

echo -e "${CYAN}[pre] Local Kubernetes Cluster Detection${NC}"

LOCAL_CLUSTER_FOUND=false

if command -v minikube &>/dev/null; then
    if minikube status 2>/dev/null | grep -q "host: Running"; then
        echo -e "  ${GREEN}[PASS]${NC} cluster minikube is running"
        PASS=$((PASS + 1))
        LOCAL_CLUSTER_FOUND=true
    else
        echo -e "  ${YELLOW}[WARN]${NC} cluster minikube installed but not running (run: minikube start)"
        WARN=$((WARN + 1))
    fi
elif command -v kind &>/dev/null; then
    CLUSTERS=$(kind get clusters 2>/dev/null | grep -v 'No kind clusters found' || true)
    if [ -n "$CLUSTERS" ]; then
        echo -e "  ${GREEN}[PASS]${NC} cluster kind cluster(s) found: $(echo "$CLUSTERS" | tr '\n' ' ')"
        PASS=$((PASS + 1))
        LOCAL_CLUSTER_FOUND=true
    else
        echo -e "  ${YELLOW}[WARN]${NC} cluster kind installed but no clusters (run: kind create cluster)"
        WARN=$((WARN + 1))
    fi
elif command -v k3d &>/dev/null; then
    CLUSTERS=$(k3d cluster list 2>/dev/null | tail -n +2 | awk '{print $1}' || true)
    if [ -n "$CLUSTERS" ]; then
        echo -e "  ${GREEN}[PASS]${NC} cluster k3d cluster(s) found: $(echo "$CLUSTERS" | tr '\n' ' ')"
        PASS=$((PASS + 1))
        LOCAL_CLUSTER_FOUND=true
    else
        echo -e "  ${YELLOW}[WARN]${NC} cluster k3d installed but no clusters (run: k3d cluster create)"
        WARN=$((WARN + 1))
    fi
else
    echo -e "  ${CYAN}[info]${NC} cluster no local cluster tooling detected (minikube/kind/k3d)"
fi

if [ "$LOCAL_CLUSTER_FOUND" = false ]; then
    echo -e "  ${CYAN}[info]${NC} cluster assuming an external cluster is configured in kubeconfig"
fi
echo ""

# ── 1. kubectl and cluster reachability ───────────────────────────────

echo -e "${CYAN}[ 1] kubectl & Cluster Reachability (Topic 01-02)${NC}"

check_cmd "kubectl" "tool"

KUBECTL_VER=$(kubectl version --client 2>/dev/null || echo 'unknown')
echo "  kubectl   : ${KUBECTL_VER}"

k8s_ok "kubectl version works" \
    "kubectl version --client >/dev/null 2>&1 && echo ok" "tool"

if kubectl cluster-info >/dev/null 2>&1; then
    echo -e "  ${GREEN}[PASS]${NC} cluster kubectl cluster-info reachable"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} cluster kubectl cluster-info unreachable"
    echo "            No reachable Kubernetes cluster. Start one of: minikube, kind, k3d, Docker Desktop"
    FAIL=$((FAIL + 1))
    echo ""
    echo -e "${RED}  Validation aborted — no Kubernetes cluster available.${NC}"
    exit 1
fi

if kubectl get nodes --no-headers >/dev/null 2>&1; then
    echo -e "  ${GREEN}[PASS]${NC} cluster kubectl get nodes succeeds"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} cluster kubectl get nodes failed"
    FAIL=$((FAIL + 1))
    echo ""
    echo -e "${RED}  Validation aborted — cluster API not responding.${NC}"
    exit 1
fi

TOTAL_NODES=$(kubectl get nodes --no-headers 2>/dev/null | wc -l | tr -d ' ')
READY_NODES=$(kubectl get nodes --no-headers 2>/dev/null | awk '$2 == "Ready" {count++} END {print count+0}')
if [ "$READY_NODES" -eq "$TOTAL_NODES" ] && [ "$TOTAL_NODES" -gt 0 ]; then
    echo -e "  ${GREEN}[PASS]${NC} cluster all ${TOTAL_NODES} node(s) Ready"
    PASS=$((PASS + 1))
else
    echo -e "  ${YELLOW}[WARN]${NC} cluster ${READY_NODES}/${TOTAL_NODES} nodes Ready"
    WARN=$((WARN + 1))
fi
echo ""

# ── 2. Cluster verification and permissions ───────────────────────────

echo -e "${CYAN}[ 2] Cluster Verification & Permissions (Topic 02)${NC}"

k8s_ok "kubectl config current-context set" \
    "kubectl config current-context 2>&1 | grep -q .  && echo ok" "config"

k8s_ok "kubectl auth can-i create deployments" \
    "kubectl auth can-i create deployments 2>&1 | grep -q 'yes' && echo ok" "auth"

k8s_ok "kubectl auth can-i create pods" \
    "kubectl auth can-i create pods 2>&1 | grep -q 'yes' && echo ok" "auth"

k8s_ok "kubectl auth can-i create services" \
    "kubectl auth can-i create services 2>&1 | grep -q 'yes' && echo ok" "auth"

run_topic_script "topic-02" "verify-cluster.sh"

echo ""

# ── 3. Resource discovery ─────────────────────────────────────────────

echo -e "${CYAN}[ 3] kubectl Resource Discovery (Topic 03)${NC}"

k8s_ok "kubectl get all" \
    "kubectl get all 2>&1 | head -1 | grep -qE 'NAME|No resources' && echo ok" "discovery"

k8s_ok "kubectl get pods -A" \
    "kubectl get pods -A --no-headers 2>&1 | wc -l | grep -q '[0-9]' && echo ok" "discovery"

k8s_ok "kubectl get services -A" \
    "kubectl get services -A --no-headers 2>&1 | wc -l | grep -q '[0-9]' && echo ok" "discovery"

k8s_expect "kubectl describe node works" \
    "kubectl describe node \"$(kubectl get nodes -o name 2>/dev/null | head -n1)\" 2>&1 | head -1" \
    "Name:" "discovery"

k8s_ok "kubectl explain pod returns schema" \
    "kubectl explain pod 2>&1 | head -1 | grep -qE 'KIND|Pod' && echo ok" "discovery"

k8s_ok "kubectl explain deployment.spec returns schema" \
    "kubectl explain deployment.spec 2>&1 | head -1 | grep -qE 'KIND|Deployment' && echo ok" "discovery"
echo ""

# Create main validation namespace
kubectl create namespace "$NAMESPACE" 2>/dev/null || true
kubectl label namespace "$NAMESPACE" "$LABEL" --overwrite &>/dev/null || true

# ── 4. Namespaces and context management ──────────────────────────────

echo -e "${CYAN}[ 4] Namespaces & Context Management (Topic 04)${NC}"

k8s_ok "kubectl get ns" \
    "kubectl get ns 2>&1 | head -1 | grep -q NAME && echo ok" "ns"

k8s_ok "kubectl create namespace dev" \
    "kubectl create namespace dev 2>&1 | grep -qE 'created|AlreadyExists' && echo ok" "ns"

k8s_ok "kubectl apply -f namespace-demo.yaml" \
    "kubectl apply -f ${MODULE_DIR}/guided-learning/topic-04/assets/namespace-demo.yaml 2>&1 | grep -qE 'created|configured|unchanged' && echo ok" "ns"

k8s_ok "kubectl config set-context --current --namespace=dev" \
    "kubectl config set-context --current --namespace=dev 2>&1 | grep -q 'Context' && echo ok" "ns"

k8s_ok "kubectl get pods in dev namespace" \
    "kubectl get pods 2>&1 | head -1 | grep -qE 'NAME|No resources' && echo ok" "ns"

k8s_ok "kubectl config set-context --current --namespace=default" \
    "kubectl config set-context --current --namespace=default 2>&1 | grep -q 'Context' && echo ok" "ns"

kubectl delete namespace dev staging production testing --ignore-not-found=true --wait=false &>/dev/null || true
echo ""

# ── 5. Pod lifecycle and troubleshooting states ───────────────────────

echo -e "${CYAN}[ 5] Pod Lifecycle & Troubleshooting (Topic 05)${NC}"

k8s_ok "kubectl run nginx" \
    "kubectl run nginx --image=nginx:1.21 -n ${NAMESPACE} 2>&1 | grep -qE 'created|AlreadyExists' && echo ok" "pod"

wait_for_pod "nginx" "$NAMESPACE" 60
k8s_expect "nginx pod is Running" \
    "kubectl get pod nginx -n ${NAMESPACE} -o jsonpath='{.status.phase}' 2>&1" \
    "Running" "pod"

k8s_expect "kubectl describe pod nginx shows name" \
    "kubectl describe pod nginx -n ${NAMESPACE} 2>&1 | head -1" \
    "Name:" "pod"

k8s_ok "kubectl logs nginx" \
    "kubectl logs nginx -n ${NAMESPACE} 2>&1 | grep -q .  && echo ok" "pod"

k8s_ok "kubectl delete pod nginx" \
    "kubectl delete pod nginx -n ${NAMESPACE} 2>&1 | grep -q 'deleted' && echo ok" "pod"

k8s_ok "kubectl apply -f simple-pod.yaml" \
    "kubectl apply -n ${NAMESPACE} -f ${MODULE_DIR}/guided-learning/topic-05/assets/simple-pod.yaml 2>&1 | grep -qE 'created|configured|unchanged' && echo ok" "pod"

wait_for_pod "nginx-pod" "$NAMESPACE" 60
k8s_expect "nginx-pod is Running" \
    "kubectl get pod nginx-pod -n ${NAMESPACE} -o jsonpath='{.status.phase}' 2>&1" \
    "Running" "pod"

kubectl delete pod nginx-pod -n "$NAMESPACE" --ignore-not-found=true --wait=false &>/dev/null || true
echo ""

# ── 6. Declarative YAML fundamentals ──────────────────────────────────

echo -e "${CYAN}[ 6] Declarative YAML Fundamentals (Topic 06)${NC}"

k8s_ok "kubectl apply -f simple-pod.yaml" \
    "kubectl apply -n ${NAMESPACE} -f ${MODULE_DIR}/guided-learning/topic-06/assets/simple-pod.yaml 2>&1 | grep -qE 'created|configured|unchanged' && echo ok" "yaml"

wait_for_pod "nginx-pod" "$NAMESPACE" 60
k8s_expect "nginx-pod is Running" \
    "kubectl get pod nginx-pod -n ${NAMESPACE} -o jsonpath='{.status.phase}' 2>&1" \
    "Running" "yaml"

k8s_expect "kubectl get pod nginx-pod -o yaml contains apiVersion" \
    "kubectl get pod nginx-pod -n ${NAMESPACE} -o yaml 2>&1 | head -5 | grep -q 'apiVersion' && echo ok" \
    "ok" "yaml"

kubectl delete pod nginx-pod -n "$NAMESPACE" --ignore-not-found=true --wait=false &>/dev/null || true
echo ""

# ── 7. Multi-container pods and logs/exec ─────────────────────────────

echo -e "${CYAN}[ 7] Multi-Container Pods & Logs/Exec (Topic 07)${NC}"

k8s_ok "kubectl apply -f multi-container-pod.yaml" \
    "kubectl apply -n ${NAMESPACE} -f ${MODULE_DIR}/guided-learning/topic-07/assets/multi-container-pod.yaml 2>&1 | grep -qE 'created|configured|unchanged' && echo ok" "multi"

wait_for_pod "multi-container-pod" "$NAMESPACE" 60
k8s_expect "multi-container-pod is Running" \
    "kubectl get pod multi-container-pod -n ${NAMESPACE} -o jsonpath='{.status.phase}' 2>&1" \
    "Running" "multi"

k8s_ok "kubectl logs multi-container-pod -c nginx" \
    "kubectl logs multi-container-pod -c nginx -n ${NAMESPACE} 2>&1 | grep -q .  && echo ok" "multi"

k8s_ok "kubectl logs multi-container-pod -c sidecar" \
    "kubectl logs multi-container-pod -c sidecar -n ${NAMESPACE} 2>&1 | grep -q .  && echo ok" "multi"

k8s_ok "kubectl exec -it multi-container-pod -c nginx -- hostname" \
    "kubectl exec multi-container-pod -c nginx -n ${NAMESPACE} -- hostname 2>&1 | grep -q .  && echo ok" "multi"

kubectl delete pod multi-container-pod -n "$NAMESPACE" --ignore-not-found=true --wait=false &>/dev/null || true
echo ""

# ── 8. Deployment fundamentals and ReplicaSets ────────────────────────

echo -e "${CYAN}[ 8] Deployment Fundamentals & ReplicaSets (Topic 08)${NC}"

k8s_ok "kubectl apply -f nginx-deployment.yaml" \
    "kubectl apply -n ${NAMESPACE} -f ${MODULE_DIR}/guided-learning/topic-08/assets/nginx-deployment.yaml 2>&1 | grep -qE 'created|configured|unchanged' && echo ok" "deploy"

wait_for_deployment "nginx-deployment" "$NAMESPACE" 90
k8s_expect "deployment nginx-deployment available" \
    "kubectl get deployment nginx-deployment -n ${NAMESPACE} -o jsonpath='{.status.availableReplicas}' 2>&1" \
    "3" "deploy"

k8s_expect "replicaset exists for nginx-deployment" \
    "kubectl get replicaset -n ${NAMESPACE} -l app=nginx --no-headers 2>&1 | wc -l | grep -q '[1-9]' && echo ok" \
    "ok" "deploy"

k8s_expect "3 pods running for nginx-deployment" \
    "kubectl get pods -n ${NAMESPACE} -l app=nginx --no-headers 2>&1 | wc -l | grep -q '3' && echo ok" \
    "ok" "deploy"

k8s_ok "kubectl describe deployment nginx-deployment" \
    "kubectl describe deployment nginx-deployment -n ${NAMESPACE} 2>&1 | head -1 | grep -q 'Name:' && echo ok" "deploy"

kubectl delete deployment nginx-deployment -n "$NAMESPACE" --ignore-not-found=true --wait=false &>/dev/null || true
echo ""

# ── 9. Deployment scaling and replica management ──────────────────────

echo -e "${CYAN}[ 9] Deployment Scaling & Replica Management (Topic 09)${NC}"

k8s_ok "kubectl apply -f nginx-deployment.yaml" \
    "kubectl apply -n ${NAMESPACE} -f ${MODULE_DIR}/guided-learning/topic-09/assets/nginx-deployment.yaml 2>&1 | grep -qE 'created|configured|unchanged' && echo ok" "scale"

wait_for_deployment "nginx-deployment" "$NAMESPACE" 90
k8s_ok "kubectl scale deployment nginx-deployment --replicas=5" \
    "kubectl scale deployment nginx-deployment --replicas=5 -n ${NAMESPACE} 2>&1 | grep -q 'scaled' && echo ok" "scale"

sleep 5
k8s_expect "5 pods running after scale up" \
    "kubectl get pods -n ${NAMESPACE} -l app=nginx --no-headers 2>&1 | wc -l | grep -q '5' && echo ok" \
    "ok" "scale"

run_topic_script "topic-09" "scaling-demo.sh"

k8s_ok "kubectl scale deployment nginx-deployment --replicas=2" \
    "kubectl scale deployment nginx-deployment --replicas=2 -n ${NAMESPACE} 2>&1 | grep -q 'scaled' && echo ok" "scale"

kubectl delete deployment nginx-deployment -n "$NAMESPACE" --ignore-not-found=true --wait=false &>/dev/null || true
echo ""

# ── 10. Rolling updates and rollback ──────────────────────────────────

echo -e "${CYAN}[10] Rolling Updates & Rollback (Topic 10)${NC}"

k8s_ok "kubectl apply -f nginx-deployment.yaml" \
    "kubectl apply -n ${NAMESPACE} -f ${MODULE_DIR}/guided-learning/topic-10/assets/nginx-deployment.yaml 2>&1 | grep -qE 'created|configured|unchanged' && echo ok" "rollout"

wait_for_deployment "nginx-deployment" "$NAMESPACE" 90
k8s_ok "kubectl set image deployment/nginx-deployment nginx=nginx:1.21" \
    "kubectl set image deployment/nginx-deployment nginx=nginx:1.21 -n ${NAMESPACE} 2>&1 | grep -qE 'image updated' && echo ok" "rollout"

k8s_ok "kubectl rollout status deployment/nginx-deployment" \
    "kubectl rollout status deployment/nginx-deployment -n ${NAMESPACE} --timeout=60s 2>&1 | grep -q 'successfully' && echo ok" "rollout"

k8s_ok "kubectl rollout history deployment/nginx-deployment" \
    "kubectl rollout history deployment/nginx-deployment -n ${NAMESPACE} 2>&1 | grep -qE 'REVISION|deployment' && echo ok" "rollout"

k8s_ok "kubectl rollout undo deployment/nginx-deployment" \
    "kubectl rollout undo deployment/nginx-deployment -n ${NAMESPACE} 2>&1 | grep -qE 'rolled back' && echo ok" "rollout"

run_topic_script "topic-10" "rollout-demo.sh"

kubectl delete deployment nginx-deployment -n "$NAMESPACE" --ignore-not-found=true --wait=false &>/dev/null || true
echo ""

# ── 11. Service fundamentals (ClusterIP) ──────────────────────────────

echo -e "${CYAN}[11] Service Fundamentals - ClusterIP (Topic 11)${NC}"

k8s_ok "kubectl apply -f nginx-deployment.yaml" \
    "kubectl apply -n ${NAMESPACE} -f ${MODULE_DIR}/guided-learning/topic-11/assets/nginx-deployment.yaml 2>&1 | grep -qE 'created|configured|unchanged' && echo ok" "svc"

wait_for_deployment "nginx-deployment" "$NAMESPACE" 90
k8s_ok "kubectl expose deployment nginx-deployment" \
    "kubectl expose deployment nginx-deployment --name=nginx-svc --port=80 --target-port=80 -n ${NAMESPACE} 2>&1 | grep -qE 'exposed|service' && echo ok" "svc"

k8s_ok "kubectl get svc nginx-svc" \
    "kubectl get svc nginx-svc -n ${NAMESPACE} 2>&1 | grep -q 'nginx-svc' && echo ok" "svc"

k8s_ok "kubectl describe svc nginx-svc" \
    "kubectl describe svc nginx-svc -n ${NAMESPACE} 2>&1 | head -1 | grep -q 'Name:' && echo ok" "svc"

k8s_expect "kubectl get endpoints nginx-svc shows endpoints" \
    "kubectl get endpoints nginx-svc -n ${NAMESPACE} --no-headers 2>&1 | grep -qE '[0-9]+\.[0-9]+' && echo ok" \
    "ok" "svc"

kubectl delete svc nginx-svc -n "$NAMESPACE" --ignore-not-found=true --wait=false &>/dev/null || true
kubectl delete deployment nginx-deployment -n "$NAMESPACE" --ignore-not-found=true --wait=false &>/dev/null || true
echo ""

# ── 12. NodePort and LoadBalancer exposure patterns ───────────────────

echo -e "${CYAN}[12] NodePort & LoadBalancer Exposure (Topic 12)${NC}"

kubectl create deployment web --image=nginx:1.21 --replicas=2 -n "$NAMESPACE" 2>/dev/null || true
wait_for_deployment "web" "$NAMESPACE" 90

k8s_ok "kubectl apply -f nodeport-service.yaml" \
    "kubectl apply -n ${NAMESPACE} -f ${MODULE_DIR}/guided-learning/topic-12/assets/nodeport-service.yaml 2>&1 | grep -qE 'created|configured|unchanged' && echo ok" "svc"

k8s_ok "kubectl apply -f loadbalancer-service.yaml" \
    "kubectl apply -n ${NAMESPACE} -f ${MODULE_DIR}/guided-learning/topic-12/assets/loadbalancer-service.yaml 2>&1 | grep -qE 'created|configured|unchanged' && echo ok" "svc"

k8s_ok "kubectl get svc -o wide" \
    "kubectl get svc -n ${NAMESPACE} -o wide 2>&1 | grep -qE 'my-nodeport-service|my-loadbalancer-service' && echo ok" "svc"

k8s_ok "kubectl describe svc my-nodeport-service" \
    "kubectl describe svc my-nodeport-service -n ${NAMESPACE} 2>&1 | head -1 | grep -q 'Name:' && echo ok" "svc"

k8s_warn "LoadBalancer service has an external IP (optional)" \
    "kubectl get svc my-loadbalancer-service -n ${NAMESPACE} -o jsonpath='{.status.loadBalancer.ingress[0].ip}{.status.loadBalancer.ingress[0].hostname}' 2>&1 | grep -q .  && echo ok" \
    "ok" "svc"

kubectl delete svc my-nodeport-service my-loadbalancer-service -n "$NAMESPACE" --ignore-not-found=true --wait=false &>/dev/null || true
kubectl delete deployment web -n "$NAMESPACE" --ignore-not-found=true --wait=false &>/dev/null || true
echo ""

# ── 13. DNS and service discovery ─────────────────────────────────────

echo -e "${CYAN}[13] DNS & Service Discovery (Topic 13)${NC}"

kubectl create deployment web --image=nginx:1.21 --replicas=2 -n "$NAMESPACE" 2>/dev/null || true
wait_for_deployment "web" "$NAMESPACE" 90

k8s_ok "kubectl apply -f clusterip-service.yaml" \
    "kubectl apply -n ${NAMESPACE} -f ${MODULE_DIR}/guided-learning/topic-13/assets/clusterip-service.yaml 2>&1 | grep -qE 'created|configured|unchanged' && echo ok" "dns"

k8s_ok "kubectl get svc" \
    "kubectl get svc -n ${NAMESPACE} 2>&1 | grep -q 'my-clusterip-service' && echo ok" "dns"

k8s_warn "DNS lookup for my-clusterip-service works (optional)" \
    "kubectl run dns-test --image=busybox:1.35 --restart=Never -n ${NAMESPACE} --rm -- nslookup my-clusterip-service 2>&1 | grep -qE 'my-clusterip-service|Address' && echo ok" \
    "ok" "dns"

run_topic_script "topic-13" "service-discovery-demo.sh"

kubectl delete svc my-clusterip-service -n "$NAMESPACE" --ignore-not-found=true --wait=false &>/dev/null || true
kubectl delete deployment web -n "$NAMESPACE" --ignore-not-found=true --wait=false &>/dev/null || true
echo ""

# ── 14. Ingress basics and traffic routing ────────────────────────────

echo -e "${CYAN}[14] Ingress Basics & Traffic Routing (Topic 14)${NC}"

k8s_ok "kubectl apply -f ingress-example.yaml" \
    "kubectl apply -n ${NAMESPACE} -f ${MODULE_DIR}/guided-learning/topic-14/assets/ingress-example.yaml 2>&1 | grep -qE 'created|configured|unchanged' && echo ok" "ingress"

k8s_ok "kubectl get ingress" \
    "kubectl get ingress -n ${NAMESPACE} 2>&1 | grep -q 'my-ingress' && echo ok" "ingress"

k8s_ok "kubectl describe ingress my-ingress" \
    "kubectl describe ingress my-ingress -n ${NAMESPACE} 2>&1 | head -1 | grep -q 'Name:' && echo ok" "ingress"

k8s_warn "Ingress controller pods exist (optional)" \
    "kubectl get pods -A --no-headers 2>&1 | grep -qi 'ingress' && echo ok" \
    "ok" "ingress"

kubectl delete ingress my-ingress -n "$NAMESPACE" --ignore-not-found=true --wait=false &>/dev/null || true
echo ""

# ── 15. Network policies and connectivity controls ────────────────────

echo -e "${CYAN}[15] Network Policies & Connectivity (Topic 15)${NC}"

kubectl create namespace backend --dry-run=client -o yaml 2>/dev/null | kubectl apply -f - &>/dev/null || true

k8s_ok "kubectl apply -f network-policy.yaml" \
    "kubectl apply -f ${MODULE_DIR}/guided-learning/topic-15/assets/network-policy.yaml 2>&1 | grep -qE 'created|configured|unchanged' && echo ok" "netpol"

k8s_ok "kubectl get networkpolicies" \
    "kubectl get networkpolicies -n backend 2>&1 | grep -q 'backend-policy' && echo ok" "netpol"

k8s_ok "kubectl describe networkpolicy backend-policy" \
    "kubectl describe networkpolicy backend-policy -n backend 2>&1 | head -1 | grep -q 'Name:' && echo ok" "netpol"

k8s_warn "NetworkPolicy enforcement likely available (optional)" \
    "kubectl get pods -n kube-system --no-headers 2>&1 | grep -qiE 'calico|cilium|flannel|weave|kube-router|cni' && echo ok" \
    "ok" "netpol"

kubectl delete networkpolicy backend-policy -n backend --ignore-not-found=true --wait=false &>/dev/null || true
kubectl delete namespace backend --ignore-not-found=true --wait=false &>/dev/null || true
echo ""

# ── 16. ConfigMaps (env and file based) ───────────────────────────────

echo -e "${CYAN}[16] ConfigMaps - Env & File Based (Topic 16)${NC}"

k8s_ok "kubectl apply -f configmap-demo.yaml" \
    "kubectl apply -n ${NAMESPACE} -f ${MODULE_DIR}/guided-learning/topic-16/assets/configmap-demo.yaml 2>&1 | grep -qE 'created|configured|unchanged' && echo ok" "cm"

k8s_ok "kubectl get configmaps" \
    "kubectl get configmap app-config -n ${NAMESPACE} 2>&1 | grep -q 'app-config' && echo ok" "cm"

k8s_ok "kubectl describe configmap app-config" \
    "kubectl describe configmap app-config -n ${NAMESPACE} 2>&1 | head -1 | grep -q 'Name:' && echo ok" "cm"

k8s_ok "kubectl apply -f pod-with-configmap-env.yaml" \
    "kubectl apply -n ${NAMESPACE} -f ${MODULE_DIR}/guided-learning/topic-16/assets/pod-with-configmap-env.yaml 2>&1 | grep -qE 'created|configured|unchanged' && echo ok" "cm"

wait_for_pod "configmap-env-pod" "$NAMESPACE" 60
k8s_expect "ConfigMap env values visible in pod" \
    "kubectl exec configmap-env-pod -n ${NAMESPACE} -- printenv 2>&1 | grep -q 'ENV=production' && echo ok" \
    "ok" "cm"

k8s_ok "kubectl apply -f pod-with-configmap-volume.yaml" \
    "kubectl apply -n ${NAMESPACE} -f ${MODULE_DIR}/guided-learning/topic-16/assets/pod-with-configmap-volume.yaml 2>&1 | grep -qE 'created|configured|unchanged' && echo ok" "cm"

kubectl delete pod configmap-env-pod configmap-volume-pod -n "$NAMESPACE" --ignore-not-found=true --wait=false &>/dev/null || true
kubectl delete configmap app-config -n "$NAMESPACE" --ignore-not-found=true --wait=false &>/dev/null || true
echo ""

# ── 17. Secrets and secure configuration patterns ─────────────────────

echo -e "${CYAN}[17] Secrets & Secure Configuration (Topic 17)${NC}"

k8s_ok "kubectl apply -f secret-demo.yaml" \
    "kubectl apply -n ${NAMESPACE} -f ${MODULE_DIR}/guided-learning/topic-17/assets/secret-demo.yaml 2>&1 | grep -qE 'created|configured|unchanged' && echo ok" "secret"

k8s_ok "kubectl get secrets" \
    "kubectl get secret db-secret -n ${NAMESPACE} 2>&1 | grep -q 'db-secret' && echo ok" "secret"

k8s_ok "kubectl describe secret db-secret" \
    "kubectl describe secret db-secret -n ${NAMESPACE} 2>&1 | head -1 | grep -q 'Name:' && echo ok" "secret"

k8s_expect "Secret password decodes correctly" \
    "kubectl get secret db-secret -n ${NAMESPACE} -o jsonpath='{.data.password}' 2>&1 | base64 --decode | grep -q 'mypassword123' && echo ok" \
    "ok" "secret"

k8s_ok "kubectl apply -f pod-with-secret-env.yaml" \
    "kubectl apply -n ${NAMESPACE} -f ${MODULE_DIR}/guided-learning/topic-17/assets/pod-with-secret-env.yaml 2>&1 | grep -qE 'created|configured|unchanged' && echo ok" "secret"

k8s_ok "kubectl apply -f pod-with-secret-volume.yaml" \
    "kubectl apply -n ${NAMESPACE} -f ${MODULE_DIR}/guided-learning/topic-17/assets/pod-with-secret-volume.yaml 2>&1 | grep -qE 'created|configured|unchanged' && echo ok" "secret"

kubectl delete pod secret-env-pod secret-volume-pod -n "$NAMESPACE" --ignore-not-found=true --wait=false &>/dev/null || true
kubectl delete secret db-secret -n "$NAMESPACE" --ignore-not-found=true --wait=false &>/dev/null || true
echo ""

# ── 18. Volumes, PV, and PVC workflows ────────────────────────────────

echo -e "${CYAN}[18] Volumes, PV & PVC Workflows (Topic 18)${NC}"

k8s_ok "kubectl apply -f pv-example.yaml" \
    "kubectl apply -f ${MODULE_DIR}/guided-learning/topic-18/assets/pv-example.yaml 2>&1 | grep -qE 'created|configured|unchanged' && echo ok" "storage"

k8s_ok "kubectl apply -f pvc-example.yaml" \
    "kubectl apply -n ${NAMESPACE} -f ${MODULE_DIR}/guided-learning/topic-18/assets/pvc-example.yaml 2>&1 | grep -qE 'created|configured|unchanged' && echo ok" "storage"

k8s_ok "kubectl get pv" \
    "kubectl get pv my-pv 2>&1 | grep -q 'my-pv' && echo ok" "storage"

k8s_ok "kubectl get pvc" \
    "kubectl get pvc my-pvc -n ${NAMESPACE} 2>&1 | grep -q 'my-pvc' && echo ok" "storage"

if wait_for_pvc "my-pvc" "$NAMESPACE" 60; then
    echo -e "  ${GREEN}[PASS]${NC} storage PVC my-pvc is Bound"
    PASS=$((PASS + 1))
else
    echo -e "  ${YELLOW}[WARN]${NC} storage PVC my-pvc did not bind (may need a default StorageClass or hostPath support)"
    WARN=$((WARN + 1))
fi

k8s_ok "kubectl apply -f pod-with-pvc.yaml" \
    "kubectl apply -n ${NAMESPACE} -f ${MODULE_DIR}/guided-learning/topic-18/assets/pod-with-pvc.yaml 2>&1 | grep -qE 'created|configured|unchanged' && echo ok" "storage"

wait_for_pod "pvc-pod" "$NAMESPACE" 60
k8s_expect "pvc-pod is Running" \
    "kubectl get pod pvc-pod -n ${NAMESPACE} -o jsonpath='{.status.phase}' 2>&1" \
    "Running" "storage"

run_topic_script "topic-18" "storage-demo.sh"

kubectl delete pod pvc-pod -n "$NAMESPACE" --ignore-not-found=true --wait=false &>/dev/null || true
kubectl delete pvc my-pvc -n "$NAMESPACE" --ignore-not-found=true --wait=false &>/dev/null || true
kubectl delete pv my-pv --ignore-not-found=true --wait=false &>/dev/null || true
echo ""

# ── 19. StatefulSets, Jobs, and CronJobs ──────────────────────────────

echo -e "${CYAN}[19] StatefulSets, Jobs & CronJobs (Topic 19)${NC}"

k8s_ok "kubectl apply -f statefulset-example.yaml" \
    "kubectl apply -n ${NAMESPACE} -f ${MODULE_DIR}/guided-learning/topic-19/assets/statefulset-example.yaml 2>&1 | grep -qE 'created|configured|unchanged' && echo ok" "controllers"

k8s_ok "kubectl get statefulsets" \
    "kubectl get statefulset web -n ${NAMESPACE} 2>&1 | grep -q 'web' && echo ok" "controllers"

k8s_expect "StatefulSet pods are running" \
    "kubectl get pods -n ${NAMESPACE} -l app=web --no-headers 2>&1 | wc -l | grep -q '[1-9]' && echo ok" \
    "ok" "controllers"

k8s_ok "kubectl apply -f job-example.yaml" \
    "kubectl apply -n ${NAMESPACE} -f ${MODULE_DIR}/guided-learning/topic-19/assets/job-example.yaml 2>&1 | grep -qE 'created|configured|unchanged' && echo ok" "controllers"

k8s_ok "kubectl get jobs" \
    "kubectl get job pi-calculation -n ${NAMESPACE} 2>&1 | grep -q 'pi-calculation' && echo ok" "controllers"

k8s_warn "Job pi-calculation completed (optional - may need time)" \
    "kubectl wait --for=condition=complete --timeout=60s job/pi-calculation -n ${NAMESPACE} 2>&1 | grep -q 'condition met' && echo ok" \
    "ok" "controllers"

k8s_ok "kubectl apply -f cronjob-example.yaml" \
    "kubectl apply -n ${NAMESPACE} -f ${MODULE_DIR}/guided-learning/topic-19/assets/cronjob-example.yaml 2>&1 | grep -qE 'created|configured|unchanged' && echo ok" "controllers"

k8s_ok "kubectl get cronjobs" \
    "kubectl get cronjob hello-cron -n ${NAMESPACE} 2>&1 | grep -q 'hello-cron' && echo ok" "controllers"

kubectl delete statefulset web -n "$NAMESPACE" --ignore-not-found=true --wait=false &>/dev/null || true
kubectl delete service nginx -n "$NAMESPACE" --ignore-not-found=true --wait=false &>/dev/null || true
kubectl delete job pi-calculation -n "$NAMESPACE" --ignore-not-found=true --wait=false &>/dev/null || true
kubectl delete cronjob hello-cron -n "$NAMESPACE" --ignore-not-found=true --wait=false &>/dev/null || true
echo ""

# ── 20. Health checks, resource limits, and metrics ───────────────────

echo -e "${CYAN}[20] Health Checks, Resource Limits & Metrics (Topic 20)${NC}"

k8s_ok "kubectl apply -f health-checks-pod.yaml" \
    "kubectl apply -n ${NAMESPACE} -f ${MODULE_DIR}/guided-learning/topic-20/assets/health-checks-pod.yaml 2>&1 | grep -qE 'created|configured|unchanged' && echo ok" "health"

k8s_ok "kubectl apply -f resource-limits-pod.yaml" \
    "kubectl apply -n ${NAMESPACE} -f ${MODULE_DIR}/guided-learning/topic-20/assets/resource-limits-pod.yaml 2>&1 | grep -qE 'created|configured|unchanged' && echo ok" "health"

wait_for_pod "health-check-pod" "$NAMESPACE" 60
k8s_expect "health-check-pod is Running" \
    "kubectl get pod health-check-pod -n ${NAMESPACE} -o jsonpath='{.status.phase}' 2>&1" \
    "Running" "health"

wait_for_pod "resource-demo" "$NAMESPACE" 60
k8s_expect "resource-demo is Running" \
    "kubectl get pod resource-demo -n ${NAMESPACE} -o jsonpath='{.status.phase}' 2>&1" \
    "Running" "health"

k8s_expect "health-check-pod has livenessProbe" \
    "kubectl describe pod health-check-pod -n ${NAMESPACE} 2>&1 | grep -q 'Liveness' && echo ok" \
    "ok" "health"

k8s_expect "resource-demo has Limits" \
    "kubectl describe pod resource-demo -n ${NAMESPACE} 2>&1 | grep -qE 'Limits|Memory|CPU' && echo ok" \
    "ok" "health"

run_topic_script "topic-20" "monitoring-setup.sh"

k8s_warn "kubectl top nodes works (optional)" \
    "kubectl top nodes 2>&1 | head -2 | grep -qE 'NAME|cpu|memory' && echo ok" \
    "ok" "health"

k8s_warn "kubectl top pods works (optional)" \
    "kubectl top pods -n ${NAMESPACE} 2>&1 | head -2 | grep -qE 'NAME|cpu|memory' && echo ok" \
    "ok" "health"

kubectl delete pod health-check-pod resource-demo -n "$NAMESPACE" --ignore-not-found=true --wait=false &>/dev/null || true
echo ""

# ── Final cleanup verification ────────────────────────────────────────

echo -e "${CYAN}[cleanup] Final Cleanup Verification${NC}"

cleanup

poll_for_namespace_removal() {
    local name="$1" timeout_sec="${2:-30}"
    local i
    for i in $(seq 1 "$timeout_sec"); do
        if ! kubectl get namespace "$name" &>/dev/null; then
            return 0
        fi
        sleep 1
    done
    return 1
}

if poll_for_namespace_removal "$NAMESPACE" 30; then
    echo -e "  ${GREEN}[PASS]${NC} cleanup validation namespace removed"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} cleanup namespace ${NAMESPACE} still exists"
    FAIL=$((FAIL + 1))
fi

for ns in dev staging production testing backend; do
    if poll_for_namespace_removal "$ns" 15; then
        echo -e "  ${GREEN}[PASS]${NC} cleanup namespace ${ns} removed"
        PASS=$((PASS + 1))
    else
        echo -e "  ${YELLOW}[WARN]${NC} cleanup namespace ${ns} still exists (may be Terminating)"
        WARN=$((WARN + 1))
    fi
done

echo ""

# ── Summary ───────────────────────────────────────────────────────────

echo -e "${CYAN}${SEP}${NC}"
echo ""
printf "  %-30s %s\n" "Checks passed:"    "${GREEN}${PASS}${NC}"
printf "  %-30s %s\n" "Optional missing:" "${YELLOW}${WARN}${NC}"
printf "  %-30s %s\n" "Required missing:" "${RED}${FAIL}${NC}"
echo ""

if [ "$FAIL" -eq 0 ]; then
    echo -e "${GREEN}  Kubernetes environment validated.${NC}"
    echo -e "${GREEN}  Ready for the NCC Kubernetes training module.${NC}"
    echo ""
    echo -e "${CYAN}${SEP}${NC}"
    exit 0
else
    echo -e "${RED}  Validation complete — ${FAIL} required item(s) missing.${NC}"
    echo -e "${RED}  Fix the failures above before using this environment.${NC}"
    echo ""
    echo -e "${CYAN}${SEP}${NC}"
    exit 1
fi
