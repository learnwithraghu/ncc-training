# Topic 08 - Do the Same Setup for a Small Group of Packages

You have a few common tools to install and want one task to handle them cleanly.

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
ansible-playbook loops.yml -i inventory.ini --tags setup
```

## Validate

```bash
ansible web1 -i inventory.ini -m command -a 'rpm -q curl vim || dpkg -l curl vim'
```

## Checkpoint

When would you use a tag instead of running the whole playbook?
