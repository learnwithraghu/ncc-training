# Topic 03 - Check What Each Server Looks Like

Before making changes, you want to learn basic details about each machine so you do not guess.

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
ansible all -i inventory.ini -m setup -u root --ask-pass
ansible all -i inventory.ini -m ping -u root --ask-pass
```

## Validate

```bash
ansible web1 -i inventory.ini -m setup -u root --ask-pass | head
```

## Checkpoint

Which facts are most useful for deciding what a playbook should do?
