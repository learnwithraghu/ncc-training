#!/usr/bin/env bash
# Instructor helper: install Docker on Amazon Linux 2, serve the Aether Launch
# page, bake it into an image, push to ECR, pull, and run again.
set -uo pipefail

readonly SCRIPT_NAME="NCC Docker Training - Aether Launch Lab Runner"
readonly SEP="============================================================"
readonly SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
readonly APP_DIR="$SCRIPT_DIR"
readonly REGION="us-east-1"
readonly CONTAINER_NAME="aether-web"
readonly LOCAL_TAG="aether-launch:1.0"
readonly PAGE_MARK="Aether Launch"

ECR_IMAGE_URI=""

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

Validates the new-style Docker lab on Amazon Linux 2 EC2:
install Docker, serve the Aether Launch HTML from disk, bake it into
an image, curl the page, push to ECR, then pull and run it again.

Region is us-east-1 (N. Virginia). Site files live next to this script.

If you do not pass --ecr-image-uri, the script asks for it.

Example URI:
  123456789012.dkr.ecr.us-east-1.amazonaws.com/aether-launch:1.0
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

if [[ -z "$ECR_IMAGE_URI" ]]; then
    echo "ECR image URI (us-east-1), for example:"
    echo "  123456789012.dkr.ecr.us-east-1.amazonaws.com/aether-launch:1.0"
    printf "ECR image URI: "
    read -r ECR_IMAGE_URI
fi

if [[ -z "$ECR_IMAGE_URI" ]]; then
    echo "ECR image URI is required." >&2
    exit 2
fi

if [[ "$ECR_IMAGE_URI" != *:* ]]; then
    ECR_IMAGE_URI="${ECR_IMAGE_URI}:1.0"
fi

ECR_REGISTRY=$(echo "$ECR_IMAGE_URI" | cut -d/ -f1)
ECR_REPOSITORY_NAME=$(echo "$ECR_IMAGE_URI" | cut -d/ -f2- | cut -d: -f1)

pass() {
    echo -e "  ${GREEN}[PASS]${NC} $1"
    PASS=$((PASS + 1))
}

warn() {
    echo -e "  ${YELLOW}[WARN]${NC} $1"
    WARN=$((WARN + 1))
}

fail() {
    echo -e "  ${RED}[FAIL]${NC} $1"
    FAIL=$((FAIL + 1))
}

docker_bin() {
    if docker info &>/dev/null; then
        docker "$@"
    else
        sudo docker "$@"
    fi
}

page_ok() {
    local url="$1"
    curl -fsS "$url" 2>/dev/null | grep -q "$PAGE_MARK"
}

find_http_port() {
    local port
    for port in 8080 8081 8082 8090 80; do
        if ! (echo >/dev/tcp/127.0.0.1/"$port") 2>/dev/null; then
            echo "$port"
            return 0
        fi
    done
    echo "8080"
}

cleanup() {
    docker_bin rm -f "$CONTAINER_NAME" &>/dev/null || true
}
trap cleanup EXIT

echo -e "${CYAN}${SEP}${NC}"
echo -e "${CYAN}  ${SCRIPT_NAME}${NC}"
echo -e "${CYAN}${SEP}${NC}"
echo "  Host      : $(hostname 2>/dev/null || echo unknown)"
echo "  User      : $(whoami 2>/dev/null || echo unknown)"
echo "  App dir   : ${APP_DIR}"
echo "  Region    : ${REGION}"
echo "  ECR URI   : ${ECR_IMAGE_URI}"
echo ""

# ── 1. Amazon Linux 2 ─────────────────────────────────────────────

echo -e "${CYAN}[ 1] Operating system${NC}"
if [[ "$(uname -s)" != "Linux" ]]; then
    fail "This lab runner is for Amazon Linux 2 EC2 (found $(uname -s))"
    echo ""
    echo "Aborting: run this script on the Amazon Linux 2 EC2 instance, not a laptop."
    exit 1
fi
pass "Linux host"

if [[ -f /etc/os-release ]]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    echo "  Distro    : ${PRETTY_NAME:-unknown}"
    if [[ "${ID:-}" == "amzn" && "${VERSION_ID:-}" == "2" ]]; then
        pass "Amazon Linux 2 detected"
    elif [[ "${ID:-}" == "amzn" ]]; then
        warn "Amazon Linux detected (${PRETTY_NAME:-unknown}); expected Amazon Linux 2"
    else
        fail "Expected Amazon Linux 2 (found ${PRETTY_NAME:-unknown})"
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
    echo "  Installing Docker with amazon-linux-extras..."
    if sudo yum update -y && sudo amazon-linux-extras install docker -y; then
        sudo service docker start
        sudo systemctl enable docker || true
        sudo usermod -a -G docker "$USER" || true
        pass "Docker installed via amazon-linux-extras"
    elif sudo yum install -y docker; then
        sudo service docker start
        sudo systemctl enable docker || true
        sudo usermod -a -G docker "$USER" || true
        pass "Docker installed via yum"
    else
        fail "Docker install failed"
        exit 1
    fi
