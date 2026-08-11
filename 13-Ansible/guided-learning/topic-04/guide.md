# Topic 04 - Write Your First Playbook

You have a small repeat job and want it written down so the same steps can run every time.

## Learn

- Follow the commands in order.
- Treat each task as idempotent: running it twice should not break anything.
- This sandbox uses Ansible 2.18.5.
- Use `web1` and `web2` as your targets.
- Access details: `web1` and `web2` are `root` / `Passw0rd`.

## Practice

```bash
ansible-playbook site.yml -i inventory.ini
```

## Validate

```bash
ansible web1 -i inventory.ini -m command -a 'test -f /tmp/ansible-demo.txt && echo present'
```

## Checkpoint

What makes a playbook easier to maintain than a shell script?
