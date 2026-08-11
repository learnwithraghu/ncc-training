# Topic 01 - What Ansible Is and Why It Matters

Learn the control-node model, idempotence, and why Ansible is great for repeatable infrastructure changes in this lab.

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
