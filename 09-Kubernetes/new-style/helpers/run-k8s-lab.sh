#!/usr/bin/env bash
# Instructor helper: install Docker / AWS CLI if missing, build and push
# Orbital Relay images to ECR, then apply every Kubernetes topic's
# manifests into a scratch namespace and exercise each core scenario.
set -uo pipefail

readonly SCRIPT_NAME="NCC Kubernetes Training - Orbital Relay Lab Runner"
readonly SEP="============================================================"
readonly SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
readonly NEW_STYLE_DIR=$(cd "${SCRIPT_DIR}/.." && pwd)
readonly NS="orbital-relay-lab"
readonly PAGE_MARK="Orbital Relay"
readonly REGION="us-east-1"
readonly LOCAL_TAG="orbital-relay:1.0"
readonly LOCAL_TAG_V2="orbital-relay:2.0"
readonly TOPIC03="${NEW_STYLE_DIR}/03-build-docker-image"
readonly TOPIC07="${NEW_STYLE_DIR}/07-rolling-update-and-rollback"

ECR_IMAGE_URI=""
ECR_REGISTRY=""
ECR_REPOSITORY_NAME="orbital-relay"
ECR_IMAGE_URI_V2=""

PASS=0
WARN=0
FAIL=0

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

usage() {
    cat <<EOF
Usage: $0
       $0 --ecr-image-uri <uri>

Validates the new-style Kubernetes lab on Amazon Linux 2023 EC2:
install Docker and AWS CLI v2 if missing, build/push orbital-relay
images to ECR, then apply topics 04-10 into a scratch namespace.

Region is us-east-1 (N. Virginia). Repository defaults to orbital-relay.
--ecr-image-uri is optional; if omitted, the script uses the account from
aws sts get-caller-identity:

  <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/orbital-relay:1.0
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --ecr-image-uri)
            ECR_IMAGE_URI="${2:-}"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown argument: $1" >&2
            echo "Only --ecr-image-uri is accepted. Region is us-east-1." >&2
            usage
            exit 2
            ;;
    esac
done

apply_ecr_uri() {
    local uri="$1"
    if [[ "$uri" != *:* ]]; then
        uri="${uri}:1.0"
    fi
    ECR_IMAGE_URI="$uri"
    ECR_REGISTRY=$(echo "$ECR_IMAGE_URI" | cut -d/ -f1)
    ECR_REPOSITORY_NAME=$(echo "$ECR_IMAGE_URI" | cut -d/ -f2- | cut -d: -f1)
    ECR_IMAGE_URI_V2="${ECR_REGISTRY}/${ECR_REPOSITORY_NAME}:2.0"
}

if [[ -n "$ECR_IMAGE_URI" ]]; then
    apply_ecr_uri "$ECR_IMAGE_URI"
fi

pass() { echo -e "  ${GREEN}[PASS]${NC} $1"; PASS=$((PASS + 1)); }
warn() { echo -e "  ${YELLOW}[WARN]${NC} $1"; WARN=$((WARN + 1)); }
fail() { echo -e "  ${RED}[FAIL]${NC} $1"; FAIL=$((FAIL + 1)); }

docker_bin() {
    if docker info &>/dev/null; then
        docker "$@"
    else
        sudo docker "$@"
    fi
}

kc() { kubectl -n "$NS" "$@"; }

# Write YAML with <ECR_REGISTRY> substituted into a temp file; prints path.
subst_yaml() {
    local src="$1"
    local dest
    dest=$(mktemp)
    sed "s|<ECR_REGISTRY>|${ECR_REGISTRY}|g" "$src" > "$dest"
    echo "$dest"
}

PF_PID=""
stop_portforward() {
    if [[ -n "$PF_PID" ]] && kill -0 "$PF_PID" &>/dev/null; then
        kill "$PF_PID" &>/dev/null || true
        wait "$PF_PID" 2>/dev/null || true
    fi
    PF_PID=""
}

# curl_via_portforward <target ref> <local-port>
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
echo "  Host      : $(hostname 2>/dev/null || echo unknown)"
echo "  User      : $(whoami 2>/dev/null || echo unknown)"
echo "  Region    : ${REGION}"
if [[ -n "$ECR_IMAGE_URI" ]]; then
    echo "  ECR URI   : ${ECR_IMAGE_URI}"
else
    echo "  ECR URI   : auto (ACCOUNT.dkr.ecr.${REGION}.amazonaws.com/${ECR_REPOSITORY_NAME}:1.0)"
fi
echo "  Namespace : ${NS}"
echo ""

# ── 1. Amazon Linux 2023 ──────────────────────────────────────────

