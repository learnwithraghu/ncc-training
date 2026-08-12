# Topic 07 - Install the Web Server and Keep It Running

Your web app needs nginx on both servers, but you only want a restart when something actually changes.

## Learn

- Follow the commands in order.
- Treat each task as idempotent: running it twice should not break anything.
- This sandbox uses Ansible 2.18.5.
- Use `web1` and `web2` as your targets.
- Access details: `web1` and `web2` are `root` / `Passw0rd`.

## Playbook Writing Quick Guide

1. `---` starts the YAML document.
2. `- name:` gives the play a readable title.
3. `hosts:` chooses the target group or host.
4. `become: true` runs tasks with elevated privileges.
5. `gather_facts:` controls whether Ansible collects host facts first.
6. `tasks:` holds the ordered list of actions.
7. Each task uses a module such as `ping`, `copy`, or `command`.
8. Module arguments define what the task should do.
9. `register:` saves output for later tasks.
10. `when:` and `tags:` help control when tasks run.

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
