# Topic 06 - Packages, Services, and Handlers

Install software, manage services, and trigger handlers only when changes happen.

## Learn

- Follow the commands in order.
- Treat each task as idempotent: running it twice should not break anything.
- Use `web1` and `web2` as your targets.

## Practice

```bash
ansible-playbook web.yml -i inventory.ini
```

## Checkpoint

Why are handlers better than restarting a service after every task?
