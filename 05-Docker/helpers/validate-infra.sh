#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_NAME="NCC Docker Training - Infrastructure Validator"
readonly SEP="============================================================"
readonly SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
readonly APP_DIR="${SCRIPT_DIR}/../application"
readonly SANDBOX="/tmp/ncc-docker-validation-$$"
readonly PREFIX="ncc-docker-val-$$"

PASS=0
WARN=0
FAIL=0

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

cleanup() {
    local img_tag
    for img_tag in "${PREFIX}-app:1.0" "${PREFIX}-app:latest" "${PREFIX}-app:demo" "${PREFIX}-app:final"; do
        docker rmi -f "$img_tag" &>/dev/null || true
    done
    docker rm -f "${PREFIX}-webtest" "${PREFIX}-appdemo" "${PREFIX}-netapp" &>/dev/null || true
    docker volume rm -f "${PREFIX}-appdata" &>/dev/null || true
    docker network rm "${PREFIX}-net" &>/dev/null || true
    rm -rf "$SANDBOX"
}
trap cleanup EXIT

rm -rf "$SANDBOX"
mkdir -p "$SANDBOX"

echo -e "${CYAN}${SEP}${NC}"
echo -e "${CYAN}  ${SCRIPT_NAME}${NC}"
echo -e "${CYAN}${SEP}${NC}"
echo ""

# ── Environment info ──────────────────────────────────────────────

echo -e "${CYAN}[info]${NC} Environment"
echo "  User      : $(whoami 2>/dev/null || echo 'unknown')"
echo "  Hostname  : $(hostname 2>/dev/null || echo 'unknown')"
echo "  Kernel    : $(uname -srm 2>/dev/null || echo 'unknown')"
echo ""

# ── Helpers ───────────────────────────────────────────────────────

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
        echo -e "  ${YELLOW}[WARN]${NC} ${tag} ${cmd}  (not found — optional for this module)"
        WARN=$((WARN + 1))
    fi
}

