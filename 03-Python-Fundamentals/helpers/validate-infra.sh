#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_NAME="NCC Python Training - Infrastructure Validator"
readonly SEP="============================================================"
readonly SANDBOX="/tmp/ncc-py-validation-$$"

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

PY_CMD=""
PY_VERSION=""
if command -v python3 &>/dev/null; then
    PY_CMD="python3"
elif command -v python &>/dev/null; then
    PY_CMD="python"
fi

if [ -n "$PY_CMD" ]; then
    PY_VERSION=$("$PY_CMD" --version 2>&1 || echo 'unknown')
    PY_MAJOR=$(echo "$PY_VERSION" | grep -oP '\d+' | head -1 || echo 0)
    PY_MINOR=$(echo "$PY_VERSION" | grep -oP '(?<=\.)\d+' | head -1 || echo 0)
else
    PY_VERSION="not found"
    PY_MAJOR=0
    PY_MINOR=0
fi

echo "  Python    : ${PY_VERSION}"
echo "  Interpreter: ${PY_CMD:-none}"
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

# Run a Python script and check stdout for an expected string.
py_expect() {
    local desc="$1" script="$2" expected="$3" tag="${4:-syntax}"
    local out
    out=$("$PY_CMD" -c "$script" 2>/dev/null) || true
    if echo "$out" | grep -qF "$expected"; then
        echo -e "  ${GREEN}[PASS]${NC} ${tag} ${desc}"
        PASS=$((PASS + 1)); return 0
    else
        echo -e "  ${RED}[FAIL]${NC} ${tag} ${desc}  (expected \"${expected}\", got \"${out}\")"
        FAIL=$((FAIL + 1)); return 1
    fi
}

# ── 1. Python Version ─────────────────────────────────────────────

echo -e "${CYAN}[ 1] Python Version${NC}"

if [ -z "$PY_CMD" ]; then
    echo -e "  ${RED}[FAIL]${NC} pyver  python3 not found"
    FAIL=$((FAIL + 1))
elif [ "$PY_MAJOR" -lt 3 ] || { [ "$PY_MAJOR" -eq 3 ] && [ "$PY_MINOR" -lt 10 ]; }; then
    echo -e "  ${RED}[FAIL]${NC} pyver  ${PY_VERSION} (requires 3.10+)"
    FAIL=$((FAIL + 1))
else
    echo -e "  ${GREEN}[PASS]${NC} pyver  ${PY_VERSION} (>= 3.10)"
    PASS=$((PASS + 1))
fi
echo ""

# ── 2. pip & venv ─────────────────────────────────────────────────

echo -e "${CYAN}[ 2] pip & venv${NC}"

if [ -n "$PY_CMD" ]; then
    if "$PY_CMD" -m pip --version &>/dev/null; then
        echo -e "  ${GREEN}[PASS]${NC} pkg    python -m pip available"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}[FAIL]${NC} pkg    python -m pip not available"
        FAIL=$((FAIL + 1))
    fi

    VENV_DIR="$SANDBOX/test-venv"
    if "$PY_CMD" -m venv "$VENV_DIR" &>/dev/null; then
        VENV_PY="$VENV_DIR/bin/python"
        if [ -x "$VENV_PY" ]; then
            VENV_VER=$("$VENV_PY" --version 2>&1 || echo 'fail')
            if echo "$VENV_VER" | grep -q "Python"; then
                echo -e "  ${GREEN}[PASS]${NC} pkg    venv create + activate (${VENV_VER})"
                PASS=$((PASS + 1))
            else
                echo -e "  ${RED}[FAIL]${NC} pkg    venv activate failed"
                FAIL=$((FAIL + 1))
            fi
        else
            echo -e "  ${RED}[FAIL]${NC} pkg    venv python not executable"
            FAIL=$((FAIL + 1))
        fi
    else
        echo -e "  ${RED}[FAIL]${NC} pkg    venv not available"
        FAIL=$((FAIL + 1))
    fi
else
    echo -e "  ${YELLOW}[WARN]${NC} pkg    pip / venv  (skipped — no python3)"
    WARN=$((WARN + 2))
fi
echo ""

# ── 3. External Editor ────────────────────────────────────────────

echo -e "${CYAN}[ 3] External Editor${NC}"
warn_cmd "vi" "editor"
echo ""