fi

if docker_bin info &>/dev/null; then
    pass "docker info succeeds"
else
    fail "docker info failed after install"
    exit 1
fi
echo ""

# ── 3. AWS CLI ────────────────────────────────────────────────────

echo -e "${CYAN}[ 3] AWS CLI${NC}"
if command -v aws &>/dev/null; then
    pass "aws CLI present ($(aws --version 2>&1 | head -n1))"
else
    if sudo yum install -y awscli; then
        pass "awscli installed"
    else
        fail "awscli install failed"
        exit 1
    fi
fi
echo ""

# ── 4. EC2 IAM role ───────────────────────────────────────────────

echo -e "${CYAN}[ 4] EC2 IAM role${NC}"
echo "  This lab uses the instance IAM role only. Do not use ~/.aws/credentials."

IMDS_TOKEN=$(curl -sS -X PUT "http://169.254.169.254/latest/api/token" \
    -H "X-aws-ec2-metadata-token-ttl-seconds: 60" \
    --connect-timeout 2 2>/dev/null || true)
if [[ -n "$IMDS_TOKEN" ]]; then
    INSTANCE_PROFILE=$(curl -sS -H "X-aws-ec2-metadata-token: ${IMDS_TOKEN}" \
        --connect-timeout 2 \
        "http://169.254.169.254/latest/meta-data/iam/security-credentials/" 2>/dev/null || true)
else
    INSTANCE_PROFILE=$(curl -sS --connect-timeout 2 \
        "http://169.254.169.254/latest/meta-data/iam/security-credentials/" 2>/dev/null || true)
fi

if [[ -n "$INSTANCE_PROFILE" ]]; then
    pass "Instance profile present: ${INSTANCE_PROFILE}"
else
    fail "No IAM instance profile on this EC2 instance"
    exit 1
fi

IDENTITY_JSON=$(aws sts get-caller-identity --region "$REGION" 2>&1) || IDENTITY_JSON=""
if echo "$IDENTITY_JSON" | grep -q '"Account"'; then
    ARN=$(echo "$IDENTITY_JSON" | grep -o '"Arn": "[^"]*"' | cut -d'"' -f4)
    echo "  Arn       : ${ARN}"
else
    fail "aws sts get-caller-identity failed: ${IDENTITY_JSON}"
    exit 1
fi

if echo "$ARN" | grep -q ':assumed-role/'; then
    pass "Credentials come from the EC2 instance role"
else
    fail "Credentials are not from an EC2 instance role (${ARN})"
    exit 1
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

# ── 6. Site files ─────────────────────────────────────────────────

echo -e "${CYAN}[ 6] Aether Launch site files${NC}"
if [[ -f "${APP_DIR}/index.html" && -f "${APP_DIR}/Dockerfile" ]]; then
    pass "index.html and Dockerfile found in helpers/"
else
    fail "index.html or Dockerfile missing in ${APP_DIR}"
    exit 1
fi
if grep -q "$PAGE_MARK" "${APP_DIR}/index.html"; then
    pass "index.html contains ${PAGE_MARK}"
else
    fail "index.html does not contain ${PAGE_MARK}"
    exit 1
fi
if grep -q "apk add" "${APP_DIR}/Dockerfile"; then
    pass "Dockerfile installs a package with apk add"
else
    fail "Dockerfile is missing package installation (apk add)"
    exit 1
fi
echo ""

HTTP_PORT=$(find_http_port)

# ── 7. Serve from EC2 disk (not baked yet) ────────────────────────

echo -e "${CYAN}[ 7] Serve HTML from EC2 with a bind mount${NC}"
docker_bin rm -f "$CONTAINER_NAME" &>/dev/null || true
if docker_bin run -d --name "$CONTAINER_NAME" -p "${HTTP_PORT}:80" \
    -v "${APP_DIR}:/usr/share/nginx/html:ro" \
    nginx:1.27-alpine >/dev/null; then
    pass "docker run nginx with bind mount on ${HTTP_PORT}:80"
else
    fail "bind-mount docker run failed"
    exit 1
fi

MOUNT_OK=0
for _ in $(seq 1 20); do
    if page_ok "http://127.0.0.1:${HTTP_PORT}/"; then
        MOUNT_OK=1
        break
    fi
    sleep 1
