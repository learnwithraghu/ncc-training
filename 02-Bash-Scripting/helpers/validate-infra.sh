#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_NAME="NCC Bash Scripting Training - Infrastructure Validator"
readonly SEP="============================================================"
readonly SANDBOX="/tmp/ncc-bash-validation-$$"

PASS=0
WARN=0
FAIL=0

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

cleanup() { rm -rf "$SANDBOX"; }
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

BASH_VER=$(bash --version 2>/dev/null | head -1 || echo 'unknown')
echo "  Bash      : ${BASH_VER}"
BASH_MAJOR=$(echo "$BASH_VER" | grep -oP '\d+' | head -1 || echo 0)
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
        echo -e "  ${YELLOW}[WARN]${NC} ${tag} ${cmd}  (not found — optional)"
        WARN=$((WARN + 1))
    fi
}

func_ok() {
    local desc="$1" cmd="$2" tag="${3:-func}"
    if eval "$cmd" &>/dev/null; then
        echo -e "  ${GREEN}[PASS]${NC} ${tag} ${desc}"
        PASS=$((PASS + 1)); return 0
    else
        echo -e "  ${RED}[FAIL]${NC} ${tag} ${desc}"
        FAIL=$((FAIL + 1)); return 1
    fi
}

# Run a test script and check its stdout for an expected string.
run_script_expect() {
    local desc="$1" script_file="$2" expected="$3" tag="${4:-func}"
    local out
    chmod +x "$script_file"
    out=$(bash "$script_file" 2>/dev/null) || true
    if echo "$out" | grep -qF "$expected"; then
        echo -e "  ${GREEN}[PASS]${NC} ${tag} ${desc}"
        PASS=$((PASS + 1)); return 0
    else
        echo -e "  ${RED}[FAIL]${NC} ${tag} ${desc}  (expected \"${expected}\", got \"${out}\")"
        FAIL=$((FAIL + 1)); return 1
    fi
}

# ── 1. Bash Version ───────────────────────────────────────────────

echo -e "${CYAN}[ 1] Bash Version${NC}"
if [ "$BASH_MAJOR" -ge 4 ] 2>/dev/null; then
    echo -e "  ${GREEN}[PASS]${NC} bash  Bash ${BASH_MAJOR}.x (requires 4+)"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} bash  Bash ${BASH_MAJOR}.x (requires 4+)"
    FAIL=$((FAIL + 1))
fi
echo ""

# ── 2. External CLI Tools ─────────────────────────────────────────

echo -e "${CYAN}[ 2] External CLI Tools${NC}"
check_cmd "chmod"    "tool"
check_cmd "touch"    "tool"
check_cmd "cp"       "tool"
check_cmd "mkdir"    "tool"
check_cmd "ls"       "tool"
check_cmd "rm"       "tool"
check_cmd "basename" "tool"
check_cmd "grep"     "tool"
check_cmd "date"     "tool"
check_cmd "cat"      "tool"
check_cmd "echo"     "tool"
echo ""
echo "  (read  — bash builtin, verified in section 4)"
echo ""

# ── Optional tools from demo-infra-requirement ───────────────────

echo -e "${CYAN}[ 2b] Optional CLI Tools (demo-infra list)${NC}"
warn_cmd "awk"  "opt"
warn_cmd "sed"  "opt"
warn_cmd "cut"  "opt"
warn_cmd "sort" "opt"
echo ""

# ── 3. Shebang & Script Execution ─────────────────────────────────

echo -e "${CYAN}[ 3] Shebang & Script Execution${NC}"
cat > "$SANDBOX/test-shebang.sh" << 'EOF'
#!/bin/bash
echo "shebang-ok"
EOF
run_script_expect "shebang + chmod +x"  "$SANDBOX/test-shebang.sh" "shebang-ok" "syntax"

