# Topic 08 - Loops, Conditionals, and Tags

Scale tasks up with loops and control execution with when clauses and tags.

## Learn

- Follow the commands in order.
- Treat each task as idempotent: running it twice should not break anything.
- Use `web1` and `web2` as your targets.

## Practice

```bash
ansible-playbook loops.yml -i inventory.ini --tags setup
```

## Checkpoint

When would you use a tag instead of running the whole playbook?