echo -e "${CYAN}[ 1] Operating system${NC}"
if [[ "$(uname -s)" != "Linux" ]]; then
    fail "This lab runner is for Amazon Linux 2023 EC2 (found $(uname -s))"
    echo ""
    echo "Aborting: run this script on the Amazon Linux 2023 EC2 instance, not a laptop."
    exit 1
fi
pass "Linux host"

if [[ -f /etc/os-release ]]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    echo "  Distro    : ${PRETTY_NAME:-unknown}"
    if [[ "${ID:-}" == "amzn" && "${VERSION_ID:-}" == "2023" ]]; then
        pass "Amazon Linux 2023 detected"
    elif [[ "${ID:-}" == "amzn" ]]; then
        fail "Expected Amazon Linux 2023 (found ${PRETTY_NAME:-unknown}). This lab is Amazon Linux only."
        exit 1
    else
        fail "Expected Amazon Linux 2023 (found ${PRETTY_NAME:-unknown}). Do not run this on Ubuntu or other distros."
        exit 1
    fi
else
    fail "/etc/os-release not found"
    exit 1
fi
echo ""

# ── 2. Install Docker Engine ──────────────────────────────────────

echo -e "${CYAN}[ 2] Install Docker Engine${NC}"
if docker_bin info &>/dev/null; then
    pass "Docker daemon already running ($(docker_bin --version 2>/dev/null | head -n1))"
else
    echo "  Installing Docker with dnf from Amazon Linux repos..."
    if sudo dnf update -y && sudo dnf install -y docker; then
        sudo systemctl start docker
        sudo systemctl enable docker || true
        sudo usermod -aG docker "$USER" || true
        pass "Docker installed via dnf"
    else
        fail "Docker install failed"
        exit 1
    fi
fi

if docker_bin info &>/dev/null; then
    pass "docker info succeeds"
else
    fail "docker info failed after install (log out/in if you just joined the docker group)"
    exit 1
fi
echo ""

# ── 3. AWS CLI v2 ─────────────────────────────────────────────────

echo -e "${CYAN}[ 3] AWS CLI${NC}"
if command -v aws &>/dev/null; then
    pass "aws CLI present ($(aws --version 2>&1 | head -n1))"
else
    echo "  Installing AWS CLI v2 with the official installer..."
    if sudo dnf install -y unzip && \
        cd /tmp && \
        curl -fsS "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
        unzip -qo awscliv2.zip && \
        sudo ./aws/install; then
        pass "AWS CLI v2 installed"
        rm -rf /tmp/aws /tmp/awscliv2.zip
    else
        fail "AWS CLI v2 install failed"
        exit 1
    fi
fi

if ! command -v aws &>/dev/null; then
    fail "aws not on PATH after install"
    exit 1
fi
echo ""

# ── 4. AWS credentials ────────────────────────────────────────────

echo -e "${CYAN}[ 4] AWS credentials${NC}"
echo "  This lab uses ~/.aws/credentials from topic 02 (aws configure)."

IDENTITY_JSON=$(aws sts get-caller-identity --region "$REGION" 2>&1) || IDENTITY_JSON=""
if echo "$IDENTITY_JSON" | grep -q '"Account"'; then
    ARN=$(echo "$IDENTITY_JSON" | grep -o '"Arn": "[^"]*"' | cut -d'"' -f4)
    ACCOUNT=$(echo "$IDENTITY_JSON" | grep -o '"Account": "[^"]*"' | cut -d'"' -f4)
    echo "  Arn       : ${ARN}"
    echo "  Account   : ${ACCOUNT}"
    pass "aws sts get-caller-identity succeeds"
else
    fail "aws sts get-caller-identity failed — run topic 02 aws configure first"
    echo "  Detail    : ${IDENTITY_JSON}"
    exit 1
fi

if [[ -z "$ECR_IMAGE_URI" ]]; then
    apply_ecr_uri "${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${ECR_REPOSITORY_NAME}:1.0"
    echo "  ECR URI   : ${ECR_IMAGE_URI}"
fi
echo ""

# ── 5. ECR repository ─────────────────────────────────────────────

echo -e "${CYAN}[ 5] ECR repository${NC}"
if aws ecr describe-repositories \
    --repository-names "$ECR_REPOSITORY_NAME" \
    --region "$REGION" &>/dev/null; then
    pass "ECR repository exists: ${ECR_REPOSITORY_NAME}"
else
    fail "ECR repository not found: ${ECR_REPOSITORY_NAME} in ${REGION}"
    exit 1
fi
echo ""

# ── 6. Build and push images ──────────────────────────────────────

echo -e "${CYAN}[ 6] Build and push Orbital Relay images${NC}"
if [[ ! -f "${TOPIC03}/Dockerfile" || ! -f "${TOPIC03}/index.html" ]]; then
    fail "topic 03 assets missing in ${TOPIC03}"
    exit 1
