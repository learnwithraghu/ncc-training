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

echo "==> Running topic playbooks"
for playbook in \
  guided-learning/topic-01/ping.yml \
  guided-learning/topic-02/command.yml \
  guided-learning/topic-03/facts.yml \
  guided-learning/topic-04/site.yml \
  guided-learning/topic-05/vars.yml \
  guided-learning/topic-06/web.yml \
  guided-learning/topic-07/files.yml \
  guided-learning/topic-08/loops.yml \
  guided-learning/topic-09/role-site.yml \
  guided-learning/topic-10/deploy.yml
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
