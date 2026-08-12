# Topic 01 - Build the Inventory

Before you can automate anything, Ansible needs to know which servers exist and how to reach them. That list lives in an **inventory** file - every topic after this one assumes `inventory.ini` already exists.

## Learn

- An inventory file lists the hosts (and groups of hosts) Ansible can target.
- The default format is INI: `[group_name]` followed by one host per line.
- Each host line can carry connection variables (`ansible_host`, `ansible_user`, `ansible_password`) so Ansible knows how to log in without you typing `-u`/`--ask-pass` on every command.
- This sandbox uses Ansible 2.18.5.
- Use `web1` and `web2` as your targets.
- Access details: `web1` and `web2` are `root` / `Passw0rd`.

## Inventory Format

```ini
[web]
web1 ansible_host=web1 ansible_user=root ansible_password=Passw0rd
web2 ansible_host=web2 ansible_user=root ansible_password=Passw0rd
```

- `[web]` is a group name - every topic in this module targets `hosts: web`.
- `web1` / `web2` are the inventory hostnames (they also happen to match the real hostnames here).
- `ansible_host` is the address Ansible actually connects to; it can differ from the inventory hostname when it doesn't here.
- `ansible_user` / `ansible_password` avoid typing `-u root --ask-pass` on every single command.

## Practice

```bash
ansible --version

cat > inventory.ini <<'EOF'
[web]
web1 ansible_host=web1 ansible_user=root ansible_password=Passw0rd
web2 ansible_host=web2 ansible_user=root ansible_password=Passw0rd
EOF

# see what Ansible thinks the inventory contains
ansible-inventory -i inventory.ini --list
ansible all -i inventory.ini --list-hosts
```

## Validate

```bash
ansible web1 -i inventory.ini -m ping
ansible web2 -i inventory.ini -m ping
```

## Checkpoint

If you added a third server, `web3`, what's the minimum change you'd need to make to `inventory.ini` for every existing playbook in this module to pick it up automatically?