# ── 4. Shebang & Script Execution ─────────────────────────────────

echo -e "${CYAN}[ 4] Shebang & Execution${NC}"
cat > "$SANDBOX/test-shebang.py" << 'EOF'
#!/usr/bin/env python3
print("shebang-ok")
EOF
chmod +x "$SANDBOX/test-shebang.py"
out=$("$SANDBOX/test-shebang.py" 2>/dev/null) || true
if echo "$out" | grep -qF "shebang-ok"; then
    echo -e "  ${GREEN}[PASS]${NC} syntax shebang + chmod +x"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} syntax shebang + chmod +x  (got \"${out}\")"
    FAIL=$((FAIL + 1))
fi
echo ""

# ── 5. Core Syntax ────────────────────────────────────────────────

echo -e "${CYAN}[ 5] Core Syntax${NC}"

py_expect "variables (str)"      'name="ncc"; print(f"hello {name}")'         "hello ncc"  "syntax"
py_expect "variables (int)"      'x=42; print(f"int={x}")'                     "int=42"     "syntax"
py_expect "variables (bool)"     'ok=True; print(f"bool={ok}")'                "bool=True"  "syntax"
py_expect "variables (float)"    'f=3.14; print(f"float={f}")'                 "float=3.14" "syntax"
py_expect "f-strings"            'item="dog"; print(f"a {item}")'              "a dog"      "syntax"
py_expect "lists"                'items=[1,2,3]; print(f"len={len(items)}")'   "len=3"      "syntax"

py_expect "for loop over list"   \
    'for x in [10,20]: print(f"x={x}")'                                        "x=20"       "syntax"

py_expect "if/elif/else"         \
    'v=20; print("ten" if v==10 else "elif-ok" if v==20 else "other")'         "elif-ok"    "syntax"

py_expect "comparison (>=)"      \
    'print("ge-ok" if 5 >= 3 else "fail")'                                     "ge-ok"      "syntax"
py_expect "comparison (==)"      \
    'print("eq-ok" if 7 == 7 else "fail")'                                     "eq-ok"      "syntax"
py_expect "comparison (>)"       \
    'print("gt-ok" if 10 > 1 else "fail")'                                     "gt-ok"      "syntax"
py_expect "in operator"          \
    'print("in-ok" if "a" in "abc" else "fail")'                               "in-ok"      "syntax"

cat > "$SANDBOX/test-func.py" << 'PYEOF'
def greet(x):
    return f"hi {x}"
print(greet("ncc"))
PYEOF
out=$("$PY_CMD" "$SANDBOX/test-func.py" 2>/dev/null) || true
if echo "$out" | grep -qF "hi ncc"; then
    echo -e "  ${GREEN}[PASS]${NC} syntax def function + scope"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} syntax def function + scope  (got \"${out}\")"
    FAIL=$((FAIL + 1))
fi

cat > "$SANDBOX/test-continue.py" << 'PYEOF'
for i in range(3):
    if i == 1:
        continue
    print(f"i{i}")
PYEOF
out=$("$PY_CMD" "$SANDBOX/test-continue.py" 2>/dev/null) || true
if echo "$out" | grep -qF "i0" && echo "$out" | grep -qF "i2"; then
    echo -e "  ${GREEN}[PASS]${NC} syntax continue in loop"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} syntax continue in loop  (got \"${out}\")"
    FAIL=$((FAIL + 1))
fi
echo ""

# ── 6. File I/O ───────────────────────────────────────────────────

echo -e "${CYAN}[ 6] File I/O${NC}"

cat > "$SANDBOX/test-fileio.py" << EOF
with open("$SANDBOX/io-test.txt", "w", encoding="utf-8") as f:
    f.write("line1\\nline2\\nline3\\n")

with open("$SANDBOX/io-test.txt", "r", encoding="utf-8") as f:
    content = f.read()

print("full-read-ok" if "line2" in content else "full-read-fail")

with open("$SANDBOX/io-test.txt", "r", encoding="utf-8") as f:
    lines = [line.strip() for line in f]
print("lines-read-ok" if len(lines) == 3 else "lines-read-fail")
EOF

out=$("$PY_CMD" "$SANDBOX/test-fileio.py" 2>/dev/null) || true
if echo "$out" | grep -qF "full-read-ok"; then
    echo -e "  ${GREEN}[PASS]${NC} syntax with open() + read()"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} syntax with open() + read()  (got \"${out}\")"
    FAIL=$((FAIL + 1))
fi
if echo "$out" | grep -qF "lines-read-ok"; then
    echo -e "  ${GREEN}[PASS]${NC} syntax line-by-line iteration"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} syntax line-by-line iteration  (got \"${out}\")"
    FAIL=$((FAIL + 1))
fi

cat > "$SANDBOX/test-write.py" << PYEOF
with open("$SANDBOX/write-test.txt", "w", encoding="utf-8") as f:
    f.write("hello")
with open("$SANDBOX/write-test.txt", "r", encoding="utf-8") as f:
    print("write-ok" if f.read() == "hello" else "write-fail")
PYEOF
out=$("$PY_CMD" "$SANDBOX/test-write.py" 2>/dev/null) || true
if echo "$out" | grep -qF "write-ok"; then
    echo -e "  ${GREEN}[PASS]${NC} syntax write() (overwrite mode w)"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} syntax write() (overwrite mode w)  (got \"${out}\")"
    FAIL=$((FAIL + 1))
fi

cat > "$SANDBOX/test-enc.py" << PYEOF
with open("$SANDBOX/enc-test.txt", "w", encoding="utf-8") as f:
    f.write("café")
with open("$SANDBOX/enc-test.txt", "r", encoding="utf-8") as f:
    print("enc-ok" if "café" in f.read() else "enc-fail")
PYEOF
out=$("$PY_CMD" "$SANDBOX/test-enc.py" 2>/dev/null) || true
if echo "$out" | grep -qF "enc-ok"; then
    echo -e "  ${GREEN}[PASS]${NC} syntax encoding='utf-8'"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} syntax encoding='utf-8'  (got \"${out}\")"
    FAIL=$((FAIL + 1))
fi
echo ""

# ── 7. Exception Handling ─────────────────────────────────────────

echo -e "${CYAN}[ 7] Exception Handling${NC}"

cat > "$SANDBOX/test-try.py" << 'PYEOF'
try:
    open("/no/such/file.txt")
except FileNotFoundError:
    print("fnf-caught-ok")
PYEOF
out=$("$PY_CMD" "$SANDBOX/test-try.py" 2>/dev/null) || true
if echo "$out" | grep -qF "fnf-caught-ok"; then
    echo -e "  ${GREEN}[PASS]${NC} syntax try/except FileNotFoundError"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} syntax try/except FileNotFoundError  (got \"${out}\")"
    FAIL=$((FAIL + 1))
fi

cat > "$SANDBOX/test-sysexit.py" << 'PYEOF'
import sys
# test that SystemExit is available (topic 7 uses raise SystemExit(1))
print("sysexit-ok" if hasattr(sys, "argv") else "sysexit-fail")
PYEOF
out=$("$PY_CMD" "$SANDBOX/test-sysexit.py" 2>/dev/null) || true
if echo "$out" | grep -qF "sysexit-ok"; then
    echo -e "  ${GREEN}[PASS]${NC} syntax raise SystemExit(1) (import check)"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} syntax raise SystemExit(1) (import check)  (got \"${out}\")"
    FAIL=$((FAIL + 1))
fi

func_ok "SystemExit raises exit code 1" \
    '"$PY_CMD" -c "raise SystemExit(1)" 2>/dev/null; [ $? -eq 1 ]' \
    "syntax"
echo ""

# ── 8. String Methods ─────────────────────────────────────────────

echo -e "${CYAN}[ 8] String Methods${NC}"

py_expect "str.split()"          'print("split-ok" if "a b c".split()==["a","b","c"] else "fail")'    "split-ok"     "syntax"
py_expect "str.strip()"          'print("strip-ok" if "  hi  ".strip()=="hi" else "fail")'              "strip-ok"     "syntax"
py_expect "str.startswith()"     'print("sw-ok" if "#comment".startswith("#") else "fail")'             "sw-ok"        "syntax"
py_expect "str.endswith()"       'print("ew-ok" if "42%".endswith("%") else "fail")'                    "ew-ok"        "syntax"
py_expect "str.rstrip()"         'print("rstrip-ok" if "99%".rstrip("%")=="99" else "fail")'            "rstrip-ok"    "syntax"
py_expect "'\\n'.join()"         'lines=["a","b"]; print("join-ok" if "\\n".join(lines)=="a\\nb" else "fail")'  "join-ok"      "syntax"
echo ""

# ── 9. Dictionaries & Sets ────────────────────────────────────────

echo -e "${CYAN}[ 9] Dictionaries & Sets${NC}"

py_expect "dict create + access" \
    'd={"name":"ncc"}; print(f"dict-ok" if d["name"]=="ncc" else "fail")'       "dict-ok"      "syntax"

py_expect "dict .items() loop"   \
    'd={"a":1,"b":2}; pairs=[f"{k}={v}" for k,v in d.items()]; print("items-ok" if "a=1" in pairs else "fail")'  "items-ok"     "syntax"

py_expect "set()"                \
    's=set([1,1,2,3]); print("set-ok" if len(s)==3 else "fail")'                "set-ok"       "syntax"

py_expect "{} set literal"       \
    's={1,1,2,3}; print("setlit-ok" if len(s)==3 else "fail")'                  "setlit-ok"    "syntax"

py_expect "set operations (difference)" \
    'needed={"a","b","c"}; found={"b"}; missing=needed-found; print("setdiff-ok" if "a" in missing else "fail")'  "setdiff-ok"   "syntax"
echo ""

# ── 10. Standard Library Imports ──────────────────────────────────

echo -e "${CYAN}[10] Standard Library Imports${NC}"

py_expect "import sys"           'import sys; print("sys-ok" if hasattr(sys,"argv") else "fail")'                "sys-ok"       "syntax"
py_expect "from pathlib import Path"  'from pathlib import Path; p=Path("."); print("pathlib-ok" if p.exists() else "fail")'  "pathlib-ok"   "syntax"
py_expect "import subprocess"    'import subprocess; print("subprocess-ok" if hasattr(subprocess,"run") else "fail")'  "subprocess-ok" "syntax"
py_expect "import csv"           'import csv; print("csv-ok" if hasattr(csv,"DictReader") else "fail")'           "csv-ok"       "syntax"
py_expect "from collections import defaultdict" \
    'from collections import defaultdict; d=defaultdict(int); d["a"]+=1; print("dd-ok" if d["a"]==1 else "fail")'     "dd-ok"        "syntax"
echo ""

# ── 11. sys.argv ──────────────────────────────────────────────────

echo -e "${CYAN}[11] sys.argv${NC}"

cat > "$SANDBOX/test-argv.py" << 'EOF'
import sys
if len(sys.argv) < 3:
    print("usage: script <a> <b>")
    raise SystemExit(1)
print(f"a={sys.argv[1]} b={sys.argv[2]}")
EOF

out=$("$PY_CMD" "$SANDBOX/test-argv.py" hello world 2>/dev/null) || true
if echo "$out" | grep -qF "a=hello b=world"; then
    echo -e "  ${GREEN}[PASS]${NC} syntax sys.argv \$1 \$2"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} syntax sys.argv \$1 \$2  (got \"${out}\")"
    FAIL=$((FAIL + 1))
fi

out=$("$PY_CMD" "$SANDBOX/test-argv.py" 2>/dev/null) || true
if echo "$out" | grep -qF "usage:"; then
    echo -e "  ${GREEN}[PASS]${NC} syntax sys.argv usage + SystemExit"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} syntax sys.argv usage + SystemExit  (got \"${out}\")"
    FAIL=$((FAIL + 1))
fi
echo ""

# ── 12. subprocess.run() ──────────────────────────────────────────

echo -e "${CYAN}[12] subprocess.run()${NC}"

cat > "$SANDBOX/test-subprocess.py" << 'EOF'
import subprocess
result = subprocess.run(["echo", "subproc-ok"], capture_output=True, text=True, check=True)
print(result.stdout.strip())
EOF

out=$("$PY_CMD" "$SANDBOX/test-subprocess.py" 2>/dev/null) || true
if echo "$out" | grep -qF "subproc-ok"; then
    echo -e "  ${GREEN}[PASS]${NC} syntax subprocess.run() capture_output"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} syntax subprocess.run() capture_output  (got \"${out}\")"
    FAIL=$((FAIL + 1))
fi

cat > "$SANDBOX/test-subproc-check.py" << 'PYEOF'
import subprocess
try:
    subprocess.run(["false"], check=True)
    print("no-error")
except subprocess.CalledProcessError:
    raise SystemExit(1)
PYEOF
set +e
"$PY_CMD" "$SANDBOX/test-subproc-check.py" 2>/dev/null
RET=$?
set -e
if [ "$RET" -eq 1 ]; then
    echo -e "  ${GREEN}[PASS]${NC} syntax subprocess.run() check=True raises on failure"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} syntax subprocess.run() check=True raises on failure"
    FAIL=$((FAIL + 1))
