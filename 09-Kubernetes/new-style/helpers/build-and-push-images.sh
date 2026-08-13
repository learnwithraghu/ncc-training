#!/usr/bin/env bash
# Instructor prerequisite: build Orbital Relay 1.0 and 2.0, prove the
# pages are different, then push both tags to Docker Hub.
# Run this on your laptop before class. Students only use kubectl.
set -euo pipefail

readonly IMAGE="learnwithraghu/ncc-workshop"
readonly SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
readonly V1_DIR="${SCRIPT_DIR}/images/v1"
readonly V2_DIR="${SCRIPT_DIR}/images/v2"

GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

pass() { echo -e "  ${GREEN}ok${NC}  $1"; }
fail() { echo -e "  ${RED}fail${NC} $1"; exit 1; }

wait_for_mark() {
    local url="$1"
    local mark="$2"
    local i
    for i in $(seq 1 25); do
        if curl -fsS "$url" 2>/dev/null | grep -q "$mark"; then
            return 0
        fi
        sleep 1
    done
    return 1
}

build_and_check() {
    local tag="$1"
    local dir="$2"
    local mark="$3"
    local port="$4"
    local name="ncc-workshop-${tag//./-}"

    echo -e "${CYAN}[build] ${IMAGE}:${tag}${NC}"
    docker build --platform linux/amd64 -t "${IMAGE}:${tag}" "$dir"
    docker rm -f "$name" >/dev/null 2>&1 || true
    docker run -d --name "$name" -p "${port}:80" "${IMAGE}:${tag}" >/dev/null
    if wait_for_mark "http://127.0.0.1:${port}" "$mark"; then
        pass "curl found '${mark}' on :${port}"
    else
        docker logs "$name" || true
        docker rm -f "$name" >/dev/null 2>&1 || true
        fail "did not see '${mark}' at http://127.0.0.1:${port}"
    fi
    docker rm -f "$name" >/dev/null
}

echo "NCC Kubernetes — build and push ${IMAGE}"
echo

docker info >/dev/null 2>&1 || fail "Docker is not running"

build_and_check "1.0" "$V1_DIR" "Ground link v1" 18080
build_and_check "2.0" "$V2_DIR" "Night Pass v2" 18081

echo
echo -e "${CYAN}[push] ${IMAGE}:1.0 and :2.0${NC}"
echo "Log in as learnwithraghu if docker push asks for credentials."
echo

if docker buildx version >/dev/null 2>&1; then
    docker buildx build --platform linux/amd64,linux/arm64 \
        -t "${IMAGE}:1.0" --push "$V1_DIR"
    docker buildx build --platform linux/amd64,linux/arm64 \
        -t "${IMAGE}:2.0" --push "$V2_DIR"
else
    docker push "${IMAGE}:1.0"
    docker push "${IMAGE}:2.0"
fi

pass "Hub should now have ${IMAGE}:1.0 and ${IMAGE}:2.0"
echo
echo "Class is ready. Start at 01-run-a-pod."
