# Topic 07 - Files, Copy, and Permissions

Push config files, set ownership and mode, and verify the result on both servers.

## Learn

- Follow the commands in order.
- Treat each task as idempotent: running it twice should not break anything.
- Use `web1` and `web2` as your targets.

## Practice

```bash
ansible-playbook files.yml -i inventory.ini
```

## Checkpoint

How does Ansible help avoid inconsistent file permissions?
