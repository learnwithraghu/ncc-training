# Topic 02 - Inventory and Ad-Hoc Commands

Build a simple inventory for web1 and web2 and run quick one-line commands across both hosts.

## Learn

- Follow the commands in order.
- Treat each task as idempotent: running it twice should not break anything.
- Use `web1` and `web2` as your targets.

## Practice

```bash
ansible all -i inventory.ini -m command -a 'uname -a'
ansible web1 -i inventory.ini -m command -a 'hostname'
```

## Checkpoint

Can you target one host and then both hosts with the same inventory?
