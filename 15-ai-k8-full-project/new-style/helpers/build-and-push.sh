#!/usr/bin/env bash
# Instructor helper: build Daypack from topic 04, validate locally, push
# learnwithraghu/ai-k8-workshop:1.0 to Docker Hub.
# Run on a laptop with Docker. Students on the cluster only need kubectl.
set -euo pipefail

readonly IMAGE="learnwithraghu/ai-k8-workshop"
readonly TAG="1.0"
readonly FULL_IMAGE="${IMAGE}:${TAG}"
readonly BUILDER_NAME="daypack-builder"
readonly TEST_NAME="daypack-validate"
readonly TEST_PORT="18501"

readonly SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
readonly NEW_STYLE=$(cd "${SCRIPT_DIR}/.." && pwd)
readonly MODULE_ROOT=$(cd "${NEW_STYLE}/.." && pwd)
readonly BUILD_DIR="${NEW_STYLE}/04-tag-and-push"
readonly ENV_SRC="${MODULE_ROOT}/.env"

GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

pass() { echo -e "  ${GREEN}ok${NC}  $1"; }
fail() { echo -e "  ${RED}fail${NC} $1"; exit 1; }

usage() {
    cat <<EOF
Usage: bash build-and-push.sh

Builds from new-style/04-tag-and-push/, curls health + Streamlit HTML shell,
then pushes ${FULL_IMAGE} (linux/amd64 + linux/arm64 when buildx exists).
(Streamlit renders "Daypack" in the browser; curl only sees the shell.)

Requires:
  - Docker running
  - ${MODULE_ROOT}/.env with real ai-url, ai-key, model
  - docker login -u learnwithraghu (before push)

EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit 0
fi

cleanup_test() {
    docker rm -f "$TEST_NAME" >/dev/null 2>&1 || true
}
trap cleanup_test EXIT

wait_for_mark() {
    local url="$1"
    local mark="$2"
    local i
    for i in $(seq 1 45); do
        if curl -fsS "$url" 2>/dev/null | grep -q "$mark"; then
            return 0
        fi
        sleep 1
    done
    return 1
}

wait_for_health() {
    local url="$1"
    local i
    for i in $(seq 1 45); do
        if curl -fsS "$url" >/dev/null 2>&1; then
            return 0
        fi
        sleep 1
    done
    return 1
}

echo "Daypack — build and push ${FULL_IMAGE}"
echo

docker info >/dev/null 2>&1 || fail "Docker is not running"

[[ -f "$ENV_SRC" ]] || fail "Missing ${ENV_SRC} — copy .env_example to .env and fill ai-key"
grep -q 'ai-key=replace-me' "$ENV_SRC" 2>/dev/null && fail "${ENV_SRC} still has ai-key=replace-me"
grep -q '^ai-key=.\+' "$ENV_SRC" || fail "${ENV_SRC} has no ai-key"
grep -q '^ai-url=.\+' "$ENV_SRC" || fail "${ENV_SRC} has no ai-url"
grep -q '^model=.\+' "$ENV_SRC" || fail "${ENV_SRC} has no model"

[[ -f "${BUILD_DIR}/Dockerfile" ]] || fail "Missing ${BUILD_DIR}/Dockerfile"
[[ -f "${BUILD_DIR}/app.py" ]] || fail "Missing ${BUILD_DIR}/app.py"

cp "$ENV_SRC" "${BUILD_DIR}/.env"
pass "copied .env into 04-tag-and-push for bake"

echo -e "${CYAN}[build] ${FULL_IMAGE}${NC}"
docker build -t "$FULL_IMAGE" "$BUILD_DIR"
pass "local image ${FULL_IMAGE}"

cleanup_test
echo -e "${CYAN}[validate] http://127.0.0.1:${TEST_PORT}${NC}"
docker run -d --name "$TEST_NAME" -p "${TEST_PORT}:8501" "$FULL_IMAGE" >/dev/null

if wait_for_health "http://127.0.0.1:${TEST_PORT}/_stcore/health"; then
    pass "health check /_stcore/health"
else
    docker logs "$TEST_NAME" || true
    fail "health check did not pass on :${TEST_PORT}"
fi

# Streamlit serves a JS shell; "Daypack" is not in the initial HTML.
if wait_for_mark "http://127.0.0.1:${TEST_PORT}" "Streamlit"; then
    pass "homepage serves Streamlit shell"
else
    docker logs "$TEST_NAME" || true
    fail "did not see 'Streamlit' at http://127.0.0.1:${TEST_PORT}"
fi

cleanup_test
pass "stopped validation container"

echo
echo -e "${CYAN}[push] ${FULL_IMAGE}${NC}"
echo

push_multi() {
    if docker buildx inspect "$BUILDER_NAME" >/dev/null 2>&1; then
        docker buildx use "$BUILDER_NAME" >/dev/null
    else
        docker buildx create --name "$BUILDER_NAME" --driver docker-container --use >/dev/null
    fi
    docker buildx inspect --bootstrap >/dev/null
    docker buildx build --platform linux/amd64,linux/arm64 \
        -t "$FULL_IMAGE" --push "$BUILD_DIR"
}

if docker buildx version >/dev/null 2>&1; then
    push_multi
else
    docker push "$FULL_IMAGE"
fi

pass "Hub should now have ${FULL_IMAGE}"
echo
echo "Class is ready. On the cluster host:"
echo "  bash 15-ai-k8-full-project/new-style/helpers/deploy-k8s.sh"
