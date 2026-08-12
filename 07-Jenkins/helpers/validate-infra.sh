#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_NAME="NCC Jenkins Training - Infrastructure Validator"
readonly SEP="============================================================"
readonly SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
readonly MODULE_DIR="${SCRIPT_DIR}/.."
readonly APP_DIR="${MODULE_DIR}/application"
readonly SANDBOX="/tmp/ncc-jenkins-validation-$$"

PASS=0
WARN=0
FAIL=0

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

cleanup() {
    rm -rf "$SANDBOX"
}
trap cleanup EXIT

rm -rf "$SANDBOX"
mkdir -p "$SANDBOX"

echo -e "${CYAN}${SEP}${NC}"
echo -e "${CYAN}  ${SCRIPT_NAME}${NC}"
echo -e "${CYAN}${SEP}${NC}"
echo ""

pass() { echo -e "  ${GREEN}[PASS]${NC} $1"; PASS=$((PASS + 1)); }
warn() { echo -e "  ${YELLOW}[WARN]${NC} $1"; WARN=$((WARN + 1)); }
fail() { echo -e "  ${RED}[FAIL]${NC} $1"; FAIL=$((FAIL + 1)); }

check_cmd() {
    local cmd="$1"
    if command -v "$cmd" &>/dev/null; then
        pass "tool  $cmd found"
    else
        warn "tool  $cmd not found (only required once you reach the topic that installs it)"
    fi
}

require_file() {
    local path="$1" label="$2"
    if [ -f "$path" ]; then
        pass "file  $label"
    else
        fail "file  $label  (missing: $path)"
    fi
}

port_free() {
    local port="$1"
    if (echo >/dev/tcp/127.0.0.1/"$port") 2>/dev/null; then
        warn "port  ${port} is currently in use (fine if that's your own Jenkins container)"
    else
        pass "port  ${port} is free"
    fi
}

# ── 1. Host tooling ─────────────────────────────────────────────────

echo -e "${CYAN}[ 1] Host Tooling${NC}"
check_cmd docker
check_cmd git
check_cmd python3
check_cmd curl
echo ""

# ── 2. Ports Jenkins needs ──────────────────────────────────────────

echo -e "${CYAN}[ 2] Ports (Topic 02)${NC}"
port_free 8080
port_free 50000
echo ""

# ── 3. Module files present ─────────────────────────────────────────

echo -e "${CYAN}[ 3] Module Reference Files${NC}"
require_file "${APP_DIR}/app.py" "application/app.py"
require_file "${APP_DIR}/broken.py" "application/broken.py"
require_file "${APP_DIR}/messy.py" "application/messy.py"
require_file "${APP_DIR}/test_app.py" "application/test_app.py"
require_file "${APP_DIR}/requirements.txt" "application/requirements.txt"
require_file "${APP_DIR}/Dockerfile" "application/Dockerfile"
echo ""

# ── 4. Guided-learning topic files present ──────────────────────────

echo -e "${CYAN}[ 4] Guided-Learning Topics${NC}"
for n in 01 02 03 04 05 06 07 08 09 10 11 12; do
    require_file "${MODULE_DIR}/guided-learning/topic-${n}/guide.md" "guided-learning/topic-${n}/guide.md"
done
for n in 05 06 07 08 09 10 11 12; do
    require_file "${MODULE_DIR}/guided-learning/topic-${n}/files/Jenkinsfile" "guided-learning/topic-${n}/files/Jenkinsfile"
done
echo ""

# ── 5. Host-side sanity check on the sample app ─────────────────────

echo -e "${CYAN}[ 5] Sample App Sanity (mirrors Topic 07-08)${NC}"

if command -v python3 &>/dev/null; then
    if python3 -m py_compile "${APP_DIR}/app.py" 2>/dev/null; then
        pass "syntax app.py compiles cleanly"
    else
        fail "syntax app.py failed to compile"
    fi

    if python3 -m py_compile "${APP_DIR}/broken.py" 2>/dev/null; then
        fail "syntax broken.py compiled cleanly (it should NOT - check the file wasn't accidentally fixed)"
    else
        pass "syntax broken.py correctly fails to compile"
    fi

    if python3 -m py_compile "${APP_DIR}/messy.py" 2>/dev/null; then
        pass "syntax messy.py compiles (style problems, not syntax problems)"
    else
        fail "syntax messy.py failed to compile (it should be valid, just badly styled)"
    fi
else
    warn "syntax python3 not found on host - skipping sample app sanity checks"
fi
echo ""

# ── 6. Live Jenkins container, if it exists yet ─────────────────────

echo -e "${CYAN}[ 6] Live Jenkins Container (only present from Topic 02 onward)${NC}"

if command -v docker &>/dev/null && docker ps --format '{{.Names}}' 2>/dev/null | grep -qxF jenkins; then
    pass "container jenkins is running"

    if curl -sI -o /dev/null -w '%{http_code}' http://localhost:8080 2>/dev/null | grep -qE '^(200|403)$'; then
        pass "http   Jenkins web UI responds on :8080"
    else
        warn "http   Jenkins web UI did not respond on :8080 yet (it may still be starting)"
    fi

    if docker exec jenkins python3 --version &>/dev/null; then
        pass "python3 is installed inside the jenkins container (Topic 07+)"
    else
        warn "python3 not yet installed inside the jenkins container (expected before Topic 07)"
    fi
else
    warn "container jenkins is not running yet (expected before Topic 02)"
fi
echo ""

# ── Summary ───────────────────────────────────────────────────────

echo -e "${CYAN}${SEP}${NC}"
echo ""
printf "  %-30s %s\n" "Checks passed:"    "${GREEN}${PASS}${NC}"
printf "  %-30s %s\n" "Optional missing:" "${YELLOW}${WARN}${NC}"
printf "  %-30s %s\n" "Required missing:" "${RED}${FAIL}${NC}"
echo ""

if [ "$FAIL" -eq 0 ]; then
    echo -e "${GREEN}  Jenkins module files validated.${NC}"
    echo -e "${GREEN}  Ready for the NCC Jenkins training module.${NC}"
    echo ""
    echo -e "${CYAN}${SEP}${NC}"
    exit 0
else
    echo -e "${RED}  Validation complete - ${FAIL} required item(s) missing.${NC}"
    echo -e "${RED}  Fix the failures above before using this module.${NC}"
    echo ""
    echo -e "${CYAN}${SEP}${NC}"
    exit 1
fi