cat > "$SANDBOX/test-heredoc.sh" << 'EOF'
#!/bin/bash
# heredoc with quoted delimiter – $VAR should NOT expand
cat > /tmp/ncc-hd-test-$$.txt << 'INNEREOF'
$HOME should be literal
INNEREOF
grep -q '$HOME' "/tmp/ncc-hd-test-$$.txt" && echo "heredoc-quote-ok"
rm -f "/tmp/ncc-hd-test-$$.txt"
EOF
run_script_expect "heredoc ('EOF' quoting)" "$SANDBOX/test-heredoc.sh" "heredoc-quote-ok" "syntax"
echo ""

# ── 4. Variables & User Input ─────────────────────────────────────

echo -e "${CYAN}[ 4] Variables & User Input${NC}"

cat > "$SANDBOX/test-vars.sh" << 'EOF'
#!/bin/bash
NAME="ncc-learner"
echo "hello ${NAME}"
EOF
run_script_expect "variable assignment & expansion" "$SANDBOX/test-vars.sh" "hello ncc-learner" "syntax"

cat > "$SANDBOX/test-read.sh" << 'EOF'
#!/bin/bash
read -p "Name: " USERNAME
echo "user=${USERNAME}"
EOF
out=$(echo "alice" | bash "$SANDBOX/test-read.sh" 2>/dev/null) || true
if echo "$out" | grep -qF "user=alice"; then
    echo -e "  ${GREEN}[PASS]${NC} syntax read -p (user input)"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} syntax read -p (user input)  (got \"${out}\")"
    FAIL=$((FAIL + 1))
fi

cat > "$SANDBOX/test-quote.sh" << 'EOF'
#!/bin/bash
VAL="a  b"
echo "$VAL"
EOF
run_script_expect "quoting preserves spacing" "$SANDBOX/test-quote.sh" "a  b" "syntax"
echo ""

# ── 5. Command Substitution ───────────────────────────────────────

echo -e "${CYAN}[ 5] Command Substitution${NC}"

cat > "$SANDBOX/test-subst.sh" << 'EOF'
#!/bin/bash
NOW=$(date +%Y 2>/dev/null || echo "0000")
echo "year=${NOW}"
EOF
out=$(bash "$SANDBOX/test-subst.sh" 2>/dev/null) || true
if echo "$out" | grep -qP 'year=\d{4}'; then
    echo -e "  ${GREEN}[PASS]${NC} syntax \$(command)"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} syntax \$(command)  (got \"${out}\")"
    FAIL=$((FAIL + 1))
fi
echo ""

# ── 6. Conditionals ───────────────────────────────────────────────

echo -e "${CYAN}[ 6] Conditionals (if / elif / else / fi)${NC}"

cat > "$SANDBOX/test-if.sh" << 'EOF'
#!/bin/bash
A=10
B=5
if [ "$A" -gt "$B" ]; then
    echo "gt-ok"
else
    echo "gt-fail"
fi
if [ "$A" -eq "$B" ]; then
    echo "eq-fail"
else
    echo "eq-ok"
fi
touch /tmp/ncc-if-test-$$.txt
if [ -f /tmp/ncc-if-test-$$.txt ]; then
    echo "file-test-ok"
fi
rm -f /tmp/ncc-if-test-$$.txt
EOF
run_script_expect "if/else with -gt"   "$SANDBOX/test-if.sh" "gt-ok"       "syntax"
run_script_expect "if/else with -eq"   "$SANDBOX/test-if.sh" "eq-ok"       "syntax"
run_script_expect "if with [ -f ]"     "$SANDBOX/test-if.sh" "file-test-ok" "syntax"

cat > "$SANDBOX/test-exitcode.sh" << 'EOF'
#!/bin/bash
true
echo "exitcode=$?"
false
echo "exitcode=$?"
EOF
run_script_expect "exit code \$? (zero)"  "$SANDBOX/test-exitcode.sh" "exitcode=0" "syntax"
run_script_expect "exit code \$? (non-zero)" "$SANDBOX/test-exitcode.sh" "exitcode=1" "syntax"

cat > "$SANDBOX/test-elif.sh" << 'EOF'
#!/bin/bash
VAL=20
if [ "$VAL" -eq 10 ]; then
    echo "ten"
elif [ "$VAL" -eq 20 ]; then
    echo "elif-ok"
else
    echo "other"
fi
EOF
run_script_expect "elif branching" "$SANDBOX/test-elif.sh" "elif-ok" "syntax"
echo ""

# ── 7. For Loops ──────────────────────────────────────────────────

echo -e "${CYAN}[ 7] For Loops${NC}"

cat > "$SANDBOX/test-for-words.sh" << 'EOF'
#!/bin/bash
for fruit in apple banana cherry; do
    echo "fruit=${fruit}"
done
EOF
run_script_expect "for loop (word list)" "$SANDBOX/test-for-words.sh" "fruit=banana" "syntax"

cat > "$SANDBOX/test-for-glob.sh" << 'EOF'
#!/bin/bash
mkdir -p /tmp/ncc-glob-test-$$
touch /tmp/ncc-glob-test-$$/a.txt /tmp/ncc-glob-test-$$/b.txt /tmp/ncc-glob-test-$$/c.log
count=0
for f in /tmp/ncc-glob-test-$$/*.txt; do
    count=$((count + 1))
done
echo "glob-count=${count}"
rm -rf /tmp/ncc-glob-test-$$
EOF
run_script_expect "for loop (glob *.txt)" "$SANDBOX/test-for-glob.sh" "glob-count=2" "syntax"
echo ""

# ── 8. While Loop & Case ──────────────────────────────────────────

echo -e "${CYAN}[ 8] While Loop & Case${NC}"

cat > "$SANDBOX/test-while-case.sh" << 'EOF'
#!/bin/bash
choice=2
while true; do
    case "$choice" in
        1) echo "option-one"  ;;
        2) echo "case-ok"; break ;;
        *) echo "invalid"     ;;
    esac
done
EOF
run_script_expect "case pattern matching" "$SANDBOX/test-while-case.sh" "case-ok" "syntax"
run_script_expect "break exits while loop" "$SANDBOX/test-while-case.sh" "case-ok" "syntax"

func_ok "case wildcard *) default" \
    'out=$(bash -c '\''case x in 1) echo one;; *) echo default-ok;; esac'\'' 2>/dev/null); echo "$out" | grep -qF "default-ok"' \
    "syntax"
echo ""

# ── 9. Functions ──────────────────────────────────────────────────

echo -e "${CYAN}[ 9] Functions${NC}"

cat > "$SANDBOX/test-func.sh" << 'EOF'
#!/bin/bash
greet() {
    echo "hello ${1:-world}"
}
greet "ncc"
greet
EOF
run_script_expect "function with \$1 arg"   "$SANDBOX/test-func.sh" "hello ncc"   "syntax"
run_script_expect "function default param"  "$SANDBOX/test-func.sh" "hello world" "syntax"
echo ""

# ── 10. Positional Arguments ──────────────────────────────────────

echo -e "${CYAN}[10] Positional Arguments${NC}"

cat > "$SANDBOX/test-args.sh" << 'EOF'
#!/bin/bash
if [ "$#" -lt 2 ]; then
    echo "usage: $0 <arg1> <arg2>"
    exit 1
fi
echo "first=$1 second=$2"
EOF
out=$(bash "$SANDBOX/test-args.sh" alpha beta 2>/dev/null) || true
if echo "$out" | grep -qF "first=alpha second=beta"; then
    echo -e "  ${GREEN}[PASS]${NC} syntax \$1 \$2 arguments"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} syntax \$1 \$2 arguments  (got \"${out}\")"
    FAIL=$((FAIL + 1))
fi

out=$(bash "$SANDBOX/test-args.sh" 2>/dev/null) || true
if echo "$out" | grep -qF "usage:"; then
    echo -e "  ${GREEN}[PASS]${NC} syntax \$# argument count + usage"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} syntax \$# argument count + usage  (got \"${out}\")"
    FAIL=$((FAIL + 1))
fi

func_ok "exit 1 on insufficient args" \
    'bash "$SANDBOX/test-args.sh" 2>/dev/null; [ $? -eq 1 ]' \
    "syntax"
echo ""

# ── 11. Arrays ────────────────────────────────────────────────────

echo -e "${CYAN}[11] Arrays${NC}"

cat > "$SANDBOX/test-array.sh" << 'EOF'
#!/bin/bash
arr=(alpha beta gamma)
for item in "${arr[@]}"; do
    echo "arr-item=${item}"
done
EOF
run_script_expect "array declaration and iteration" "$SANDBOX/test-array.sh" "arr-item=beta" "syntax"
echo ""

# ── 12. set -e (fail-fast) ────────────────────────────────────────

echo -e "${CYAN}[12] set -e (fail-fast)${NC}"

cat > "$SANDBOX/test-sete.sh" << 'EOF'
#!/bin/bash
set -e
echo "before"
true
echo "sete-ok"
EOF
run_script_expect "set -e does not break on success" "$SANDBOX/test-sete.sh" "sete-ok" "syntax"

func_ok "set -e exits on failure" \
    'bash -c '\''set -e; false; echo "should-not-print"'\'' 2>/dev/null; [ $? -eq 1 ]' \
    "syntax"
echo ""

# ── 13. set -x (tracing) ──────────────────────────────────────────

echo -e "${CYAN}[13] set -x (debug tracing)${NC}"

out=$(bash -c 'set -x; echo "trace-test-ok"; set +x' 2>&1) || true
if echo "$out" | grep -qF "+ echo" && echo "$out" | grep -qF "trace-test-ok"; then
    echo -e "  ${GREEN}[PASS]${NC} syntax set -x tracing enabled"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} syntax set -x tracing enabled  (got \"${out}\")"
    FAIL=$((FAIL + 1))
fi

out=$(bash -c 'set -x; set +x; echo "trace-test-ok2"' 2>&1) || true
if echo "$out" | grep -qF "+ set +x" && ! echo "$out" | grep -qF "+ echo"; then
    echo -e "  ${GREEN}[PASS]${NC} syntax set +x tracing disabled"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} syntax set +x tracing disabled  (got \"${out}\")"
    FAIL=$((FAIL + 1))
fi
echo ""

# ── 14. Error Redirection ─────────────────────────────────────────

echo -e "${CYAN}[14] Error Redirection (2>/dev/null)${NC}"

func_ok "2>/dev/null suppresses stderr" \
    '(echo "err to stderr" >&2) 2>/dev/null' \
    "syntax"

cat > "$SANDBOX/test-2redir.sh" << 'EOF'
#!/bin/bash
ls /no/such/path 2>/dev/null
echo "stderr-suppressed-ok"
EOF
run_script_expect "stderr redirect in script" "$SANDBOX/test-2redir.sh" "stderr-suppressed-ok" "syntax"
echo ""

# ── Summary ───────────────────────────────────────────────────────

echo -e "${CYAN}${SEP}${NC}"
echo ""
printf "  %-24s %s\n" "Checks passed:"    "${GREEN}${PASS}${NC}"
printf "  %-24s %s\n" "Optional missing:" "${YELLOW}${WARN}${NC}"
printf "  %-24s %s\n" "Required missing:" "${RED}${FAIL}${NC}"
echo ""

if [ "$FAIL" -eq 0 ]; then
    echo -e "${GREEN}  Bash scripting environment validated.${NC}"
    echo -e "${GREEN}  Ready for the NCC Bash training module.${NC}"
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