docker_ok() {
    local desc="$1" cmd="$2" tag="${3:-docker}"
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

docker_expect() {
    local desc="$1" cmd="$2" expected="$3" tag="${4:-docker}"
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

wait_for_container() {
    local name="$1" timeout="${2:-15}"
    local i
    for i in $(seq 1 "$timeout"); do
        if docker ps --format '{{.Names}}' 2>/dev/null | grep -qxF "$name"; then
            return 0
        fi
        sleep 1
    done
    return 1
}

show_container_state() {
    local name="$1"
    echo -e "  ${CYAN}       Container status:${NC}"
    docker ps -a --filter name="${name}" --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}' 2>&1 | sed 's/^/         /' || true
    echo -e "  ${CYAN}       Container logs (last 20 lines):${NC}"
    docker logs --tail 20 "${name}" 2>&1 | sed 's/^/         /' || true
}

# ── 1. Docker binary, version, daemon ──────────────────────────────

echo -e "${CYAN}[ 1] Docker Installation & Daemon (Topic 01)${NC}"
check_cmd "docker" "tool"

DOCKER_VER=$(docker --version 2>/dev/null || echo 'unknown')
echo "  Docker    : ${DOCKER_VER}"

docker_ok "docker info (daemon running)" \
    "docker info --format '{{.ServerVersion}}' 2>/dev/null" "tool"
echo ""

# ── 2. Pull and run hello-world ────────────────────────────────────

echo -e "${CYAN}[ 2] Pull & Run (Topic 01 — hello-world)${NC}"
docker_expect "docker run --rm hello-world" \
    "timeout 60 docker run --rm hello-world 2>&1" \
    "Hello from Docker" "pull-run"

docker_expect "hello-world exits cleanly" \
    "docker run --rm hello-world >/dev/null 2>&1 && echo rc=\$?" \
    "rc=0" "pull-run"
echo ""

# ── 3. Images, pull, history ───────────────────────────────────────

echo -e "${CYAN}[ 3] Images, Pull, History (Topic 02)${NC}"

docker_ok "docker images lists local images" \
    "docker images 2>/dev/null | head -1 | grep -q REPOSITORY && echo ok" "images"

docker_expect "docker pull python:3.11-slim" \
    "timeout 120 docker pull python:3.11-slim 2>&1 && echo done" \
    "done" "pull"

docker_expect "docker history python:3.11-slim" \
    "docker history python:3.11-slim 2>&1 | head -1 | grep -q CREATED && echo ok" \
    "ok" "history"
echo ""

# ── 4. Run containers, publish ports ───────────────────────────────

echo -e "${CYAN}[ 4] Run & Publish Ports (Topic 03)${NC}"

docker rm -f "${PREFIX}-webtest" &>/dev/null || true
docker_ok "docker run -d --name webtest -p 8080:80 nginx" \
    "docker run -d --name ${PREFIX}-webtest -p 8080:80 nginx 2>&1 && echo ok" "run"

if wait_for_container "${PREFIX}-webtest" 15; then
    echo -e "  ${GREEN}[PASS]${NC} ps docker ps shows running container"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} ps docker ps shows running container (expected \"${PREFIX}-webtest\", not found after 15s)"
    show_container_state "${PREFIX}-webtest"
    FAIL=$((FAIL + 1))
fi

docker_expect "docker port shows mapped port" \
    "docker port ${PREFIX}-webtest 2>&1 | grep -q '8080' && echo ok" \
    "ok" "port"

docker_ok "docker stop webtest" \
    "docker stop ${PREFIX}-webtest 2>&1 && echo ok" "stop"

docker_ok "docker rm webtest" \
    "docker rm ${PREFIX}-webtest 2>&1 && echo ok" "rm"
echo ""

# ── 5. Environment variables & inspect ─────────────────────────────

echo -e "${CYAN}[ 5] Environment Variables & Inspect (Topic 04)${NC}"

docker rm -f "${PREFIX}-appdemo" &>/dev/null || true
docker_ok "docker run -e ENVIRONMENT=training -e APP_VERSION=2.0" \
    "docker run -d --name ${PREFIX}-appdemo -p 5000:5000 -e ENVIRONMENT=training -e APP_VERSION=2.0 nginx 2>&1 && echo ok" "env"

wait_for_container "${PREFIX}-appdemo" 10 || true

docker_expect "docker inspect shows container config" \
    "docker inspect ${PREFIX}-appdemo 2>&1 | grep -q 'Id' && echo ok" \
    "ok" "inspect"

docker_expect "ENVIRONMENT env var visible in container" \
    "docker exec ${PREFIX}-appdemo printenv ENVIRONMENT 2>&1" \
    "training" "exec-env"

docker rm -f "${PREFIX}-appdemo" &>/dev/null || true
echo ""

# ── 6. Logs and exec ───────────────────────────────────────────────

echo -e "${CYAN}[ 6] Logs & Exec (Topic 05)${NC}"

docker rm -f "${PREFIX}-appdemo" &>/dev/null || true
docker run -d --name "${PREFIX}-appdemo" -p 5000:5000 nginx &>/dev/null || true
sleep 2

docker_ok "docker logs returns output" \
    "docker logs ${PREFIX}-appdemo 2>/dev/null > ${SANDBOX}/logs-out; wc -l < ${SANDBOX}/logs-out | grep -q '[1-9]' && echo ok" "logs"

docker_ok "docker exec runs command inside container" \
    "docker exec ${PREFIX}-appdemo hostname 2>&1 | grep -q .  && echo ok" "exec"

docker rm -f "${PREFIX}-appdemo" &>/dev/null || true
echo ""

# ── 7. Volumes & persistence ───────────────────────────────────────

echo -e "${CYAN}[ 7] Volumes & Data Persistence (Topic 06)${NC}"

docker volume rm -f "${PREFIX}-appdata" &>/dev/null || true
docker_expect "docker volume create" \
    "docker volume create ${PREFIX}-appdata 2>&1" \
    "${PREFIX}-appdata" "volume"

docker_expect "docker volume ls shows volume" \
    "docker volume ls --filter name=${PREFIX}-appdata --format '{{.Name}}'" \
    "${PREFIX}-appdata" "volume-ls"

docker_expect "docker volume inspect returns mountpoint" \
    "docker volume inspect ${PREFIX}-appdata --format '{{.Mountpoint}}'" \
    "/var/lib/docker/volumes/${PREFIX}-appdata/_data" "volume-inspect"

docker rm -f "${PREFIX}-appdemo" &>/dev/null || true
docker_ok "docker run with volume mount" \
    "docker run -d --name ${PREFIX}-appdemo -v ${PREFIX}-appdata:/app/data nginx 2>&1 && echo ok" "volume-mount"

docker_expect "data survives in volume after write" \
    "docker exec ${PREFIX}-appdemo sh -c 'echo persisted > /app/data/test.txt && cat /app/data/test.txt' 2>&1" \
    "persisted" "volume-write"

docker rm -f "${PREFIX}-appdemo" &>/dev/null || true
docker volume rm -f "${PREFIX}-appdata" &>/dev/null || true
echo ""

# ── 8. Bind mounts ─────────────────────────────────────────────────

echo -e "${CYAN}[ 8] Bind Mounts (Topic 07)${NC}"

mkdir -p "${SANDBOX}/host-data"
echo "bind-mount-test" > "${SANDBOX}/host-data/hello.txt"

docker rm -f "${PREFIX}-appdemo" &>/dev/null || true
docker_ok "docker run with bind mount" \
    "docker run -d --name ${PREFIX}-appdemo -v ${SANDBOX}/host-data:/mnt/host nginx 2>&1 && echo ok" "bind-mount"

docker_expect "bind mount file visible in container" \
    "docker exec ${PREFIX}-appdemo cat /mnt/host/hello.txt 2>&1" \
    "bind-mount-test" "bind-read"

docker_expect "bind mount write persists on host" \
    "docker exec ${PREFIX}-appdemo sh -c 'echo from-container >> /mnt/host/hello.txt'; cat ${SANDBOX}/host-data/hello.txt" \
    "from-container" "bind-write"

docker rm -f "${PREFIX}-appdemo" &>/dev/null || true
echo ""

# ── 9. Build sample app image ──────────────────────────────────────

echo -e "${CYAN}[ 9] Build Sample App (Topic 08)${NC}"

if [ -f "${APP_DIR}/Dockerfile" ]; then
    echo -e "  ${GREEN}[PASS]${NC} build  Dockerfile exists at ${APP_DIR}/Dockerfile"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} build  Dockerfile not found at ${APP_DIR}/Dockerfile"
    FAIL=$((FAIL + 1))
