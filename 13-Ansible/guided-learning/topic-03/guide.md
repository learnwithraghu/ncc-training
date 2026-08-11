# Topic 03 - SSH Connectivity and Facts

Verify remote access and gather host facts to understand the managed machines in this lab.

## Learn

- Follow the commands in order.
- Treat each task as idempotent: running it twice should not break anything.
- This sandbox uses Ansible 2.18.5.
- Use `web1` and `web2` as your targets.
- Access details: `web1` and `web2` are `root` / `Passw0rd`.

## Practice

```bash
ansible all -i inventory.ini -m setup -u root --ask-pass
ansible all -i inventory.ini -m ping -u root --ask-pass
```

## Validate

```bash
ansible web1 -i inventory.ini -m setup -u root --ask-pass | head
```

## Checkpoint

Which facts are most useful for deciding what a playbook should do?
