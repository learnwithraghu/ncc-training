#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_NAME="NCC Jenkins Training - Infrastructure Validator"
readonly SEP="============================================================"
readonly SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
readonly MODULE_DIR="${SCRIPT_DIR}/.."
readonly JENKINS_DIR="${MODULE_DIR}/jenkins"
readonly APP_DIR="${MODULE_DIR}/application"

PASS=0
WARN=0
FAIL=0

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}${SEP}${NC}"
echo -e "${CYAN}  ${SCRIPT_NAME}${NC}"
echo -e "${CYAN}${SEP}${NC}"
echo ""

echo -e "${CYAN}[info]${NC} Environment"
echo "  User      : $(whoami 2>/dev/null || echo 'unknown')"
echo "  Hostname  : $(hostname 2>/dev/null || echo 'unknown')"
echo "  Module    : ${MODULE_DIR}"
echo ""

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

check_file() {
    local path="$1" tag="${2:-}"
    if [ -e "$path" ]; then
        echo -e "  ${GREEN}[PASS]${NC} ${tag} ${path}"
        PASS=$((PASS + 1)); return 0
    else
        echo -e "  ${RED}[FAIL]${NC} ${tag} ${path}  (missing)"
        FAIL=$((FAIL + 1)); return 1
    fi
}

echo -e "${CYAN}[1/4]${NC} Docker availability"
check_cmd docker "Docker CLI"
if docker info &>/dev/null; then
    echo -e "  ${GREEN}[PASS]${NC} Docker daemon reachable"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} Docker daemon not reachable (is it running / do you have permission?)"
    FAIL=$((FAIL + 1))
fi
echo ""

echo -e "${CYAN}[2/4]${NC} Ports free for Jenkins (8080, 50000)"
for port in 8080 50000; do
    if command -v lsof &>/dev/null && lsof -i ":${port}" &>/dev/null; then
        echo -e "  ${YELLOW}[WARN]${NC} port ${port} is already in use"
        WARN=$((WARN + 1))
    else
        echo -e "  ${GREEN}[PASS]${NC} port ${port} looks free"
        PASS=$((PASS + 1))
    fi
done
echo ""

echo -e "${CYAN}[3/4]${NC} Module files"
check_file "${JENKINS_DIR}/Dockerfile" "Jenkins Dockerfile"
check_file "${JENKINS_DIR}/plugins.txt" "plugins.txt"
check_file "${JENKINS_DIR}/Jenkinsfile" "reference Jenkinsfile"
check_file "${APP_DIR}/app.py" "lab app"
check_file "${APP_DIR}/test_app.py" "lab app tests"
check_file "${APP_DIR}/Dockerfile" "lab app Dockerfile (Topic 14)"
echo ""

echo -e "${CYAN}[4/4]${NC} Lab app sanity check (runs on the host, outside any container)"
if command -v python3 &>/dev/null; then
    if (cd "${APP_DIR}" && python3 -m py_compile app.py test_app.py); then
        echo -e "  ${GREEN}[PASS]${NC} lab app compiles"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}[FAIL]${NC} lab app failed to compile"
        FAIL=$((FAIL + 1))
    fi
else
    echo -e "  ${YELLOW}[WARN]${NC} python3 not found on host - skipping (Jenkins container has its own python3)"
    WARN=$((WARN + 1))
fi
echo ""

echo -e "${CYAN}${SEP}${NC}"
echo -e "  Results: ${GREEN}${PASS} passed${NC}, ${YELLOW}${WARN} warnings${NC}, ${RED}${FAIL} failed${NC}"
echo -e "${CYAN}${SEP}${NC}"

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
exit 0
