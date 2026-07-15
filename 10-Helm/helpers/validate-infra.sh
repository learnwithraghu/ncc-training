#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_NAME="NCC Helm Training - Infrastructure Validator"
readonly SEP="============================================================"
readonly SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
readonly MODULE_DIR="${SCRIPT_DIR}/.."
readonly WORKSPACE="/tmp/ncc-helm-validation-$$"
readonly REPO_NAME="ncc-helm-val-bitnami"
readonly RELEASE_PREFIX="ncc-helm-val-$$"

PASS=0
WARN=0
FAIL=0

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

RELEASES=()

register_release() {
    RELEASES+=("$1")
}

cleanup() {
    echo ""
    echo -e "${CYAN}[cleanup]${NC} Removing Helm releases and workspace..."

    for rel in "${RELEASES[@]}"; do
        helm uninstall "$rel" 2>/dev/null || true
    done

    helm repo remove "$REPO_NAME" 2>/dev/null || true

    rm -rf "$WORKSPACE"
}
trap cleanup EXIT

rm -rf "$WORKSPACE"
mkdir -p "$WORKSPACE"

echo -e "${CYAN}${SEP}${NC}"
echo -e "${CYAN}  ${SCRIPT_NAME}${NC}"
echo -e "${CYAN}${SEP}${NC}"
echo ""

# ── Environment info ──────────────────────────────────────────────────

echo -e "${CYAN}[info]${NC} Environment"
echo "  User      : $(whoami 2>/dev/null || echo 'unknown')"
echo "  Hostname  : $(hostname 2>/dev/null || echo 'unknown')"
echo "  Kernel    : $(uname -srm 2>/dev/null || echo 'unknown')"
echo "  Workspace : ${WORKSPACE}"
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
        echo -e "  ${YELLOW}[WARN]${NC} ${tag} ${cmd}  (not found — optional)"
        WARN=$((WARN + 1))
    fi
}

