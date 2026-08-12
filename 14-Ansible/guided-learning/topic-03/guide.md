# Topic 03 - Build Your Server List and Ask Quick Questions

Your team wants a fast way to talk to both web servers without logging in separately.

## Learn

- Follow the commands in order.
- Treat each task as idempotent: running it twice should not break anything.
- This sandbox uses Ansible 2.18.5.
- Use `web1` and `web2` as your targets.
- Access details: `web1` and `web2` are `root` / `Passw0rd`.

## Playbook Writing Quick Guide

1. `---` starts the YAML document.
2. `- name:` gives the play a readable title.
3. `hosts:` chooses the target group or host.
4. `become: true` runs tasks with elevated privileges.
5. `gather_facts:` controls whether Ansible collects host facts first.
6. `tasks:` holds the ordered list of actions.
7. Each task uses a module such as `ping`, `copy`, or `command`.
8. Module arguments define what the task should do.
9. `register:` saves output for later tasks.
10. `when:` and `tags:` help control when tasks run.

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
