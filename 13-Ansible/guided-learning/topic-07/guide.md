# Topic 07 - Put the Same File in the Right Place

You need the same small config file on both servers and want the permissions to be correct every time.

## Learn

- Follow the commands in order.
- Treat each task as idempotent: running it twice should not break anything.
- This sandbox uses Ansible 2.18.5.
- Use `web1` and `web2` as your targets.
- Access details: `web1` and `web2` are `root` / `Passw0rd`.

## Practice

```bash
ansible-playbook files.yml -i inventory.ini
```

## Validate

```bash
ansible web2 -i inventory.ini -m command -a 'ls -l /tmp/lab-config.txt'
```

## Checkpoint

How does Ansible help avoid inconsistent file permissions?
