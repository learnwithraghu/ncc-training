# Topic 09 - Roles and Reusable Automation

Organize automation into roles so it is reusable, readable, and easy to extend.

## Learn

- Follow the commands in order.
- Treat each task as idempotent: running it twice should not break anything.
- Use `web1` and `web2` as your targets.

## Practice

```bash
ansible-galaxy init roles/webserver
ansible-playbook role-site.yml -i inventory.ini
```

## Checkpoint

What parts of your automation should become a role?
