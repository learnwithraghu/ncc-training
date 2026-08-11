# Topic 09 - Pack the Web Server Steps into a Role

The setup is getting repeated, so you bundle it into a reusable role instead of copying tasks around.

## Learn

- Follow the commands in order.
- Treat each task as idempotent: running it twice should not break anything.
- This sandbox uses Ansible 2.18.5.
- Use `web1` and `web2` as your targets.
- Access details: `web1` and `web2` are `root` / `Passw0rd`.

## Practice

```bash
ansible-galaxy init roles/webserver
ansible-playbook role-site.yml -i inventory.ini
```

## Validate

```bash
ansible web1 -i inventory.ini -m command -a 'test -d /etc/ansible || echo role-ran'
```

## Checkpoint

What parts of your automation should become a role?