fi
if [[ ! -f "${TOPIC07}/Dockerfile.v2" || ! -f "${TOPIC07}/index-v2.html" ]]; then
    fail "topic 07 v2 assets missing in ${TOPIC07}"
    exit 1
fi

if (cd "$TOPIC03" && docker_bin build -t "$LOCAL_TAG" .); then
    pass "built ${LOCAL_TAG}"
else
    fail "docker build for :1.0 failed"
    exit 1
fi

if (cd "$TOPIC07" && docker_bin build -f Dockerfile.v2 -t "$LOCAL_TAG_V2" .); then
    pass "built ${LOCAL_TAG_V2}"
else
    fail "docker build for :2.0 failed"
    exit 1
fi

if aws ecr get-login-password --region "$REGION" | \
    docker_bin login --username AWS --password-stdin "$ECR_REGISTRY" &>/dev/null; then
    pass "docker login to ${ECR_REGISTRY}"
else
    fail "ECR docker login failed"
    exit 1
fi

docker_bin tag "$LOCAL_TAG" "$ECR_IMAGE_URI"
docker_bin tag "$LOCAL_TAG_V2" "$ECR_IMAGE_URI_V2"

if docker_bin push "$ECR_IMAGE_URI"; then
    pass "pushed ${ECR_IMAGE_URI}"
else
    fail "push failed for :1.0"
    exit 1
fi

if docker_bin push "$ECR_IMAGE_URI_V2"; then
    pass "pushed ${ECR_IMAGE_URI_V2}"
else
    fail "push failed for :2.0"
    exit 1
fi

if aws ecr describe-images \
    --repository-name "$ECR_REPOSITORY_NAME" \
    --region "$REGION" \
    --image-ids imageTag=1.0 &>/dev/null; then
    pass "ECR has orbital-relay:1.0"
else
    fail "ECR missing imageTag=1.0"
    exit 1
fi

if aws ecr describe-images \
    --repository-name "$ECR_REPOSITORY_NAME" \
    --region "$REGION" \
    --image-ids imageTag=2.0 &>/dev/null; then
    pass "ECR has orbital-relay:2.0"
else
    fail "ECR missing imageTag=2.0"
    exit 1
fi
echo ""

# ── 7. Cluster connectivity ───────────────────────────────────────

echo -e "${CYAN}[ 7] Cluster connectivity${NC}"
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
echo "  Context   : $(kubectl config current-context 2>/dev/null || echo unknown)"
echo ""

# ── 8. Scratch namespace ──────────────────────────────────────────

echo -e "${CYAN}[ 8] Scratch namespace${NC}"
kubectl delete namespace "$NS" --ignore-not-found --wait=true &>/dev/null || true
if kubectl create namespace "$NS" &>/dev/null; then
    pass "created namespace ${NS}"
else
    fail "could not create namespace ${NS}"
    exit 1
fi
echo ""

# ── 9. Topic 04: run a Pod ────────────────────────────────────────

echo -e "${CYAN}[ 9] Topic 04 - run a Pod${NC}"
TOPIC04="${NEW_STYLE_DIR}/04-run-a-pod"
POD_YAML=$(subst_yaml "${TOPIC04}/pod.yaml")
if kc apply -f "$POD_YAML" &>/dev/null; then
    pass "applied pod.yaml"
else
    fail "apply failed for topic 04"
    rm -f "$POD_YAML"
    exit 1
fi
rm -f "$POD_YAML"

if kc wait --for=condition=Ready pod/orbital-relay --timeout=120s &>/dev/null; then
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

kc delete pod orbital-relay --ignore-not-found &>/dev/null || true
echo ""

# ── 10. Topic 05: Deployment and scaling ──────────────────────────

echo -e "${CYAN}[10] Topic 05 - Deployment and scaling${NC}"
TOPIC05="${NEW_STYLE_DIR}/05-deployment-and-scaling"
DEP_YAML=$(subst_yaml "${TOPIC05}/deployment.yaml")
if kc apply -f "$DEP_YAML" &>/dev/null; then
    pass "applied deployment.yaml"
else
    fail "apply failed for topic 05"
    rm -f "$DEP_YAML"
    exit 1
fi
rm -f "$DEP_YAML"

if kc rollout status deployment/orbital-relay --timeout=120s &>/dev/null; then
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

# ── 11. Topic 06: expose with a Service ───────────────────────────

echo -e "${CYAN}[11] Topic 06 - expose with a Service${NC}"
TOPIC06="${NEW_STYLE_DIR}/06-expose-with-service"
DEP_YAML=$(subst_yaml "${TOPIC06}/deployment.yaml")
if kc apply -f "$DEP_YAML" -f "${TOPIC06}/service.yaml" &>/dev/null; then
    pass "applied deployment.yaml, service.yaml"