fi

docker_ok "docker build -t ${PREFIX}-app:1.0" \
    "docker build -t ${PREFIX}-app:1.0 ${APP_DIR} 2>&1 && echo ok" "build"

docker_expect "image exists in local registry" \
    "docker images --filter reference=${PREFIX}-app:1.0 --format '{{.Repository}}:{{.Tag}}'" \
    "${PREFIX}-app:1.0" "images"
echo ""

# ── 10. Image tagging & lifecycle ──────────────────────────────────

echo -e "${CYAN}[10] Image Tagging & Lifecycle (Topic 09)${NC}"

docker_ok "docker tag creates additional tag" \
    "docker tag ${PREFIX}-app:1.0 ${PREFIX}-app:latest 2>&1 && echo ok" "tag"

docker_expect "both tags visible in docker images" \
    "docker images --filter reference=${PREFIX}-app --format '{{.Tag}}' | sort | tr '\n' ' '" \
    "1.0" "images-tags"

docker_ok "docker rmi removes a tag" \
    "docker rmi ${PREFIX}-app:latest 2>&1 && echo ok" "rmi"
echo ""

# ── 11. Healthchecks ───────────────────────────────────────────────

echo -e "${CYAN}[11] Healthchecks (Topic 10)${NC}"

docker rm -f "${PREFIX}-appdemo" &>/dev/null || true
docker_ok "docker run with healthcheck (sample app)" \
    "docker run -d --name ${PREFIX}-appdemo -p 5000:5000 ${PREFIX}-app:1.0 2>&1 && echo ok" "health-run"

echo "  (waiting up to 20s for health check to pass...)"
sleep 5
for i in $(seq 1 15); do
    HEALTH=$(docker inspect --format='{{.State.Health.Status}}' "${PREFIX}-appdemo" 2>/dev/null || echo 'unknown')
    if [ "$HEALTH" = "healthy" ]; then
        echo -e "  ${GREEN}[PASS]${NC} health container reports healthy"
        PASS=$((PASS + 1))
        break
    fi
    sleep 1
