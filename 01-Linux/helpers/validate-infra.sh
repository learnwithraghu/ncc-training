#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_NAME="NCC Linux Training - Infrastructure Validator"
readonly SEP="============================================================"

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

# ── Environment info ──────────────────────────────────────────────

echo -e "${CYAN}[info]${NC} Environment"
echo "  User      : $(whoami 2>/dev/null || echo 'unknown')"
echo "  Hostname  : $(hostname 2>/dev/null || echo 'unknown')"
echo "  Kernel    : $(uname -srm 2>/dev/null || echo 'unknown')"
echo "  Shell     : ${SHELL:-unknown}"
echo ""

# ── Helpers ───────────────────────────────────────────────────────

check_cmd() {
    local cmd="$1"
    local category="${2:-}"
    local tag="${category:+[${category}]}"

    if command -v "$cmd" &>/dev/null; then
        echo -e "  ${GREEN}[PASS]${NC} ${tag} ${cmd}"
        PASS=$((PASS + 1))
        return 0
    else
        echo -e "  ${RED}[FAIL]${NC} ${tag} ${cmd}  (not found)"
        FAIL=$((FAIL + 1))
        return 1
    fi
}

functional_test() {
    local desc="$1"
    local cmd="$2"
    local tag="${3:-}"

    if eval "$cmd" &>/dev/null; then
        echo -e "  ${GREEN}[PASS]${NC} ${tag} ${desc}"
        PASS=$((PASS + 1))
        return 0
    else
        echo -e "  ${RED}[FAIL]${NC} ${tag} ${desc}"
        FAIL=$((FAIL + 1))
        return 1
    fi
}

warn_cmd() {
    local cmd="$1"
    local tag="${2:-}"

    if command -v "$cmd" &>/dev/null; then
        echo -e "  ${GREEN}[PASS]${NC} ${tag} ${cmd}"
        PASS=$((PASS + 1))
    else
        echo -e "  ${YELLOW}[WARN]${NC} ${tag} ${cmd}  (not found — optional)"
        WARN=$((WARN + 1))
    fi
}

# ── 1. Navigation ─────────────────────────────────────────────────

echo -e "${CYAN}[ 1] Navigation${NC}"
check_cmd "pwd"    "nav"
check_cmd "ls"     "nav"
check_cmd "cd"     "nav"      # shell builtin — should always pass
check_cmd "clear"  "nav"
echo ""

# ── 2. Directory & File Creation ──────────────────────────────────

echo -e "${CYAN}[ 2] Directory & File Creation${NC}"
check_cmd "mkdir"  "create"
check_cmd "touch"  "create"
echo ""

# ── 3. File Management (copy / move / remove) ─────────────────────

echo -e "${CYAN}[ 3] File Management${NC}"
check_cmd "cp"     "manage"
check_cmd "mv"     "manage"
check_cmd "rm"     "manage"
echo ""

# ── 4. File Viewing ───────────────────────────────────────────────

echo -e "${CYAN}[ 4] File Viewing${NC}"
check_cmd "cat"    "view"
check_cmd "head"   "view"
check_cmd "tail"   "view"
warn_cmd "less"    "view"
echo ""

# ── 5. Text Editors ───────────────────────────────────────────────

echo -e "${CYAN}[ 5] Text Editors${NC}"
warn_cmd "nano"    "editor"
warn_cmd "vim"     "editor"
echo ""

# ── 6. Searching ──────────────────────────────────────────────────

echo -e "${CYAN}[ 6] Searching${NC}"
check_cmd "grep"   "search"
check_cmd "find"   "search"
echo ""

# ── 7. Permissions ────────────────────────────────────────────────

echo -e "${CYAN}[ 7] Permissions${NC}"
check_cmd "chmod"  "perm"
echo ""

# ── 8. Process Management ─────────────────────────────────────────

