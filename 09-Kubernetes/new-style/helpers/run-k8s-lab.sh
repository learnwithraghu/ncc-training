#!/usr/bin/env bash
# Instructor helper: apply every Orbital Relay topic's manifests into a
# scratch namespace, exercise each topic's core scenario end to end, then
# clean up. Requires kubectl already configured against the target cluster.
set -uo pipefail

readonly SCRIPT_NAME="NCC Kubernetes Training - Orbital Relay Lab Runner"
readonly SEP="============================================================"
readonly SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
readonly NEW_STYLE_DIR=$(cd "${SCRIPT_DIR}/.." && pwd)
readonly NS="orbital-relay-lab"
readonly PAGE_MARK="Orbital Relay"

PASS=0
WARN=0
FAIL=0

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

pass() { echo -e "  ${GREEN}[PASS]${NC} $1"; PASS=$((PASS + 1)); }
warn() { echo -e "  ${YELLOW}[WARN]${NC} $1"; WARN=$((WARN + 1)); }
fail() { echo -e "  ${RED}[FAIL]${NC} $1"; FAIL=$((FAIL + 1)); }

kc() { kubectl -n "$NS" "$@"; }

PF_PID=""
stop_portforward() {
    if [[ -n "$PF_PID" ]] && kill -0 "$PF_PID" &>/dev/null; then
        kill "$PF_PID" &>/dev/null || true
        wait "$PF_PID" 2>/dev/null || true
    fi
    PF_PID=""
}

# curl_via_portforward <target ref, e.g. svc/orbital-relay or pod/orbital-relay> <local-port>
# Prints the page body on stdout, returns curl's exit code.
curl_via_portforward() {
    local target="$1" local_port="$2"
    stop_portforward
    kubectl -n "$NS" port-forward "$target" "${local_port}:80" &>/dev/null &
    PF_PID=$!
    local ok=1 body=""
    for _ in $(seq 1 20); do
        if body=$(curl -fsS "http://127.0.0.1:${local_port}/" 2>/dev/null); then
            ok=0
            break
        fi
        sleep 1
    done
    stop_portforward
    echo "$body"
    return $ok
}

cleanup() {
    stop_portforward
    if [[ "${KEEP_NAMESPACE:-0}" != "1" ]]; then
        kubectl delete namespace "$NS" --ignore-not-found --wait=false &>/dev/null || true
    fi
}
trap cleanup EXIT

echo -e "${CYAN}${SEP}${NC}"
echo -e "${CYAN}  ${SCRIPT_NAME}${NC}"
echo -e "${CYAN}${SEP}${NC}"
echo "  Context   : $(kubectl config current-context 2>/dev/null || echo unknown)"
echo "  Namespace : ${NS}"
echo ""

# ── 1. Cluster connectivity ───────────────────────────────────────

echo -e "${CYAN}[ 1] Cluster connectivity${NC}"
if kubectl cluster-info &>/dev/null; then
    pass "kubectl cluster-info succeeds"
else
    fail "kubectl cannot reach the cluster - check your kubeconfig/context"
    exit 1
fi

NODE_COUNT=$(kubectl get nodes --no-headers 2>/dev/null | wc -l | tr -d ' ')
if [[ "$NODE_COUNT" -ge 1 ]]; then
    pass "${NODE_COUNT} node(s) visible"
else
    fail "no nodes found"
    exit 1
fi

if kubectl auth can-i create deployments &>/dev/null; then
    pass "can create deployments"
else
    fail "insufficient permissions to create deployments"
    exit 1
fi
echo ""

# ── 2. Scratch namespace ──────────────────────────────────────────

echo -e "${CYAN}[ 2] Scratch namespace${NC}"
kubectl delete namespace "$NS" --ignore-not-found --wait=true &>/dev/null || true
if kubectl create namespace "$NS" &>/dev/null; then
    pass "created namespace ${NS}"
else
    fail "could not create namespace ${NS}"
    exit 1
fi
echo ""

# ── 3. Topic 02: run a Pod ────────────────────────────────────────

echo -e "${CYAN}[ 3] Topic 02 - run a Pod${NC}"
TOPIC02="${NEW_STYLE_DIR}/02-run-a-pod"
if kc apply -f "${TOPIC02}/configmap.yaml" -f "${TOPIC02}/pod.yaml" &>/dev/null; then
    pass "applied configmap.yaml and pod.yaml"
else
    fail "apply failed for topic 02"
    exit 1
fi

if kc wait --for=condition=Ready pod/orbital-relay --timeout=90s &>/dev/null; then
    pass "pod/orbital-relay is Ready"
else
    fail "pod/orbital-relay never became Ready"
    kc describe pod orbital-relay | tail -n 20 | sed 's/^/         /'
    exit 1