else
    fail "apply failed for topic 06"
    rm -f "$DEP_YAML"
    exit 1
fi
rm -f "$DEP_YAML"
kc rollout status deployment/orbital-relay --timeout=120s &>/dev/null || true

if curl_via_portforward svc/orbital-relay 18081 | grep -q "$PAGE_MARK"; then
    pass "curl through the Service returns ${PAGE_MARK}"
else
    fail "Service did not return ${PAGE_MARK}"
fi
echo ""

# ── 12. Topic 07: rolling update and rollback ─────────────────────

echo -e "${CYAN}[12] Topic 07 - rolling update and rollback${NC}"
DEP_YAML=$(subst_yaml "${TOPIC07}/deployment.yaml")
kc apply -f "$DEP_YAML" -f "${TOPIC07}/service.yaml" &>/dev/null
rm -f "$DEP_YAML"
kc rollout status deployment/orbital-relay --timeout=120s &>/dev/null || true

if curl_via_portforward svc/orbital-relay 18082 | grep -q "Ground link v1"; then
    pass "site is on v1 before update"
else
    warn "expected v1 marker before update, not found"
fi

kc set image deployment/orbital-relay "web=${ECR_IMAGE_URI_V2}" &>/dev/null
if kc rollout status deployment/orbital-relay --timeout=120s &>/dev/null; then
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
if kc rollout status deployment/orbital-relay --timeout=120s &>/dev/null; then
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

# ── 13. Topic 08: ConfigMap and Secret ────────────────────────────

echo -e "${CYAN}[13] Topic 08 - ConfigMap and Secret${NC}"
TOPIC08="${NEW_STYLE_DIR}/08-configmap-and-secret"
DEP_YAML=$(subst_yaml "${TOPIC08}/deployment.yaml")
if kc apply -f "${TOPIC08}/station-config.yaml" -f "${TOPIC08}/station-secret.yaml" \
    -f "$DEP_YAML" -f "${TOPIC08}/service.yaml" &>/dev/null; then
    pass "applied station config/secret, deployment, service"
else
    fail "apply failed for topic 08"
    rm -f "$DEP_YAML"
    exit 1
fi
rm -f "$DEP_YAML"
kc rollout status deployment/orbital-relay --timeout=120s &>/dev/null || true

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

# ── 14. Topic 09: logs and exec ───────────────────────────────────

echo -e "${CYAN}[14] Topic 09 - logs and exec${NC}"
TOPIC09="${NEW_STYLE_DIR}/09-logs-and-exec"
DEP_YAML=$(subst_yaml "${TOPIC09}/deployment.yaml")
kc apply -f "$DEP_YAML" -f "${TOPIC09}/service.yaml" &>/dev/null
rm -f "$DEP_YAML"
kc rollout status deployment/orbital-relay --timeout=120s &>/dev/null || true

if kc logs deploy/orbital-relay --tail=5 &>/dev/null; then
    pass "kubectl logs works against the Deployment"
else
    fail "kubectl logs failed"
fi

if kc exec deploy/orbital-relay -- ls /usr/share/nginx/html 2>/dev/null | grep -q index.html; then
    pass "kubectl exec confirms baked index.html is present"
else
    fail "index.html not found via kubectl exec"
fi
echo ""

# ── 15. Topic 10: health checks and limits ────────────────────────

echo -e "${CYAN}[15] Topic 10 - health checks and limits${NC}"
TOPIC10="${NEW_STYLE_DIR}/10-health-checks-and-limits"
DEP_YAML=$(subst_yaml "${TOPIC10}/deployment.yaml")
kc apply -f "$DEP_YAML" -f "${TOPIC10}/service.yaml" &>/dev/null
rm -f "$DEP_YAML"
kc rollout status deployment/orbital-relay --timeout=120s &>/dev/null || true

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
kc rollout status deployment/orbital-relay --timeout=120s &>/dev/null || true
sleep 5
EP_COUNT=$(kc get endpoints orbital-relay -o jsonpath='{.subsets[*].addresses}' 2>/dev/null | grep -o '"ip"' | wc -l | tr -d ' ')
if [[ "$EP_COUNT" -eq 0 ]]; then
    pass "broken readiness probe removed Pods from Service endpoints"
else
    warn "expected 0 endpoints with a broken readiness probe, saw ${EP_COUNT}"
fi

DEP_YAML=$(subst_yaml "${TOPIC10}/deployment.yaml")
kc apply -f "$DEP_YAML" &>/dev/null
rm -f "$DEP_YAML"
kc rollout status deployment/orbital-relay --timeout=120s &>/dev/null || true
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

echo "Lab validation passed. You can teach AWS CLI -> Docker/ECR -> Pod -> Deployment -> Service -> rollout -> config -> logs -> health checks."
exit 0
