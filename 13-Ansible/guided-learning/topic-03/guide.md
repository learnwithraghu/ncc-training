# Topic 03 - SSH Connectivity and Facts

Verify remote access and gather host facts to understand the managed machines.

## Learn

- Follow the commands in order.
- Treat each task as idempotent: running it twice should not break anything.
- Use `web1` and `web2` as your targets.

## Practice

```bash
ansible all -i inventory.ini -m setup
ansible all -i inventory.ini -m ping
```

## Checkpoint

Which facts are most useful for deciding what a playbook should do?