fi

if curl_via_portforward pod/orbital-relay 18080 | grep -q "$PAGE_MARK"; then
    pass "curl through port-forward returns ${PAGE_MARK}"
else
    fail "page did not return ${PAGE_MARK}"
fi

kc delete -f "${TOPIC02}/pod.yaml" --ignore-not-found &>/dev/null || true
echo ""

# ── 4. Topic 03: Deployment and scaling ───────────────────────────

echo -e "${CYAN}[ 4] Topic 03 - Deployment and scaling${NC}"
TOPIC03="${NEW_STYLE_DIR}/03-deployment-and-scaling"
if kc apply -f "${TOPIC03}/configmap.yaml" -f "${TOPIC03}/deployment.yaml" &>/dev/null; then
    pass "applied configmap.yaml and deployment.yaml"
else
    fail "apply failed for topic 03"
    exit 1
fi

if kc rollout status deployment/orbital-relay --timeout=90s &>/dev/null; then
    pass "initial rollout completed (2 replicas)"
else
    fail "initial rollout did not complete"
    exit 1
fi

kc scale deployment/orbital-relay --replicas=4 &>/dev/null
sleep 3
READY_COUNT=$(kc get pods -l app=orbital-relay --field-selector=status.phase=Running --no-headers 2>/dev/null | wc -l | tr -d ' ')
if [[ "$READY_COUNT" -ge 3 ]]; then
    pass "scaled to 4 replicas (${READY_COUNT} Running so far)"
else
    warn "expected ~4 replicas Running, saw ${READY_COUNT} (cluster may be slow)"
fi
kc scale deployment/orbital-relay --replicas=2 &>/dev/null
echo ""

# ── 5. Topic 04: expose with a Service ────────────────────────────

echo -e "${CYAN}[ 5] Topic 04 - expose with a Service${NC}"
TOPIC04="${NEW_STYLE_DIR}/04-expose-with-service"
if kc apply -f "${TOPIC04}/configmap.yaml" -f "${TOPIC04}/deployment.yaml" -f "${TOPIC04}/service.yaml" &>/dev/null; then
    pass "applied configmap.yaml, deployment.yaml, service.yaml"
else
    fail "apply failed for topic 04"
    exit 1
fi
kc rollout status deployment/orbital-relay --timeout=90s &>/dev/null || true

if curl_via_portforward svc/orbital-relay 18081 | grep -q "$PAGE_MARK"; then
    pass "curl through the Service returns ${PAGE_MARK}"
else
    fail "Service did not return ${PAGE_MARK}"
fi
echo ""

# ── 6. Topic 05: rolling update and rollback ──────────────────────

echo -e "${CYAN}[ 6] Topic 05 - rolling update and rollback${NC}"
TOPIC05="${NEW_STYLE_DIR}/05-rolling-update-and-rollback"
kc apply -f "${TOPIC05}/configmap.yaml" -f "${TOPIC05}/deployment.yaml" -f "${TOPIC05}/service.yaml" &>/dev/null
kc rollout status deployment/orbital-relay --timeout=90s &>/dev/null || true

if curl_via_portforward svc/orbital-relay 18082 | grep -q "Ground link v1"; then
    pass "site is on v1 before update"
else
    warn "expected v1 marker before update, not found"
fi

kc apply -f "${TOPIC05}/configmap-v2.yaml" &>/dev/null
kc rollout restart deployment/orbital-relay &>/dev/null
if kc rollout status deployment/orbital-relay --timeout=90s &>/dev/null; then
    pass "rollout to v2 completed"
else
    fail "rollout to v2 did not complete"
fi

if curl_via_portforward svc/orbital-relay 18082 | grep -q "Ground link v2"; then
    pass "site is on v2 after rollout"
else
    fail "expected v2 marker after rollout, not found"
fi

kc rollout undo deployment/orbital-relay &>/dev/null
if kc rollout status deployment/orbital-relay --timeout=90s &>/dev/null; then
    pass "rollback completed"
else
    fail "rollback did not complete"
fi

if curl_via_portforward svc/orbital-relay 18082 | grep -q "Ground link v1"; then
    pass "site is back on v1 after rollback"
else
    fail "expected v1 marker after rollback, not found"
fi
echo ""

# ── 7. Topic 06: ConfigMap and Secret ─────────────────────────────

echo -e "${CYAN}[ 7] Topic 06 - ConfigMap and Secret${NC}"
TOPIC06="${NEW_STYLE_DIR}/06-configmap-and-secret"
if kc apply -f "${TOPIC06}/configmap.yaml" -f "${TOPIC06}/station-config.yaml" \
    -f "${TOPIC06}/station-secret.yaml" -f "${TOPIC06}/deployment.yaml" \
    -f "${TOPIC06}/service.yaml" &>/dev/null; then
    pass "applied site config, station config/secret, deployment, service"
