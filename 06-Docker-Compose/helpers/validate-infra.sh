#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_NAME="NCC Docker Compose Training - Infrastructure Validator"
readonly SEP="============================================================"
readonly SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
readonly APP_DIR="${SCRIPT_DIR}/../application"
readonly SANDBOX="/tmp/ncc-compose-validation-$$"
readonly PROJECT_NAME="ncc-compose-val-$$"

export COMPOSE_PROJECT_NAME="${PROJECT_NAME}"
export COMPOSE_FILE="${APP_DIR}/docker-compose.yml"

PASS=0
WARN=0
FAIL=0

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

cleanup() {
    if [ -f "${COMPOSE_FILE}" ]; then
        docker compose -p "${PROJECT_NAME}" down --volumes --remove-orphans &>/dev/null || true
    fi
    docker rmi -f "${PROJECT_NAME}-web" "${PROJECT_NAME}-worker" &>/dev/null || true
    rm -rf "${SANDBOX}"
}
trap cleanup EXIT

rm -rf "${SANDBOX}"
mkdir -p "${SANDBOX}"

echo -e "${CYAN}${SEP}${NC}"
echo -e "${CYAN}  ${SCRIPT_NAME}${NC}"
echo -e "${CYAN}${SEP}${NC}"
echo ""

# ── Environment info ──────────────────────────────────────────────────

echo -e "${CYAN}[info]${NC} Environment"
echo "  User      : $(whoami 2>/dev/null || echo 'unknown')"
echo "  Hostname  : $(hostname 2>/dev/null || echo 'unknown')"
echo "  Kernel    : $(uname -srm 2>/dev/null || echo 'unknown')"
echo "  Project   : ${PROJECT_NAME}"
echo "  App dir   : ${APP_DIR}"
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