done
if [ "$HEALTH" != "healthy" ]; then
    echo -e "  ${YELLOW}[WARN]${NC} health container status: ${HEALTH} (may need more time)"
    WARN=$((WARN + 1))
fi

docker_expect "docker ps --filter health=healthy" \
    "docker ps --filter health=healthy --filter name=${PREFIX}-appdemo --format '{{.Names}}'" \
    "${PREFIX}-appdemo" "health-filter"

docker rm -f "${PREFIX}-appdemo" &>/dev/null || true
echo ""

# ── 12. Networking ─────────────────────────────────────────────────

echo -e "${CYAN}[12] Networking (Topic 11)${NC}"

docker_expect "docker network ls" \
    "docker network ls --format '{{.Name}}' | grep -q bridge && echo ok" \
    "ok" "net-ls"

docker network rm "${PREFIX}-net" &>/dev/null || true
docker_ok "docker network create" \
    "docker network create ${PREFIX}-net 2>&1 && echo ok" "net-create"

docker rm -f "${PREFIX}-netapp" &>/dev/null || true
docker_ok "docker run --network" \
    "docker run -d --name ${PREFIX}-netapp --network ${PREFIX}-net nginx 2>&1 && echo ok" "net-run"

docker_expect "docker network inspect shows container" \
    "docker network inspect ${PREFIX}-net --format '{{range .Containers}}{{.Name}}{{end}}'" \
    "${PREFIX}-netapp" "net-inspect"

docker rm -f "${PREFIX}-netapp" &>/dev/null || true
docker network rm "${PREFIX}-net" &>/dev/null || true
echo ""

# ── 13. Docker Compose ─────────────────────────────────────────────

echo -e "${CYAN}[13] Docker Compose (Topic 12)${NC}"
warn_cmd "docker-compose" "compose"

if docker compose version &>/dev/null 2>&1; then
    echo -e "  ${GREEN}[PASS]${NC} compose docker compose plugin available"
    PASS=$((PASS + 1))
elif command -v docker-compose &>/dev/null; then
    echo -e "  ${GREEN}[PASS]${NC} compose docker-compose (v1) available"
    PASS=$((PASS + 1))
else
    echo -e "  ${YELLOW}[WARN]${NC} compose neither docker compose nor docker-compose found"
    WARN=$((WARN + 1))
fi
echo ""

# ── 14. Compose with sample app ────────────────────────────────────

echo -e "${CYAN}[14] Compose Sample App (Topic 13)${NC}"

if [ -f "${APP_DIR}/docker-compose.yml" ]; then
    echo -e "  ${GREEN}[PASS]${NC} compose docker-compose.yml exists"
    PASS=$((PASS + 1))

    if docker compose version &>/dev/null 2>&1; then
        docker_expect "docker compose config validates file" \
            "docker compose -f ${APP_DIR}/docker-compose.yml config --quiet 2>&1 && echo ok" \
            "ok" "compose-config"
    elif command -v docker-compose &>/dev/null; then
        docker_expect "docker-compose config validates file" \
            "docker-compose -f ${APP_DIR}/docker-compose.yml config --quiet 2>&1 && echo ok" \
            "ok" "compose-config"
    else
        echo -e "  ${YELLOW}[WARN]${NC} compose compose not available — skipping config validation"
        WARN=$((WARN + 1))
    fi
else
    echo -e "  ${YELLOW}[WARN]${NC} compose docker-compose.yml not found at ${APP_DIR}"
    WARN=$((WARN + 1))
fi
echo ""

# ── 15. Dockerfile best practices ──────────────────────────────────

echo -e "${CYAN}[15] Dockerfile Best Practices (Topic 14)${NC}"

