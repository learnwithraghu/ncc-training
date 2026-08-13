#!/usr/bin/env bash
#
# validate-env.sh — confirm this environment can teach every stage of
# 06-Docker-Compose (new-style/01 .. 06) before running the class live.
#
# It checks prerequisites, then for each practical stage folder it builds
# and starts the stack, exercises the exact commands in that stage's
# guide.md (login submit, docker compose exec into web/db, MySQL SELECT),
# and tears the stack down before moving to the next stage so port 5000
# is always free.
#
# Usage:
#   ./validate-env.sh            # run all checks
#   ./validate-env.sh --keep     # don't `docker compose down` the last stage
#
set -uo pipefail

MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAGES_DIR="$MODULE_DIR/new-style"
KEEP_LAST=0
[[ "${1:-}" == "--keep" ]] && KEEP_LAST=1

PASS=0
FAIL=0
FAILED_CHECKS=()

# ---- output helpers --------------------------------------------------
c_green() { printf '\033[32m%s\033[0m\n' "$1"; }
c_red()   { printf '\033[31m%s\033[0m\n' "$1"; }
c_blue()  { printf '\033[34m%s\033[0m\n' "$1"; }

pass() { PASS=$((PASS+1)); c_green "  PASS: $1"; }
fail() { FAIL=$((FAIL+1)); FAILED_CHECKS+=("$1"); c_red "  FAIL: $1"; }
section() { echo; c_blue "== $1 =="; }

any_stack_down() {
  # best-effort cleanup of a stage folder's stack
  local dir="$1"
  (cd "$dir" && docker compose down -v >/dev/null 2>&1)
}

cleanup() {
  if [[ $KEEP_LAST -eq 0 && -n "${CURRENT_STAGE_DIR:-}" ]]; then
    any_stack_down "$CURRENT_STAGE_DIR"
  fi
}
trap cleanup EXIT

# =======================================================================
section "Prerequisites"
# =======================================================================

if command -v docker >/dev/null 2>&1; then
  pass "docker CLI found ($(docker --version))"
else
  fail "docker CLI not found — install Docker Engine"
fi

if docker compose version >/dev/null 2>&1; then
  pass "docker compose plugin found ($(docker compose version --short 2>/dev/null || docker compose version))"
else
  fail "docker compose plugin not found — install the Compose plugin"
fi

if docker ps >/dev/null 2>&1; then
  pass "docker daemon is reachable"
else
  fail "docker daemon not reachable — is Docker running / do you have permission?"
fi

if command -v curl >/dev/null 2>&1; then
  pass "curl found"
else
  fail "curl not found — needed to submit the login form"
fi

if lsof -i :5000 >/dev/null 2>&1 || nc -z 127.0.0.1 5000 >/dev/null 2>&1; then
  fail "host port 5000 is already in use — free it before class"
else
  pass "host port 5000 is free"
fi

if [[ ! -d "$STAGES_DIR" ]]; then
  c_red "Stages directory not found: $STAGES_DIR"
  exit 1
fi

# Bail out early if Docker itself isn't usable — nothing else will work.
if [[ $FAIL -gt 0 ]]; then
  section "Result"
  c_red "$FAIL prerequisite check(s) failed. Fix these before continuing."
  exit 1
fi

# =======================================================================
section "01-meet-compose (static check only, no stack)"
# =======================================================================

s1="$STAGES_DIR/01-meet-compose"
if [[ -f "$s1/guide.md" ]]; then
  pass "01-meet-compose/guide.md present"
else
  fail "01-meet-compose/guide.md missing"
fi

STAGE_FOLDERS=(02-write-the-stack 03-start-the-stack 04-login-and-save 05-login-to-container 06-inspect-mysql)

wait_for_web() {
  local tries=30
  until curl -sf http://127.0.0.1:5000/ >/dev/null 2>&1; do
    tries=$((tries-1))
    [[ $tries -le 0 ]] && return 1
    sleep 2
  done
  return 0
}

wait_for_db() {
  local dir="$1"
  local tries=20
  until (cd "$dir" && docker compose exec -T db mysqladmin ping -h 127.0.0.1 -u appuser -papppassword --silent) >/dev/null 2>&1; do
    tries=$((tries-1))
    [[ $tries -le 0 ]] && return 1
    sleep 2
  done
  return 0
}

for stage in "${STAGE_FOLDERS[@]}"; do
  section "$stage"
  dir="$STAGES_DIR/$stage"
  CURRENT_STAGE_DIR="$dir"

  if [[ ! -f "$dir/docker-compose.yaml" ]]; then
    fail "$stage: docker-compose.yaml missing"
    continue
  fi

  (cd "$dir" && docker compose up -d --build) >/tmp/compose-up-$$.log 2>&1
  if [[ $? -eq 0 ]]; then
    pass "$stage: docker compose up -d --build"
  else
    fail "$stage: docker compose up -d --build (see /tmp/compose-up-$$.log)"
    any_stack_down "$dir"
    continue
  fi

  if wait_for_web; then
    pass "$stage: web reachable on http://127.0.0.1:5000"
  else
    fail "$stage: web never became reachable on port 5000"
  fi

  if wait_for_db "$dir"; then
    pass "$stage: db is accepting MySQL connections"
  else
    fail "$stage: db never became ready"
  fi

  # Submit a login (guide.md's exact command) and confirm it's saved.
  login_resp="$(curl -s -X POST http://127.0.0.1:5000/login \
    -d "username=validate_${stage//[^a-zA-Z0-9]/_}" \
    -d "password=secret123")"
  if [[ -n "$login_resp" ]]; then
    pass "$stage: POST /login accepted"
  else
    fail "$stage: POST /login gave no response"
  fi

  # docker compose exec web sh  (stage 05's command, valid on any stage)
  if (cd "$dir" && docker compose exec -T web sh -c 'hostname && python --version') >/dev/null 2>&1; then
    pass "$stage: docker compose exec web sh works"
  else
    fail "$stage: docker compose exec web sh failed"
  fi

  # docker compose exec db bash / mysql client (stage 06's command)
  if (cd "$dir" && docker compose exec -T db bash -c 'which mysql && mysql --version') >/dev/null 2>&1; then
    pass "$stage: docker compose exec db bash works"
  else
    fail "$stage: docker compose exec db bash failed"
  fi

  select_out="$(cd "$dir" && docker compose exec -T db mysql -u appuser -papppassword appdb \
    -e "SELECT username FROM logins;" 2>/dev/null)"
  if echo "$select_out" | grep -q "validate_"; then
    pass "$stage: SELECT * FROM logins shows the saved row"
  else
    fail "$stage: SELECT from logins did not show the saved row"
  fi

  if [[ "$stage" != "${STAGE_FOLDERS[-1]}" || $KEEP_LAST -eq 0 ]]; then
    any_stack_down "$dir"
    CURRENT_STAGE_DIR=""
  fi
done

# =======================================================================
section "Result"
# =======================================================================

echo "Passed: $PASS   Failed: $FAIL"
if [[ $FAIL -gt 0 ]]; then
  c_red "Failed checks:"
  for f in "${FAILED_CHECKS[@]}"; do
    echo "  - $f"
  done
  echo
  c_red "This environment is NOT ready to teach 06-Docker-Compose yet."
  exit 1
else
  c_green "This environment is ready to teach 06-Docker-Compose."
  exit 0
fi
