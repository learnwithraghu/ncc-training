# Topic 10 - Multi-Host App Deployment

Deploy a simple app flow across web1 and web2 to show inventory, variables, roles, and orchestration together in this lab.

## Learn

- Follow the commands in order.
- Treat each task as idempotent: running it twice should not break anything.
- This sandbox uses Ansible 2.18.5.
- Use `web1` and `web2` as your targets.
- Access details: `web1` and `web2` are `root` / `Passw0rd`.

## Practice

```bash
ansible-playbook deploy.yml -i inventory.ini
```

## Validate

```bash
ansible web2 -i inventory.ini -m command -a 'test -d /opt/demo-app && echo deployed'
```

## Checkpoint

What did Ansible simplify compared to managing each server by hand?