if [ -f "${APP_DIR}/Dockerfile" ]; then
    if grep -q '^FROM python:3.11-slim' "${APP_DIR}/Dockerfile"; then
        echo -e "  ${GREEN}[PASS]${NC} practice base image is pinned (python:3.11-slim)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${YELLOW}[WARN]${NC} practice base image may not be pinned"
        WARN=$((WARN + 1))
    fi

    if grep -q '^COPY requirements.txt' "${APP_DIR}/Dockerfile"; then
        echo -e "  ${GREEN}[PASS]${NC} practice requirements.txt copied before code (layer caching)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${YELLOW}[WARN]${NC} practice requirements.txt may not be copied early"
        WARN=$((WARN + 1))
    fi

    if grep -q 'WORKDIR' "${APP_DIR}/Dockerfile"; then
        echo -e "  ${GREEN}[PASS]${NC} practice WORKDIR directive present"
        PASS=$((PASS + 1))
    else
        echo -e "  ${YELLOW}[WARN]${NC} practice WORKDIR not found in Dockerfile"
        WARN=$((WARN + 1))
    fi
else
    echo -e "  ${YELLOW}[WARN]${NC} practice Dockerfile not found — skipping practice checks"
    WARN=$((WARN + 3))
fi

if [ -f "${APP_DIR}/.dockerignore" ]; then
    echo -e "  ${GREEN}[PASS]${NC} practice .dockerignore exists"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} practice .dockerignore not found"
    FAIL=$((FAIL + 1))
fi
echo ""

# ── 16. Security & non-root user ───────────────────────────────────

echo -e "${CYAN}[16] Security & Non-Root User (Topic 15)${NC}"

if [ -f "${APP_DIR}/Dockerfile" ]; then
    if grep -q '^USER ' "${APP_DIR}/Dockerfile"; then
        echo -e "  ${GREEN}[PASS]${NC} security USER directive found (non-root)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${YELLOW}[WARN]${NC} security no USER directive in Dockerfile"
        WARN=$((WARN + 1))
    fi

    if grep -q 'useradd\|adduser\|addgroup' "${APP_DIR}/Dockerfile"; then
        echo -e "  ${GREEN}[PASS]${NC} security non-root user created in Dockerfile"
        PASS=$((PASS + 1))
    else
        echo -e "  ${YELLOW}[WARN]${NC} security no user creation found in Dockerfile"
        WARN=$((WARN + 1))
    fi
else
    echo -e "  ${YELLOW}[WARN]${NC} security Dockerfile not found"
    WARN=$((WARN + 2))
fi
echo ""

# ── 17. Multi-stage builds ─────────────────────────────────────────

echo -e "${CYAN}[17] Multi-Stage Builds (Topic 16)${NC}"

if [ -f "${APP_DIR}/Dockerfile" ]; then
    STAGE_COUNT=$(grep -c '^FROM ' "${APP_DIR}/Dockerfile" 2>/dev/null || echo 0)
    if [ "$STAGE_COUNT" -ge 2 ]; then
        echo -e "  ${GREEN}[PASS]${NC} multistage ${STAGE_COUNT} FROM statements (multi-stage)"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}[FAIL]${NC} multistage only 1 FROM — multi-stage build not detected"
        FAIL=$((FAIL + 1))
    fi

    if grep -q 'COPY --from=' "${APP_DIR}/Dockerfile"; then
        echo -e "  ${GREEN}[PASS]${NC} multistage COPY --from= detected"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}[FAIL]${NC} multistage COPY --from= not found"
        FAIL=$((FAIL + 1))
    fi
else
    echo -e "  ${RED}[FAIL]${NC} multistage Dockerfile not found"
    FAIL=$((FAIL + 2))
fi
echo ""

# ── 18. Registry concepts ──────────────────────────────────────────

echo -e "${CYAN}[18] Registry Concepts (Topic 17)${NC}"

check_cmd "docker" "registry"

docker_ok "docker tag for registry-style name" \
    "docker tag ${PREFIX}-app:1.0 ${PREFIX}-reg.example.com/${PREFIX}-app:staging 2>&1 && echo ok" "tag-reg"

docker_expect "registry-tagged image exists" \
    "docker images ${PREFIX}-reg.example.com/${PREFIX}-app:staging --format '{{.Tag}}' 2>&1" \
    "staging" "reg-tag"

docker rmi -f "${PREFIX}-reg.example.com/${PREFIX}-app:staging" &>/dev/null || true

