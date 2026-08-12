#!/usr/bin/env bash
# Instructor helper: install Docker on Amazon Linux 2 EC2, build the sample app,
# smoke-test /health, and push the image to a supplied ECR URI.
set -uo pipefail

readonly SCRIPT_NAME="NCC Docker Training - ECR Lab Runner"
readonly SEP="============================================================"
readonly SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
readonly APP_DIR=$(cd "${SCRIPT_DIR}/../../application" && pwd)
readonly REGION="us-east-1"
readonly CONTAINER_NAME="ncc-ecr-lab-app"
readonly LOCAL_TAG="ncc-training-app:lab"

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
install Docker, build the sample app, curl /health, push to ECR.

Region is us-east-1 (N. Virginia). The app path is 05-Docker/application.

If you do not pass --ecr-image-uri, the script asks for it.

Example URI:
  123456789012.dkr.ecr.us-east-1.amazonaws.com/ncc-training-app:lab
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
    echo "  123456789012.dkr.ecr.us-east-1.amazonaws.com/ncc-training-app:lab"
    printf "ECR image URI: "
    read -r ECR_IMAGE_URI
fi

if [[ -z "$ECR_IMAGE_URI" ]]; then
    echo "ECR image URI is required." >&2
    exit 2
fi

if [[ "$ECR_IMAGE_URI" != *:* ]]; then
    ECR_IMAGE_URI="${ECR_IMAGE_URI}:lab"
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
        echo ""
        echo "Aborting: this lab installs Docker with amazon-linux-extras on Amazon Linux 2."
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
        echo ""
        echo "Aborting: could not install Docker on Amazon Linux 2."
        exit 1
    fi
fi

if docker_bin info &>/dev/null; then
    pass "docker info succeeds"
else
    fail "docker info failed after install"
    echo ""
    echo "Aborting: Docker daemon is not usable."
    exit 1
fi
echo ""

# ── 3. Install AWS CLI ────────────────────────────────────────────

echo -e "${CYAN}[ 3] Install AWS CLI${NC}"
if command -v aws &>/dev/null; then
    pass "aws CLI present ($(aws --version 2>&1 | head -n1))"
else
    echo "  Installing awscli..."
    if sudo yum install -y awscli; then
        pass "awscli installed"
    else
        fail "awscli install failed"
        echo ""
        echo "Aborting: AWS CLI is required to login and push to ECR."
        exit 1
    fi
fi
echo ""

# ── 4. AWS identity ───────────────────────────────────────────────

echo -e "${CYAN}[ 4] AWS identity${NC}"
IDENTITY_JSON=$(aws sts get-caller-identity --region "$REGION" 2>&1) || IDENTITY_JSON=""
if echo "$IDENTITY_JSON" | grep -q '"Account"'; then
    ACCOUNT=$(echo "$IDENTITY_JSON" | grep -o '"Account": "[^"]*"' | cut -d'"' -f4)
    ARN=$(echo "$IDENTITY_JSON" | grep -o '"Arn": "[^"]*"' | cut -d'"' -f4)
    pass "sts get-caller-identity (account ${ACCOUNT})"
    echo "  Arn       : ${ARN}"
else
    fail "aws sts get-caller-identity failed: ${IDENTITY_JSON}"
    echo ""
    echo "Aborting: attach an instance role or configure ~/.aws/credentials."
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
    echo ""
    echo "Aborting: create the repository in AWS Console, then rerun with the URI."
    exit 1
fi
echo ""

# ── 6. docker build ───────────────────────────────────────────────

echo -e "${CYAN}[ 6] docker build${NC}"
if [[ ! -f "${APP_DIR}/Dockerfile" ]]; then
    fail "Dockerfile not found in ${APP_DIR}"
    echo ""
    echo "Aborting: clone ncc-training on this EC2 instance first."
    exit 1
fi
pass "Dockerfile found"

if (cd "$APP_DIR" && docker_bin build -t "$LOCAL_TAG" .); then
    pass "docker build -t ${LOCAL_TAG} ."
else
    fail "docker build failed"
    echo ""
    echo "Aborting: fix the build before teaching."
    exit 1
fi
echo ""

# ── 7. Run and /health ────────────────────────────────────────────

echo -e "${CYAN}[ 7] Run container and curl /health${NC}"
docker_bin rm -f "$CONTAINER_NAME" &>/dev/null || true

HTTP_PORT=5000
for port in 5000 5001 5002 8080 8081; do
    if ! (echo >/dev/tcp/127.0.0.1/"$port") 2>/dev/null; then
        HTTP_PORT=$port
        break
    fi
done

if docker_bin run -d --name "$CONTAINER_NAME" -p "${HTTP_PORT}:5000" "$LOCAL_TAG" >/dev/null; then
    pass "docker run -d -p ${HTTP_PORT}:5000"
else
    fail "docker run failed"
    echo ""
    echo "Aborting: could not start the sample app container."
    exit 1
fi

HEALTH_OK=0
for _ in $(seq 1 20); do
    if curl -fsS "http://127.0.0.1:${HTTP_PORT}/health" >/dev/null 2>&1; then
        HEALTH_OK=1
        break
    fi
    sleep 1
done

if [[ "$HEALTH_OK" -eq 1 ]]; then
    pass "curl http://127.0.0.1:${HTTP_PORT}/health"
else
    fail "curl /health did not succeed within 20s"
    docker_bin logs --tail 20 "$CONTAINER_NAME" 2>&1 | sed 's/^/         /' || true
    echo ""
    echo "Aborting: the built image did not become healthy."
    exit 1
fi
echo ""

# ── 8. ECR login, tag, push ───────────────────────────────────────

echo -e "${CYAN}[ 8] ECR login, tag, and push${NC}"
if aws ecr get-login-password --region "$REGION" | docker_bin login --username AWS --password-stdin "$ECR_REGISTRY" >/dev/null; then
    pass "docker login to ${ECR_REGISTRY}"
else
    fail "ECR docker login failed"
    echo ""
    echo "Aborting: check ecr:GetAuthorizationToken on the instance role."
    exit 1
fi

if docker_bin tag "$LOCAL_TAG" "$ECR_IMAGE_URI"; then
    pass "docker tag ${LOCAL_TAG} ${ECR_IMAGE_URI}"
else
    fail "docker tag failed"
    exit 1
fi

if docker_bin push "$ECR_IMAGE_URI"; then
    pass "docker push ${ECR_IMAGE_URI}"
else
    fail "docker push failed"
    echo ""
    echo "Aborting: check ECR push permissions (PutImage, UploadLayerPart, CompleteLayerUpload)."
    exit 1
fi
echo ""

# ── 9. Verify in ECR ──────────────────────────────────────────────

echo -e "${CYAN}[ 9] Verify image in ECR${NC}"
IMAGE_TAG=$(echo "$ECR_IMAGE_URI" | awk -F: '{print $NF}')
if aws ecr describe-images \
    --repository-name "$ECR_REPOSITORY_NAME" \
    --image-ids "imageTag=${IMAGE_TAG}" \
    --region "$REGION" &>/dev/null; then
    pass "ECR contains tag ${IMAGE_TAG}"
else
    fail "describe-images did not find tag ${IMAGE_TAG}"
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

echo "Lab validation passed. You can teach the EC2 → docker build → ECR flow."
exit 0
