# Topic 04 - Playbooks and YAML Basics

Write your first playbook with tasks, plays, and clear structure.

## Learn

- Follow the commands in order.
- Treat each task as idempotent: running it twice should not break anything.
- Use `web1` and `web2` as your targets.

## Practice

```bash
ansible-playbook site.yml -i inventory.ini
```

## Checkpoint

What makes a playbook easier to maintain than a shell script?