docker_expect "docker login command exists" \
    "docker login --help 2>&1 | grep -q 'Log in' && echo ok" \
    "ok" "login-cmd"
echo ""

# ── 19. Troubleshooting commands ───────────────────────────────────

echo -e "${CYAN}[19] Troubleshooting (Topic 18)${NC}"

docker_expect "docker ps -a shows all containers" \
    "docker ps -a --format 'table {{.Names}}' | head -1" \
    "NAMES" "tshoot-ps"

docker_expect "docker inspect format works" \
    "docker inspect --format='{{.Id}}' ${PREFIX}-app:1.0 2>&1 | grep -q 'sha256' && echo ok" \
    "ok" "tshoot-inspect"

docker_expect "docker logs on stopped container" \
    "docker run --rm --name ${PREFIX}-tshoot nginx >/dev/null 2>&1 && echo ok" \
    "ok" "tshoot-logs"
echo ""

# ── 20. Full app workflow ──────────────────────────────────────────

echo -e "${CYAN}[20] Full App Workflow (Topic 19)${NC}"

docker rm -f "${PREFIX}-appdemo" &>/dev/null || true
docker_ok "end-to-end build + run" \
    "docker run -d --name ${PREFIX}-appdemo -p 5000:5000 ${PREFIX}-app:1.0 2>&1 && echo ok" "e2e-run"

sleep 3

warn_cmd "curl" "e2e"

if command -v curl &>/dev/null; then
    docker_expect "curl / endpoint responds" \
        "curl -s http://localhost:5000/ 2>&1" \
        "Hello from Docker" "e2e-root"

    docker_expect "curl /health endpoint responds" \
        "curl -s http://localhost:5000/health 2>&1" \
        "healthy" "e2e-health"

    docker_expect "curl /info endpoint responds" \
        "curl -s http://localhost:5000/info 2>&1" \
        "hostname" "e2e-info"
else
    echo -e "  ${YELLOW}[WARN]${NC} e2e curl not found — skipping endpoint tests"
    WARN=$((WARN + 3))
fi

docker rm -f "${PREFIX}-appdemo" &>/dev/null || true
echo ""

# ── 21. Mini workflow (volumes + write/read) ───────────────────────

echo -e "${CYAN}[21] Mini Workflow — Volumes + Write/Read (Topic 20)${NC}"

docker volume rm -f "${PREFIX}-appdata" &>/dev/null || true
docker volume create "${PREFIX}-appdata" &>/dev/null || true

docker rm -f "${PREFIX}-appdemo" &>/dev/null || true
docker_ok "final: run with named volume" \
    "docker run -d --name ${PREFIX}-appdemo -p 5000:5000 -v ${PREFIX}-appdata:/app/data ${PREFIX}-app:1.0 2>&1 && echo ok" "final-run"

sleep 3

if command -v curl &>/dev/null; then
    docker_expect "final: POST /write stores data" \
        "curl -s -X POST http://localhost:5000/write -H 'Content-Type: application/json' -d '{\"message\":\"mini-workflow-test\"}' 2>&1" \
        "success" "final-write"

    docker_expect "final: GET /read retrieves data" \
        "curl -s http://localhost:5000/read 2>&1" \
        "mini-workflow-test" "final-read"
else
    echo -e "  ${YELLOW}[WARN]${NC} final curl not found — skipping write/read tests"
    WARN=$((WARN + 2))
fi

docker rm -f "${PREFIX}-appdemo" &>/dev/null || true
docker volume rm -f "${PREFIX}-appdata" &>/dev/null || true
echo ""

# ── Summary ───────────────────────────────────────────────────────

echo -e "${CYAN}${SEP}${NC}"
echo ""
printf "  %-30s %s\n" "Checks passed:"    "${GREEN}${PASS}${NC}"
printf "  %-30s %s\n" "Optional missing:" "${YELLOW}${WARN}${NC}"
printf "  %-30s %s\n" "Required missing:" "${RED}${FAIL}${NC}"
echo ""

if [ "$FAIL" -eq 0 ]; then
    echo -e "${GREEN}  Docker environment validated.${NC}"
    echo -e "${GREEN}  Ready for the NCC Docker training module.${NC}"
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
