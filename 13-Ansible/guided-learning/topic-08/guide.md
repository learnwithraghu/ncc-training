# Topic 08 - Loops, Conditionals, and Tags

Scale tasks up with loops and control execution with when clauses and tags in this lab.

## Learn

- Follow the commands in order.
- Treat each task as idempotent: running it twice should not break anything.
- This sandbox uses Ansible 2.18.5.
- Use `web1` and `web2` as your targets.
- Access details: `web1` and `web2` are `root` / `Passw0rd`.

## Practice

```bash
ansible-playbook loops.yml -i inventory.ini --tags setup
```

## Validate

```bash
ansible web1 -i inventory.ini -m command -a 'rpm -q curl vim || dpkg -l curl vim'
```

## Checkpoint

When would you use a tag instead of running the whole playbook?