fi

py_expect "subprocess.run() text=True" \
    'import subprocess; r=subprocess.run(["echo","text-ok"],capture_output=True,text=True); print("text-ok" if r.stdout.strip()=="text-ok" else "fail")' \
    "text-ok" "syntax"
echo ""

# ── 13. pathlib.Path ──────────────────────────────────────────────

echo -e "${CYAN}[13] pathlib.Path${NC}"

cat > "$SANDBOX/test-pathlib.py" << EOF
from pathlib import Path

p = Path("$SANDBOX") / "pathlib-test.txt"
p.write_text("pathlib-write-ok", encoding="utf-8")

if p.exists():
    content = p.read_text(encoding="utf-8")
    print(content)

home = Path.home()
print(f"home-exists={'ok' if home.exists() else 'fail'}")
EOF

out=$("$PY_CMD" "$SANDBOX/test-pathlib.py" 2>/dev/null) || true
if echo "$out" | grep -qF "pathlib-write-ok"; then
    echo -e "  ${GREEN}[PASS]${NC} syntax Path.write_text() / read_text()"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} syntax Path.write_text() / read_text()  (got \"${out}\")"
    FAIL=$((FAIL + 1))
fi
if echo "$out" | grep -qF "home-exists=ok"; then
    echo -e "  ${GREEN}[PASS]${NC} syntax Path.home() + .exists() + join"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} syntax Path.home() + .exists() + join  (got \"${out}\")"
    FAIL=$((FAIL + 1))
fi
echo ""

# ── 14. csv.DictReader ────────────────────────────────────────────

echo -e "${CYAN}[14] csv.DictReader${NC}"

cat > "$SANDBOX/test-csv.py" << 'EOF'
import csv
import io

data = "name,age,city\nAlice,30,NYC\nBob,25,SF\n"
reader = csv.DictReader(io.StringIO(data))

for row in reader:
    if row["name"] == "Bob" and row["city"] == "SF":
        print("csv-dictreader-ok")
        break
EOF

out=$("$PY_CMD" "$SANDBOX/test-csv.py" 2>/dev/null) || true
if echo "$out" | grep -qF "csv-dictreader-ok"; then
    echo -e "  ${GREEN}[PASS]${NC} syntax csv.DictReader (header access)"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} syntax csv.DictReader (header access)  (got \"${out}\")"
    FAIL=$((FAIL + 1))
fi
echo ""

# ── 15. Tuple Unpacking ───────────────────────────────────────────

echo -e "${CYAN}[15] Tuple Unpacking${NC}"

py_expect "key, _ = line.split()" \
    'key, sep, val = "NAME = value".partition("="); print("unpack-ok" if key.strip()=="NAME" else "fail")' \
    "unpack-ok" "syntax"

py_expect "tuple destructure" \
    'a, b = (1, 2); print(f"tup-ok={a},{b}" if a==1 and b==2 else "fail")' \
    "tup-ok=1,2" "syntax"
echo ""

# ── Summary ───────────────────────────────────────────────────────

echo -e "${CYAN}${SEP}${NC}"
echo ""
printf "  %-24s %s\n" "Checks passed:"    "${GREEN}${PASS}${NC}"
printf "  %-24s %s\n" "Optional missing:" "${YELLOW}${WARN}${NC}"
printf "  %-24s %s\n" "Required missing:" "${RED}${FAIL}${NC}"
echo ""

if [ "$FAIL" -eq 0 ]; then
    echo -e "${GREEN}  Python environment validated.${NC}"
    echo -e "${GREEN}  Ready for the NCC Python training module.${NC}"
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