helm_ok() {
    local desc="$1" cmd="$2" tag="${3:-helm}"
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

helm_expect() {
    local desc="$1" cmd="$2" expected="$3" tag="${4:-helm}"
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

helm_warn() {
    local desc="$1" cmd="$2" expected="$3" tag="${4:-helm}"
    local out
    out=$(eval "$cmd" 2>&1) && true
    local rc=$?
    if [ "$rc" -eq 0 ] && echo "$out" | grep -qF "$expected"; then
        echo -e "  ${GREEN}[PASS]${NC} ${tag} ${desc}"
        PASS=$((PASS + 1)); return 0
    else
        echo -e "  ${YELLOW}[WARN]${NC} ${tag} ${desc}  (expected \"${expected}\", rc=${rc}, got \"${out}\")"
        WARN=$((WARN + 1)); return 1
    fi
}

wait_for_release_pods() {
    local release="$1" timeout_sec="${2:-90}"
    local i ready
    for i in $(seq 1 "$timeout_sec"); do
        ready=$(kubectl get pods --selector="app.kubernetes.io/instance=${release}" --no-headers 2>/dev/null | grep -c "Running" || echo 0)
        if [ "$ready" -gt 0 ]; then
            return 0
        fi
        sleep 1
    done
    return 1
}

# ── 1. Helm & kubectl environment ─────────────────────────────────────

echo -e "${CYAN}[ 1] Helm & kubectl Environment (Topic 01)${NC}"

check_cmd "helm" "tool"
HELM_VER=$(helm version --short 2>/dev/null || echo 'unknown')
echo "  Helm      : ${HELM_VER}"

check_cmd "kubectl" "tool"
KUBECTL_VER=$(kubectl version --client 2>/dev/null || echo 'unknown')
echo "  kubectl   : ${KUBECTL_VER}"

helm_ok "helm env returns Helm environment" \
    "helm env 2>&1 | grep -q 'HELM_BIN' && echo ok" "tool"

if kubectl cluster-info >/dev/null 2>&1; then
    echo -e "  ${GREEN}[PASS]${NC} cluster kubectl cluster-info reachable"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}[FAIL]${NC} cluster kubectl cluster-info unreachable"
    echo "            No reachable Kubernetes cluster. Start one of: minikube, kind, k3d, Docker Desktop"
    FAIL=$((FAIL + 1))
    echo ""
    echo -e "${RED}  Validation aborted — no Kubernetes cluster available.${NC}"
    exit 1
fi

echo ""

# ── 2. Chart & repository discovery ─────────────────────────────────────

echo -e "${CYAN}[ 2] Chart & Repository Discovery (Topic 02)${NC}"

helm_warn "helm search hub returns results (optional - requires internet)" \
    "timeout 60 helm search hub nginx 2>&1 | head -3 | grep -q 'nginx' && echo ok" \
    "ok" "repo"

helm_ok "helm repo add bitnami" \
    "helm repo add ${REPO_NAME} https://charts.bitnami.com/bitnami 2>&1 | grep -qE 'added|has been added' && echo ok" "repo"

helm_ok "helm repo update" \
    "helm repo update ${REPO_NAME} 2>&1 | grep -q 'Successfully' && echo ok" "repo"

helm_ok "helm search repo bitnami/nginx" \
    "helm search repo ${REPO_NAME}/nginx 2>&1 | grep -q 'nginx' && echo ok" "repo"

helm_ok "helm show chart bitnami/nginx" \
    "helm show chart ${REPO_NAME}/nginx 2>&1 | grep -q 'apiVersion' && echo ok" "repo"

echo ""

# ── 3. Release lifecycle basics ────────────────────────────────────────

echo -e "${CYAN}[ 3] Release Lifecycle Basics (Topic 03)${NC}"

TOPIC3_RELEASE="${RELEASE_PREFIX}-topic3"
helm_ok "helm install topic3-nginx" \
    "helm install ${TOPIC3_RELEASE} ${REPO_NAME}/nginx --wait --timeout 120s -n default 2>&1 | grep -qE 'STATUS|deployed' && echo ok" "release"

register_release "$TOPIC3_RELEASE"

helm_ok "helm list shows release" \
    "helm list 2>&1 | grep -q '${TOPIC3_RELEASE}' && echo ok" "release"

helm_ok "kubectl get pods shows release pods" \
    "kubectl get pods --selector=app.kubernetes.io/instance=${TOPIC3_RELEASE} --no-headers 2>&1 | grep -q 'Running' && echo ok" "release"

helm_ok "kubectl get svc shows release service" \
    "kubectl get svc --selector=app.kubernetes.io/instance=${TOPIC3_RELEASE} --no-headers 2>&1 | grep -q . && echo ok" "release"

helm_ok "helm status topic3-nginx" \
    "helm status ${TOPIC3_RELEASE} 2>&1 | grep -qE 'STATUS|deployed' && echo ok" "release"

helm_ok "helm uninstall topic3-nginx" \
    "helm uninstall ${TOPIC3_RELEASE} 2>&1 | grep -qE 'uninstalled|release' && echo ok" "release"

echo ""

# ── 4. Create your first chart ───────────────────────────────────────

echo -e "${CYAN}[ 4] Create Your First Chart (Topic 04)${NC}"

mkdir -p "${WORKSPACE}/topic-04"
cd "${WORKSPACE}/topic-04"

helm_ok "helm create hello-helm" \
    "helm create hello-helm 2>&1 | grep -q 'Creating hello-helm' && echo ok" "chart"

helm_ok "Chart.yaml exists" \
    "test -f hello-helm/Chart.yaml && echo ok" "chart"

helm_ok "values.yaml exists" \
    "test -f hello-helm/values.yaml && echo ok" "chart"

helm_ok "templates directory exists" \
    "test -d hello-helm/templates && echo ok" "chart"

echo ""

# ── 5. Values & template fundamentals ──────────────────────────────────

echo -e "${CYAN}[ 5] Values & Template Fundamentals (Topic 05)${NC}"

mkdir -p "${WORKSPACE}/topic-05"
cd "${WORKSPACE}/topic-05"

helm_ok "helm create values-lab" \
    "helm create values-lab 2>&1 | grep -q 'Creating values-lab' && echo ok" "template"

helm_ok "helm template values-lab renders manifests" \
    "helm template values-lab ./values-lab 2>&1 | grep -q 'apiVersion' && echo ok" "template"

helm_ok "helm template with --set overrides" \
    "helm template values-lab ./values-lab --set replicaCount=3 --set service.type=NodePort 2>&1 | grep -qE 'replicas: 3|NodePort' && echo ok" "template"

echo ""

# ── 6. Service & deployment templating ─────────────────────────────────

echo -e "${CYAN}[ 6] Service & Deployment Templating (Topic 06)${NC}"

mkdir -p "${WORKSPACE}/topic-06"
cd "${WORKSPACE}/topic-06"

helm_ok "helm create app-lab" \
    "helm create app-lab 2>&1 | grep -q 'Creating app-lab' && echo ok" "template"

helm_ok "deployment.yaml template exists" \
    "test -f app-lab/templates/deployment.yaml && echo ok" "template"

helm_ok "service.yaml template exists" \
    "test -f app-lab/templates/service.yaml && echo ok" "template"

helm_ok "helm template with image and service overrides" \
    "helm template app-lab ./app-lab --set image.repository=nginx --set image.tag=1.25 --set service.port=8080 2>&1 | grep -qE 'nginx:1.25|8080' && echo ok" "template"

echo ""

# ── 7. Lint, template, and dry-run validation ──────────────────────────

echo -e "${CYAN}[ 7] Lint, Template, and Dry-Run Validation (Topic 07)${NC}"

mkdir -p "${WORKSPACE}/topic-07"
cd "${WORKSPACE}/topic-07"

helm_ok "helm create validate-lab" \
    "helm create validate-lab 2>&1 | grep -q 'Creating validate-lab' && echo ok" "lint"

helm_ok "helm lint passes" \
    "helm lint ./validate-lab 2>&1 | grep -qE '1 chart(s) linted|No failures' && echo ok" "lint"

helm_ok "helm template with values-dev.yaml" \
    "helm template validate-lab ./validate-lab -f ${MODULE_DIR}/guided-learning/topic-07/assets/values-dev.yaml 2>&1 | grep -q 'apiVersion' && echo ok" "lint"

helm_ok "helm install --dry-run --debug" \
    "helm install validate-lab ./validate-lab --dry-run --debug -f ${MODULE_DIR}/guided-learning/topic-07/assets/values-dev.yaml 2>&1 | grep -qE 'dry-run|NAME' && echo ok" "lint"

echo ""

# ── 8. Upgrade, rollback, and value overrides ────────────────────────

echo -e "${CYAN}[ 8] Upgrade, Rollback, and Value Overrides (Topic 08)${NC}"

mkdir -p "${WORKSPACE}/topic-08"
cd "${WORKSPACE}/topic-08"

TOPIC8_RELEASE="${RELEASE_PREFIX}-topic8"

helm_ok "helm create lifecycle-lab" \
    "helm create lifecycle-lab 2>&1 | grep -q 'Creating lifecycle-lab' && echo ok" "upgrade"

helm_ok "helm install with values-dev.yaml" \
    "helm install ${TOPIC8_RELEASE} ./lifecycle-lab -f ${MODULE_DIR}/guided-learning/topic-08/assets/values-dev.yaml --wait --timeout 120s 2>&1 | grep -qE 'STATUS|deployed' && echo ok" "upgrade"

register_release "$TOPIC8_RELEASE"
wait_for_release_pods "$TOPIC8_RELEASE" 60

helm_ok "helm upgrade with values-prod.yaml" \
    "helm upgrade ${TOPIC8_RELEASE} ./lifecycle-lab -f ${MODULE_DIR}/guided-learning/topic-08/assets/values-prod.yaml --wait --timeout 120s 2>&1 | grep -qE 'STATUS|deployed' && echo ok" "upgrade"

helm_ok "helm history shows revisions" \
    "helm history ${TOPIC8_RELEASE} 2>&1 | grep -qE 'REVISION|1' && echo ok" "upgrade"

helm_ok "helm rollback to revision 1" \
    "helm rollback ${TOPIC8_RELEASE} 1 --wait --timeout 120s 2>&1 | grep -qE 'Rollback was|Happy' && echo ok" "upgrade"

helm_ok "helm uninstall lifecycle-lab" \
    "helm uninstall ${TOPIC8_RELEASE} 2>&1 | grep -qE 'uninstalled|release' && echo ok" "upgrade"

echo ""

# ── 9. Package and reuse a chart ──────────────────────────────────────

echo -e "${CYAN}[ 9] Package and Reuse a Chart (Topic 09)${NC}"

mkdir -p "${WORKSPACE}/topic-09"
cd "${WORKSPACE}/topic-09"

TOPIC9_RELEASE="${RELEASE_PREFIX}-topic9"

helm_ok "helm create package-lab" \
    "helm create package-lab 2>&1 | grep -q 'Creating package-lab' && echo ok" "package"

helm_ok "helm package creates .tgz" \
    "helm package package-lab 2>&1 | grep -qE 'Successfully packaged|\.tgz' && echo ok" "package"

helm_ok "helm install from packaged .tgz" \
    "helm install ${TOPIC9_RELEASE} ./package-lab-0.1.0.tgz -f ${MODULE_DIR}/guided-learning/topic-09/assets/package-values.yaml --wait --timeout 120s 2>&1 | grep -qE 'STATUS|deployed' && echo ok" "package"

register_release "$TOPIC9_RELEASE"
wait_for_release_pods "$TOPIC9_RELEASE" 60

helm_ok "helm list shows package-lab" \
    "helm list 2>&1 | grep -q '${TOPIC9_RELEASE}' && echo ok" "package"

helm_ok "helm uninstall package-lab" \
    "helm uninstall ${TOPIC9_RELEASE} 2>&1 | grep -qE 'uninstalled|release' && echo ok" "package"

echo ""

# ── 10. Capstone Helm mini workflow ───────────────────────────────────

echo -e "${CYAN}[10] Capstone Helm Mini Workflow (Topic 10)${NC}"

mkdir -p "${WORKSPACE}/topic-10"
cd "${WORKSPACE}/topic-10"

helm_ok "helm create document-search" \
    "helm create document-search 2>&1 | grep -q 'Creating document-search' && echo ok" "capstone"

cp "${MODULE_DIR}/guided-learning/topic-10/assets/document-search-values.yaml" document-search/values.yaml

helm_ok "helm lint document-search" \
    "helm lint ./document-search 2>&1 | grep -qE '1 chart(s) linted|No failures' && echo ok" "capstone"

helm_ok "helm template document-search" \
    "helm template doc-search ./document-search 2>&1 | grep -q 'apiVersion' && echo ok" "capstone"

helm_ok "helm install --dry-run --debug document-search" \
    "helm install doc-search ./document-search --dry-run --debug 2>&1 | grep -qE 'dry-run|NAME' && echo ok" "capstone"

echo ""

# ── Final cleanup verification ────────────────────────────────────────

echo -e "${CYAN}[cleanup] Final Cleanup Verification${NC}"

cleanup

sleep 2

REMAINING=$(helm list --short 2>/dev/null | grep "^${RELEASE_PREFIX}" | wc -l | tr -d ' ')
if [ "$REMAINING" -eq 0 ]; then
    echo -e "  ${GREEN}[PASS]${NC} cleanup all validator releases removed"
    PASS=$((PASS + 1))
else
    echo -e "  ${YELLOW}[WARN]${NC} cleanup ${REMAINING} validator release(s) may still be present"
    WARN=$((WARN + 1))
fi

if helm repo list 2>/dev/null | grep -q "^${REPO_NAME}"; then
    echo -e "  ${YELLOW}[WARN]${NC} cleanup temporary repo ${REPO_NAME} still present"
    WARN=$((WARN + 1))
else
    echo -e "  ${GREEN}[PASS]${NC} cleanup temporary repo ${REPO_NAME} removed"
    PASS=$((PASS + 1))
fi

if [ -d "$WORKSPACE" ]; then
    echo -e "  ${YELLOW}[WARN]${NC} cleanup workspace ${WORKSPACE} still exists"
    WARN=$((WARN + 1))
else
    echo -e "  ${GREEN}[PASS]${NC} cleanup workspace removed"
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
    echo -e "${GREEN}  Helm environment validated.${NC}"
    echo -e "${GREEN}  Ready for the NCC Helm training module.${NC}"
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