else
    fail "apply failed for topic 06"
    exit 1
fi
kc rollout status deployment/orbital-relay --timeout=90s &>/dev/null || true

ENV_OUT=$(kc exec deploy/orbital-relay -- env 2>/dev/null || true)
if echo "$ENV_OUT" | grep -q "STATION_NAME=Svalbard-2"; then
    pass "STATION_NAME present in container env"
else
    fail "STATION_NAME missing from container env"
fi
if echo "$ENV_OUT" | grep -q "RELAY_API_TOKEN="; then
    pass "RELAY_API_TOKEN present in container env"
else
    fail "RELAY_API_TOKEN missing from container env"
fi
echo ""

# ── 8. Topic 07: logs and exec ────────────────────────────────────

echo -e "${CYAN}[ 8] Topic 07 - logs and exec${NC}"
TOPIC07="${NEW_STYLE_DIR}/07-logs-and-exec"
kc apply -f "${TOPIC07}/configmap.yaml" -f "${TOPIC07}/deployment.yaml" -f "${TOPIC07}/service.yaml" &>/dev/null
kc rollout status deployment/orbital-relay --timeout=90s &>/dev/null || true

if kc logs deploy/orbital-relay --tail=5 &>/dev/null; then
    pass "kubectl logs works against the Deployment"
else
    fail "kubectl logs failed"
fi

if kc exec deploy/orbital-relay -- ls /usr/share/nginx/html 2>/dev/null | grep -q index.html; then
    pass "kubectl exec confirms index.html is mounted"
else
    fail "index.html not found via kubectl exec"
fi
echo ""

# ── 9. Topic 08: health checks and limits ─────────────────────────

echo -e "${CYAN}[ 9] Topic 08 - health checks and limits${NC}"
TOPIC08="${NEW_STYLE_DIR}/08-health-checks-and-limits"
kc apply -f "${TOPIC08}/configmap.yaml" -f "${TOPIC08}/deployment.yaml" -f "${TOPIC08}/service.yaml" &>/dev/null
kc rollout status deployment/orbital-relay --timeout=90s &>/dev/null || true

if kc get deployment orbital-relay -o jsonpath='{.spec.template.spec.containers[0].readinessProbe}' 2>/dev/null | grep -q httpGet; then
    pass "readinessProbe is set"
else
    fail "readinessProbe missing"
fi
if kc get deployment orbital-relay -o jsonpath='{.spec.template.spec.containers[0].resources.limits}' 2>/dev/null | grep -q cpu; then
    pass "resource limits are set"
else
    fail "resource limits missing"
fi

# Break readiness on purpose, confirm endpoints drop, then restore.
kc patch deployment orbital-relay --type=json \
    -p='[{"op":"replace","path":"/spec/template/spec/containers/0/readinessProbe/httpGet/port","value":81}]' &>/dev/null
kc rollout status deployment/orbital-relay --timeout=90s &>/dev/null || true
sleep 5
EP_COUNT=$(kc get endpoints orbital-relay -o jsonpath='{.subsets[*].addresses}' 2>/dev/null | grep -o '"ip"' | wc -l | tr -d ' ')
if [[ "$EP_COUNT" -eq 0 ]]; then
    pass "broken readiness probe removed Pods from Service endpoints"
else
    warn "expected 0 endpoints with a broken readiness probe, saw ${EP_COUNT}"
fi

kc apply -f "${TOPIC08}/deployment.yaml" &>/dev/null
kc rollout status deployment/orbital-relay --timeout=90s &>/dev/null || true
sleep 5
EP_COUNT=$(kc get endpoints orbital-relay -o jsonpath='{.subsets[*].addresses}' 2>/dev/null | grep -o '"ip"' | wc -l | tr -d ' ')
if [[ "$EP_COUNT" -ge 1 ]]; then
    pass "restored readiness probe brings endpoints back (${EP_COUNT})"
else
    fail "endpoints did not recover after restoring the probe"
fi
echo ""

# ── Summary ───────────────────────────────────────────────────────

echo -e "${CYAN}${SEP}${NC}"
echo -e "${CYAN}  Summary${NC}"
echo -e "  ${GREEN}PASS${NC} ${PASS}   ${YELLOW}WARN${NC} ${WARN}   ${RED}FAIL${NC} ${FAIL}"
echo -e "${CYAN}${SEP}${NC}"

if [[ "$FAIL" -gt 0 ]]; then
    echo "Lab validation failed. Fix the failures before teaching."
    exit 1
fi

echo "Lab validation passed. You can teach Pod -> Deployment -> Service -> rollout -> config -> logs -> health checks."
exit 0