compose_ok() {
    local desc="$1" cmd="$2" tag="${3:-compose}"
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

compose_expect() {
    local desc="$1" cmd="$2" expected="$3" tag="${4:-compose}"
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

curl_expect() {
    local desc="$1" url="$2" expected="$3" tag="${4:-api}"
    local out rc
    out=$(curl -fsS "$url" 2>&1) && true
    rc=$?
    if [ "$rc" -eq 0 ] && echo "$out" | grep -qF "$expected"; then
        echo -e "  ${GREEN}[PASS]${NC} ${tag} ${desc}"
        PASS=$((PASS + 1)); return 0
    else
        echo -e "  ${RED}[FAIL]${NC} ${tag} ${desc}  (expected \"${expected}\", rc=${rc}, got \"${out}\")"
        FAIL=$((FAIL + 1)); return 1
    fi
}

wait_for_health() {
    local timeout="${1:-60}"
    echo "  (waiting up to ${timeout}s for all services to be healthy...)"
    local i web_id redis_id worker_state web_health redis_health
    for i in $(seq 1 "$timeout"); do
        web_id=$(docker compose ps -q web 2>/dev/null || true)
        redis_id=$(docker compose ps -q redis 2>/dev/null || true)

        if [ -n "$web_id" ] && [ -n "$redis_id" ]; then
            web_health=$(docker inspect --format='{{.State.Health.Status}}' "$web_id" 2>/dev/null || echo 'unknown')
            redis_health=$(docker inspect --format='{{.State.Health.Status}}' "$redis_id" 2>/dev/null || echo 'unknown')
            worker_state=$(docker inspect --format='{{.State.Status}}' "$(docker compose ps -q worker 2>/dev/null || true)" 2>/dev/null || echo 'unknown')

            if [ "$web_health" = "healthy" ] && [ "$redis_health" = "healthy" ] && [ "$worker_state" = "running" ]; then
                echo -e "  ${GREEN}[PASS]${NC} health web+redis healthy, worker running"
                PASS=$((PASS + 1))
                return 0
            fi
        fi
        sleep 1
    done
    echo -e "  ${RED}[FAIL]${NC} health services did not become healthy within ${timeout}s"
    echo "    web health    : ${web_health:-unknown}"
    echo "    redis health  : ${redis_health:-unknown}"
    echo "    worker state  : ${worker_state:-unknown}"
    FAIL=$((FAIL + 1))
    docker compose ps 2>/dev/null || true
    return 1
}

# ── 1. Docker binary, version, daemon ─────────────────────────────────

echo -e "${CYAN}[ 1] Docker Installation & Daemon (Topic 01)${NC}"
check_cmd "docker" "tool"

DOCKER_VER=$(docker --version 2>/dev/null || echo 'unknown')
echo "  Docker    : ${DOCKER_VER}"

docker_ok "docker info (daemon running)" \
    "docker info --format '{{.ServerVersion}}' 2>/dev/null" "tool"
echo ""

# ── 2. Docker Compose plugin ───────────────────────────────────────────

echo -e "${CYAN}[ 2] Docker Compose Plugin (Topic 01)${NC}"

if docker compose version &>/dev/null 2>&1; then
    COMPOSE_VER=$(docker compose version 2>/dev/null || echo 'unknown')
    echo -e "  ${GREEN}[PASS]${NC} tool docker compose plugin"
    PASS=$((PASS + 1))
    echo "  Compose   : ${COMPOSE_VER}"
else
    echo -e "  ${RED}[FAIL]${NC} tool docker compose plugin not found"
    FAIL=$((FAIL + 1))
fi

docker_ok "docker compose ps works" \
    "docker compose ps 2>&1 | grep -q . && echo ok" "tool"
echo ""

# ── 3. Optional curl ──────────────────────────────────────────────────

echo -e "${CYAN}[ 3] Optional Tools (Topic 01)${NC}"
warn_cmd "curl" "api"
echo ""

# ── 4. Project files ──────────────────────────────────────────────────

echo -e "${CYAN}[ 4] Project Files (Topic 02)${NC}"

for file in Dockerfile docker-compose.yml .env.example .dockerignore app.py worker.py requirements.txt; do
    if [ -f "${APP_DIR}/${file}" ]; then
        echo -e "  ${GREEN}[PASS]${NC} files ${file} exists"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}[FAIL]${NC} files ${file} not found in ${APP_DIR}"
        FAIL=$((FAIL + 1))
    fi
done

if [ -f "${APP_DIR}/.env.example" ]; then
    for key in ENVIRONMENT APP_VERSION REDIS_HOST REDIS_PORT QUEUE_NAME DATA_DIR; do
        if grep -qE "^${key}=" "${APP_DIR}/.env.example"; then
            echo -e "  ${GREEN}[PASS]${NC} envfile ${key} defined in .env.example"
            PASS=$((PASS + 1))
        else
            echo -e "  ${RED}[FAIL]${NC} envfile ${key} missing from .env.example"
            FAIL=$((FAIL + 1))
        fi
    done
fi
echo ""

# ── 5. Port availability ──────────────────────────────────────────────

echo -e "${CYAN}[ 5] Port 5000 Available (Topic 04)${NC}"

if command -v ss &>/dev/null && ss -tln 2>/dev/null | grep -q ':5000'; then
    echo -e "  ${RED}[FAIL]${NC} port port 5000 is already in use"
    FAIL=$((FAIL + 1))
elif command -v netstat &>/dev/null && netstat -tln 2>/dev/null | grep -q ':5000'; then
    echo -e "  ${RED}[FAIL]${NC} port port 5000 is already in use"
    FAIL=$((FAIL + 1))
else
    echo -e "  ${GREEN}[PASS]${NC} port port 5000 is free"
    PASS=$((PASS + 1))
fi
echo ""

# ── 6. Compose config validation ──────────────────────────────────────

echo -e "${CYAN}[ 6] Compose Config Validation (Topic 03)${NC}"

compose_ok "docker compose config renders" \
    "docker compose config >/dev/null 2>&1 && echo ok" "config"

compose_expect "docker compose config shows services" \
    "docker compose config 2>&1 | grep -q '^services:' && echo ok" "ok" "config"

compose_expect "docker compose config lists web, worker, redis" \
    "docker compose config 2>&1 | grep -qE 'web:|worker:|redis:' && echo ok" "ok" "config"

compose_expect "docker compose config lists named volumes" \
    "docker compose config 2>&1 | grep -q '^volumes:' && echo ok" "ok" "config"
echo ""

# ── 7. Build and start services ───────────────────────────────────────

echo -e "${CYAN}[ 7] Build and Start Services (Topic 04)${NC}"

docker compose down --volumes --remove-orphans &>/dev/null || true

compose_ok "docker compose up -d --build succeeds" \
    "timeout 240 docker compose up -d --build 2>&1 && echo ok" "up"

compose_expect "docker compose ps shows running services" \
    "docker compose ps --format '{{.Service}}' | sort -u | grep -cE '^(web|worker|redis)$' | grep -q '3' && echo ok" "ok" "ps"

wait_for_health 60
echo ""

# ── 8. Health checks and dependencies ─────────────────────────────────

echo -e "${CYAN}[ 8] Health Checks and Dependencies (Topic 05)${NC}"

compose_expect "redis service healthcheck defined" \
    "docker compose config 2>&1 | awk '/^  redis:/{p=1} p{print} /^  [a-z]+:/{if(p && \$0 !~ /^  redis:/){exit}}' | grep -q 'healthcheck' && echo ok" "ok" "health"

compose_expect "web service healthcheck defined" \
    "docker compose config 2>&1 | awk '/^  web:/{p=1} p{print} /^  [a-z]+:/{if(p && \$0 !~ /^  web:/){exit}}' | grep -q 'healthcheck' && echo ok" "ok" "health"

compose_expect "web depends_on redis with condition" \
    "docker compose config 2>&1 | grep -A8 'depends_on' | grep -q 'condition' && echo ok" "ok" "depends"

docker_expect "web container reports healthy" \
    "docker inspect --format='{{.State.Health.Status}}' \"$(docker compose ps -q web)\" 2>&1" \
    "healthy" "health"

docker_expect "redis container reports healthy" \
    "docker inspect --format='{{.State.Health.Status}}' \"$(docker compose ps -q redis)\" 2>&1" \
    "healthy" "health"
echo ""

# ── 9. Environment and env files ──────────────────────────────────────

echo -e "${CYAN}[ 9] Environment and Env Files (Topic 06)${NC}"

if command -v curl &>/dev/null; then
    curl_expect "GET / returns environment from .env.example" \
        "http://localhost:5000/" "training" "env"

    curl_expect "GET / returns app_version from .env.example" \
        "http://localhost:5000/" "1.0" "env"
else
    echo -e "  ${YELLOW}[WARN]${NC} env curl not found — skipping env endpoint tests"
    WARN=$((WARN + 2))
fi
echo ""

# ── 10. Volumes and persistent data ───────────────────────────────────

echo -e "${CYAN}[10] Volumes and Persistent Data (Topic 07)${NC}"

if command -v curl &>/dev/null; then
    curl -fsS -X POST http://localhost:5000/events \
        -H 'Content-Type: application/json' \
        -d '{"title":"volume-check"}' >/dev/null 2>&1 || true
    sleep 3

    curl_expect "POST /events and GET /processed shows persisted data" \
        "http://localhost:5000/processed" "volume-check" "volume"

    docker compose down &>/dev/null || true
    sleep 2

    compose_ok "docker compose up -d after down" \
        "docker compose up -d 2>&1 && echo ok" "volume"

    wait_for_health 60

    curl_expect "processed data survives compose down + up" \
        "http://localhost:5000/processed" "volume-check" "volume"
else
    echo -e "  ${YELLOW}[WARN]${NC} volume curl not found — skipping persistence tests"
    WARN=$((WARN + 2))
fi
echo ""

# ── 11. Queue workflow with worker ────────────────────────────────────

echo -e "${CYAN}[11] Queue Workflow with Worker (Topic 08)${NC}"

if command -v curl &>/dev/null; then
    curl -fsS -X POST http://localhost:5000/events \
        -H 'Content-Type: application/json' \
        -d '{"title":"event-1"}' >/dev/null 2>&1 || true
    curl -fsS -X POST http://localhost:5000/events \
        -H 'Content-Type: application/json' \
        -d '{"title":"event-2"}' >/dev/null 2>&1 || true

    sleep 3

    curl_expect "GET /processed shows queued events were processed" \
        "http://localhost:5000/processed" "event-1" "queue"

    curl_expect "GET /processed shows second queued event" \
        "http://localhost:5000/processed" "event-2" "queue"
else
    echo -e "  ${YELLOW}[WARN]${NC} queue curl not found — skipping queue tests"
    WARN=$((WARN + 2))
fi
echo ""

# ── 12. Logs, exec, and troubleshooting ─────────────────────────────────

echo -e "${CYAN}[12] Logs, Exec, and Troubleshooting (Topic 09)${NC}"

# Generate fresh log lines before reading logs so the check is deterministic.
if command -v curl &>/dev/null; then
    curl -fsS http://localhost:5000/health >/dev/null 2>&1 || true
    sleep 1
fi

compose_ok "docker compose logs web returns output" \
    "docker compose logs --tail 5 web 2>&1 | grep -q . && echo ok" "logs"

compose_ok "docker compose logs worker returns output" \
    "docker compose logs --tail 5 worker 2>&1 | grep -q . && echo ok" "logs"

compose_ok "docker compose logs redis returns output" \
    "docker compose logs --tail 5 redis 2>&1 | grep -q . && echo ok" "logs"

compose_expect "docker compose exec web lists /app/data" \
    "docker compose exec web sh -c 'ls /app/data' 2>&1 | grep -q .  && echo ok" "ok" "exec"

compose_expect "docker compose exec web reads processed.log" \
    "docker compose exec web sh -c 'cat /app/data/processed.log' 2>&1 | grep -q 'event-1' && echo ok" "ok" "exec"
echo ""

# ── 13. Service scaling patterns ──────────────────────────────────────

echo -e "${CYAN}[13] Service Scaling Patterns (Topic 10)${NC}"

compose_ok "docker compose up -d --scale worker=3" \
    "docker compose up -d --scale worker=3 2>&1 && echo ok" "scale"

sleep 3

compose_expect "three worker containers are running" \
    "docker compose ps --format '{{.Service}}' | grep -c '^worker$'" \
    "3" "scale"

compose_ok "scale back to single worker" \
    "docker compose up -d --scale worker=1 2>&1 && echo ok" "scale"
echo ""

# ── 14. Rebuild and rollout workflow ──────────────────────────────────

echo -e "${CYAN}[14] Rebuild and Rollout Workflow (Topic 11)${NC}"

compose_ok "docker compose build --no-cache succeeds" \
    "timeout 240 docker compose build --no-cache 2>&1 && echo ok" "rebuild"

compose_ok "docker compose up -d after rebuild" \
    "docker compose up -d 2>&1 && echo ok" "rebuild"

wait_for_health 60

if command -v curl &>/dev/null; then
    curl_expect "GET /health responds after rebuild" \
        "http://localhost:5000/health" "healthy" "rebuild"
else
    echo -e "  ${YELLOW}[WARN]${NC} rebuild curl not found — skipping health endpoint check"
    WARN=$((WARN + 1))
fi
echo ""

# ── 15. Compose mini workflow ─────────────────────────────────────────

echo -e "${CYAN}[15] Compose Mini Workflow (Topic 12)${NC}"

compose_ok "docker compose up -d --build (mini workflow)" \
    "timeout 240 docker compose up -d --build 2>&1 && echo ok" "mini"

wait_for_health 60

if command -v curl &>/dev/null; then
    curl -fsS -X POST http://localhost:5000/events \
        -H 'Content-Type: application/json' \
        -d '{"title":"final-workflow"}' >/dev/null 2>&1 || true
    sleep 3

    curl_expect "GET /processed shows final-workflow event" \
        "http://localhost:5000/processed" "final-workflow" "mini"

    compose_ok "docker compose logs --tail 20 returns output" \
        "docker compose logs --tail 20 2>&1 | grep -q .  && echo ok" "mini"
else
    echo -e "  ${YELLOW}[WARN]${NC} mini curl not found — skipping workflow endpoint tests"
    WARN=$((WARN + 2))
fi

docker compose down --volumes --remove-orphans &>/dev/null || true
echo ""

# ── 16. Final cleanup verification ────────────────────────────────────

echo -e "${CYAN}[16] Cleanup Verification${NC}"

cleanup

if docker compose ps --format '{{.Name}}' 2>/dev/null | grep -q .; then
    echo -e "  ${RED}[FAIL]${NC} cleanup project containers still present"
    FAIL=$((FAIL + 1))
else
    echo -e "  ${GREEN}[PASS]${NC} cleanup project containers removed"
    PASS=$((PASS + 1))
fi

if docker images --format '{{.Repository}}' 2>/dev/null | grep -q "^${PROJECT_NAME}"; then
    echo -e "  ${YELLOW}[WARN]${NC} cleanup validation images may still be present"
    WARN=$((WARN + 1))
else
    echo -e "  ${GREEN}[PASS]${NC} cleanup validation images removed"
    PASS=$((PASS + 1))
fi
echo ""

# ── Summary ───────────────────────────────────────────────────────────

echo -e "${CYAN}${SEP}${NC}"
echo ""
printf "  %-30s %s\n" "Checks passed:"    "${GREEN}${PASS}${NC}"
printf "  %-30s %s\n" "Optional missing:" "${YELLOW}${WARN}${NC}"
printf "  %-30s %s\n" "Required missing:" "${RED}${FAIL}${NC}"
echo ""

if [ "$FAIL" -eq 0 ]; then
    echo -e "${GREEN}  Docker Compose environment validated.${NC}"
    echo -e "${GREEN}  Ready for the NCC Docker Compose training module.${NC}"
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
