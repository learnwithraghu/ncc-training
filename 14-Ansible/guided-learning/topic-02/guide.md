# Topic 02 - Build Your Server List and Ask Quick Questions

Your team wants a fast way to talk to both web servers without logging in separately.

## Learn

- Follow the commands in order.
- Treat each task as idempotent: running it twice should not break anything.
- This sandbox uses Ansible 2.18.5.
- Use `web1` and `web2` as your targets.
- Access details: `web1` and `web2` are `root` / `Passw0rd`.

## Practice

```bash
cat > inventory.ini <<'EOF'
[web]
web1 ansible_host=web1 ansible_user=root ansible_password=Passw0rd
web2 ansible_host=web2 ansible_user=root ansible_password=Passw0rd
EOF
ansible all -i inventory.ini -m command -a 'uname -a'
ansible web1 -i inventory.ini -m command -a 'hostname'
```

## Validate

```bash
ansible web2 -i inventory.ini -m command -a 'uptime'
```

## Checkpoint

Can you target one host and then both hosts with the same inventory?
