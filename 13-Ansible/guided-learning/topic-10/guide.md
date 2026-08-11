# Topic 10 - Multi-Host App Deployment

Deploy a simple app flow across web1 and web2 to show inventory, variables, roles, and orchestration together.

## Learn

- Follow the commands in order.
- Treat each task as idempotent: running it twice should not break anything.
- Use `web1` and `web2` as your targets.

## Practice

```bash
ansible-playbook deploy.yml -i inventory.ini
```

## Checkpoint

What did Ansible simplify compared to managing each server by hand?
