# Topic 05 - Use One Template for Both Servers

The app team gives you one config pattern, but the values may change later, so you make it flexible.

## Learn

- Follow the commands in order.
- Treat each task as idempotent: running it twice should not break anything.
- This sandbox uses Ansible 2.18.5.
- Use `web1` and `web2` as your targets.
- Access details: `web1` and `web2` are `root` / `Passw0rd`.

## Practice

```bash
ansible-playbook vars.yml -i inventory.ini
ansible web1 -i inventory.ini -m debug -a 'var=ansible_hostname'
```

## Validate

```bash
ansible web2 -i inventory.ini -m command -a 'cat /tmp/demo-app.conf'
```

## Checkpoint

Where would you store values that change between environments?
