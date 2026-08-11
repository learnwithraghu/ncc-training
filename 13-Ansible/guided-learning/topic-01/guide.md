# Topic 01 - What Ansible Is and Why It Matters

Learn the control-node model, idempotence, and why Ansible is great for repeatable infrastructure changes.

## Learn

- Follow the commands in order.
- Treat each task as idempotent: running it twice should not break anything.
- Use `web1` and `web2` as your targets.

## Practice

```bash
ansible --version
ansible all -i inventory.ini -m ping
```

## Checkpoint

What problems does Ansible solve better than manual SSH?
