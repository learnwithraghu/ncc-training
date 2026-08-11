# Topic 06 - Install the Web Server and Keep It Running

Your web app needs nginx on both servers, but you only want a restart when something actually changes.

## Learn

- Follow the commands in order.
- Treat each task as idempotent: running it twice should not break anything.
- This sandbox uses Ansible 2.18.5.
- Use `web1` and `web2` as your targets.
- Access details: `web1` and `web2` are `root` / `Passw0rd`.

## Practice

```bash
ansible-playbook web.yml -i inventory.ini
```

## Validate

```bash
ansible web1 -i inventory.ini -m command -a 'systemctl is-active nginx'
```

## Checkpoint

Why are handlers better than restarting a service after every task?
