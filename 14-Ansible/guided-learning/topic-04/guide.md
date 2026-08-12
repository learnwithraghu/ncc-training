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

`capacity.yml` does two things:

- Turns on `gather_facts: true` and prints `ansible_processor_vcpus` -
  a fact Ansible already collected, no command needed.
- Runs `df -h /` with the `command` module. No `register`, no `debug`
  task - Ansible normally hides a command's output to keep playbook runs
  short, so you ask to see it instead with `-v` (below) rather than
  wiring up a variable just to print it back out.

## Practice

```bash
ansible-playbook capacity.yml -i inventory.ini -v
```

`-v` makes Ansible print each task's result in full, including
`stdout` for the `df -h /` task - that's the whole trick, no extra
task needed.

## Validate

```bash
ansible web1 -i inventory.ini -m setup -a 'filter=ansible_processor_vcpus'
ansible web2 -i inventory.ini -m command -a 'df -h /'
```

Compare the `df -h /` numbers against what the playbook printed - they
should match.

## Checkpoint

The playbook never ran `nproc`. Where did `ansible_processor_vcpus`
actually come from, and what would you lose if you set
`gather_facts: false` instead? If a later task needed to reuse the
`df -h /` output (say, to fail the build when a disk is nearly full),
would running with `-v` still be enough, or would you need `register`
after all?