echo -e "${CYAN}[ 8] Process Management${NC}"
check_cmd "ps"     "proc"
check_cmd "pgrep"  "proc"
check_cmd "kill"   "proc"
check_cmd "sleep"  "proc"
check_cmd "top"    "proc"
echo ""

# ── 9. System Information ─────────────────────────────────────────

echo -e "${CYAN}[ 9] System Information${NC}"
check_cmd "df"     "sysinfo"
check_cmd "du"     "sysinfo"
check_cmd "free"   "sysinfo"
check_cmd "uname"  "sysinfo"
check_cmd "whoami" "sysinfo"
echo ""

# ── 10. Redirection & Pipes ───────────────────────────────────────

echo -e "${CYAN}[10] Redirection & Pipes${NC}"
check_cmd "tee"    "redirect"
check_cmd "echo"   "redirect"
check_cmd "seq"    "redirect"
echo ""

# ── 11. Archiving & Compression ───────────────────────────────────

echo -e "${CYAN}[11] Archiving & Compression${NC}"
check_cmd "tar"    "archive"
check_cmd "gzip"   "archive"
check_cmd "gunzip" "archive"
echo ""

# ── 12. Help ──────────────────────────────────────────────────────

echo -e "${CYAN}[12] Help${NC}"
check_cmd "man"    "help"
echo ""

# ── 13. Shell Feature Tests ───────────────────────────────────────

SANDBOX="/tmp/ncc-linux-validation-$$"
rm -rf "$SANDBOX"
mkdir -p "$SANDBOX"
pushd "$SANDBOX" &>/dev/null

echo -e "${CYAN}[13] Shell Features (functional)${NC}"

# globbing
functional_test "globbing (*.txt)"         'touch a.txt b.txt && ls *.txt'                      "func"
# pipe
functional_test "pipe (echo | grep)"       'echo "hello" | grep hello'                          "func"
# output redirection >
functional_test "redirect > (overwrite)"   'echo "ok" > out.txt && grep ok out.txt'             "func"
# append >>
functional_test "redirect >> (append)"     'echo "line2" >> out.txt && grep line2 out.txt'      "func"
# error redirection 2>
functional_test "stderr redirect 2>"       '(echo "err" >&2) 2>/dev/null'                        "func"
# background &
functional_test "background job (&)"       'sleep 1 & wait'                                     "func"
# mkdir -p
functional_test "mkdir -p (nested dirs)"   'mkdir -p a/b/c && test -d a/b/c'                   "func"
# chmod
functional_test "chmod (permissions)"      'touch perm.txt && chmod 644 perm.txt'               "func"
# tar
functional_test "tar (create/extract)"     'mkdir tardir && touch tardir/f.txt && tar -czf t.tar.gz tardir && tar -tzf t.tar.gz | grep f.txt' "func"
# gzip / gunzip
functional_test "gzip / gunzip"            'echo "data" > gz.txt && gzip gz.txt && gunzip gz.txt.gz && grep data gz.txt' "func"

popd &>/dev/null
rm -rf "$SANDBOX"
echo ""

# ── Summary ───────────────────────────────────────────────────────

echo -e "${CYAN}${SEP}${NC}"
echo ""
printf "  %-24s %s\n" "Commands available:"  "${GREEN}${PASS}${NC}"
printf "  %-24s %s\n" "Optional missing:"     "${YELLOW}${WARN}${NC}"
printf "  %-24s %s\n" "Required missing:"     "${RED}${FAIL}${NC}"
echo ""

if [ "$FAIL" -eq 0 ]; then
    echo -e "${GREEN}  Infrastructure validation complete.${NC}"
    echo -e "${GREEN}  This environment is ready for the NCC Linux training module.${NC}"
    echo ""
    echo -e "${CYAN}${SEP}${NC}"
    exit 0
else
    echo -e "${RED}  Infrastructure validation complete — ${FAIL} required item(s) missing.${NC}"
    echo -e "${RED}  Install the missing tools above before using this environment.${NC}"
    echo ""
    echo -e "${CYAN}${SEP}${NC}"
    exit 1
fi