done
if [[ "$MOUNT_OK" -eq 1 ]]; then
    pass "curl company page from bind-mounted files"
else
    fail "bind-mounted page did not return ${PAGE_MARK}"
    docker_bin logs --tail 20 "$CONTAINER_NAME" 2>&1 | sed 's/^/         /' || true
    exit 1
fi
docker_bin rm -f "$CONTAINER_NAME" &>/dev/null || true
echo ""

# ── 8. Bake image, tag convention, run ────────────────────────────

echo -e "${CYAN}[ 8] Bake image, tag, and run${NC}"
if (cd "$APP_DIR" && docker_bin build -t "$LOCAL_TAG" .); then
    pass "docker build -t ${LOCAL_TAG} ."
else
    fail "docker build failed"
    exit 1
fi

if docker_bin tag "$LOCAL_TAG" "aether-launch:latest"; then
    pass "docker tag ${LOCAL_TAG} aether-launch:latest"
else
    fail "docker tag latest failed"
    exit 1
fi

if docker_bin run -d --name "$CONTAINER_NAME" -p "${HTTP_PORT}:80" "$LOCAL_TAG" >/dev/null; then
    pass "docker run baked image on ${HTTP_PORT}:80"
else
    fail "docker run of baked image failed"
    exit 1
fi

BAKE_OK=0
for _ in $(seq 1 20); do
    if page_ok "http://127.0.0.1:${HTTP_PORT}/"; then
        BAKE_OK=1
        break
    fi
    sleep 1
done
if [[ "$BAKE_OK" -eq 1 ]]; then
    pass "curl company page from baked image"
else
    fail "baked image did not return ${PAGE_MARK}"
    docker_bin logs --tail 20 "$CONTAINER_NAME" 2>&1 | sed 's/^/         /' || true
    exit 1
fi
echo ""

# ── 9. ECR login, tag, push ───────────────────────────────────────

echo -e "${CYAN}[ 9] ECR login, tag, and push${NC}"
if aws ecr get-login-password --region "$REGION" | docker_bin login --username AWS --password-stdin "$ECR_REGISTRY" >/dev/null; then
    pass "docker login to ${ECR_REGISTRY}"
else
    fail "ECR docker login failed"
    exit 1
fi

if docker_bin tag "$LOCAL_TAG" "$ECR_IMAGE_URI"; then
    pass "docker tag ${LOCAL_TAG} ${ECR_IMAGE_URI}"
else
    fail "docker tag for ECR failed"
    exit 1
fi

if docker_bin push "$ECR_IMAGE_URI"; then
    pass "docker push ${ECR_IMAGE_URI}"
else
    fail "docker push failed"
    exit 1
fi
echo ""

# ── 10. Verify in ECR ─────────────────────────────────────────────

echo -e "${CYAN}[10] Verify image in ECR${NC}"
IMAGE_TAG=$(echo "$ECR_IMAGE_URI" | awk -F: '{print $NF}')
if aws ecr describe-images \
    --repository-name "$ECR_REPOSITORY_NAME" \
    --image-ids "imageTag=${IMAGE_TAG}" \
    --region "$REGION" &>/dev/null; then
    pass "ECR contains tag ${IMAGE_TAG}"
else
    fail "describe-images did not find tag ${IMAGE_TAG}"
    exit 1
fi
echo ""

# ── 11. Pull from ECR and run ─────────────────────────────────────

echo -e "${CYAN}[11] Pull from ECR and run${NC}"
docker_bin rm -f "$CONTAINER_NAME" &>/dev/null || true
docker_bin rmi -f "$LOCAL_TAG" "aether-launch:latest" "$ECR_IMAGE_URI" &>/dev/null || true

if docker_bin pull "$ECR_IMAGE_URI"; then
    pass "docker pull ${ECR_IMAGE_URI}"
else
    fail "docker pull failed"
    exit 1
fi

if docker_bin run -d --name "$CONTAINER_NAME" -p "${HTTP_PORT}:80" "$ECR_IMAGE_URI" >/dev/null; then
    pass "docker run from pulled ECR image"
else
    fail "docker run of pulled image failed"
    exit 1
fi

PULL_OK=0
for _ in $(seq 1 20); do
    if page_ok "http://127.0.0.1:${HTTP_PORT}/"; then
        PULL_OK=1
        break
    fi
    sleep 1
done
if [[ "$PULL_OK" -eq 1 ]]; then
    pass "curl company page after pull from ECR"
else
    fail "pulled image did not return ${PAGE_MARK}"
    docker_bin logs --tail 20 "$CONTAINER_NAME" 2>&1 | sed 's/^/         /' || true
    exit 1
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

echo "Lab validation passed. You can teach EC2 serve → bake → tag → ECR push → pull."
exit 0
