# Topic 01 - Meet the Lab and Check the Servers

You are the engineer on call and need to confirm both web servers are reachable before you touch anything.

## Learn

- Follow the commands in order.
- Treat each task as idempotent: running it twice should not break anything.
- This sandbox uses Ansible 2.18.5.
- Use `web1` and `web2` as your targets.
- Access details: `web1` and `web2` are `root` / `Passw0rd`.

## Practice

```bash
ansible --version
cat > inventory.ini <<'EOF'
[web]
web1 ansible_host=web1 ansible_user=root ansible_password=Passw0rd
web2 ansible_host=web2 ansible_user=root ansible_password=Passw0rd
EOF
ansible all -i inventory.ini -m ping
```

## Validate

```bash
ansible web1 -i inventory.ini -m command -a 'hostname'
```

## Checkpoint

What problems does Ansible solve better than manual SSH?
