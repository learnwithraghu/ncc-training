# Topic 04 - Check CPU and Disk Space on Each Server

Before deploying anything else, you want to know how much CPU and disk space each server actually has, instead of guessing.

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

## The Playbook

`facts.yml` turns on `gather_facts: true`, then reads two facts Ansible
already collected instead of running any shell command:

- `ansible_processor_vcpus` - how many vCPUs the host has.
- `ansible_mounts` - a list of every mounted filesystem, each with
  `mount`, `size_total`, and `size_available` (in bytes). The playbook
  loops over it and formats the sizes with the `filesizeformat` filter so
  the output reads in GB instead of raw bytes.

## Practice

```bash
ansible-playbook facts.yml -i inventory.ini
```

## Validate

```bash
ansible web1 -i inventory.ini -m setup -a 'filter=ansible_processor_vcpus'
ansible web2 -i inventory.ini -m command -a 'df -h /'
```

Compare the `df -h /` numbers against what the playbook printed for the
`/` mount - they should match.

## Checkpoint

The playbook never ran `nproc` or `df` itself. Where did
`ansible_processor_vcpus` and `ansible_mounts` actually come from, and
what would you lose if you set `gather_facts: false` instead?
