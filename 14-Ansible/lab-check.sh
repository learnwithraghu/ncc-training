#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

INVENTORY="inventory.ini"

if [[ ! -f "$INVENTORY" ]]; then
  cat > "$INVENTORY" <<'EOF'
[web]
web1 ansible_host=web1 ansible_user=root ansible_password=Passw0rd
web2 ansible_host=web2 ansible_user=root ansible_password=Passw0rd
EOF
fi

echo "==> Checking Ansible"
ansible --version | head -n 1

echo "==> Checking inventory"
ansible-inventory -i "$INVENTORY" --list >/dev/null

echo "==> Testing SSH reachability"
ansible all -i "$INVENTORY" -m ping

echo "==> Checking Topic 03 (ad-hoc command, no playbook)"
ansible all -i "$INVENTORY" -m command -a 'uname -a'

echo "==> Running topic playbooks"
for playbook in \
  guided-learning/topic-02/ping.yml \
  guided-learning/topic-04/capacity.yml \
  guided-learning/topic-05/site.yml \
  guided-learning/topic-06/vars.yml \
  guided-learning/topic-07/web.yml \
  guided-learning/topic-08/files.yml \
  guided-learning/topic-09/loops.yml \
  guided-learning/topic-10/role-site.yml \
  guided-learning/topic-11/deploy.yml \
  guided-learning/topic-12/multi-play.yml \
  guided-learning/topic-13/node-check.yml \
  guided-learning/topic-14/google-check.yml \
  guided-learning/topic-16/jenkins-master-slave.yml
  do
    echo "--> $playbook"
    ansible-playbook -i "$INVENTORY" "$playbook"
done

echo "==> Running challenge playbooks"
for playbook in \
  guided-learning/challenge-01/challenge.yml \
  guided-learning/challenge-02/challenge.yml \
  guided-learning/challenge-03/challenge.yml \
  guided-learning/challenge-04/challenge.yml \
  guided-learning/challenge-05/challenge.yml
  do
    echo "--> $playbook"
    ansible-playbook -i "$INVENTORY" "$playbook"
done

echo "==> Lab check complete"
