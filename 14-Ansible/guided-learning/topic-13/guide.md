# Topic 13 - Install, Run, and Verify a Package in One Playbook

> **NCC-113: Prove Node.js actually works after install, not just that it's present**
>
> **Type:** Task · **Priority:** High · **Reporter:** Platform Team
>
> **Description**
> QA keeps bouncing our installs back with "the package is there, but did anyone confirm it runs?" We need a playbook that doesn't stop at `state: present`.
>
> **Acceptance Criteria**
> - Node.js is installed on `web1` and `web2`.
> - The playbook actually executes a piece of JavaScript, not just `node --version`.
> - The playbook **fails** the run (not a warning, not a log line) if the script's output is wrong.
> - Install, run, and verify all happen in a single playbook run.

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

`node-check.yml` chains three tasks, each depending on the one before it:

1. **Install** - `package: name=nodejs` puts Node.js on the host.
2. **Run** - `command: node -e "console.log(2 + 2)"` actually executes
   JavaScript and `register`s the output as `node_result`. This is the
   real reason to use `register` (unlike Topic 04, where `-v` was enough)
   - the *next* task needs to read that value, not just display it.
3. **Verify** - `ansible.builtin.assert` checks
   `node_result.stdout == "4"`. If Node didn't install correctly, or
   somehow computed the wrong answer, `assert` fails the task - and the
   whole playbook run - with the message in `fail_msg`.

Install-only playbooks tell you a package is *present*. This one tells
you it *works*.

## Practice

```bash
ansible-playbook node-check.yml -i inventory.ini
```

## Validate

```bash
ansible all -i inventory.ini -m command -a 'node --version'
```

Both hosts should report a Node.js version, and the playbook run itself
should have printed the `assert` module's `success_msg` for each host.

## Checkpoint

Change `console.log(2 + 2)` to `console.log(2 + 3)` without changing the
`that:` check, then rerun the playbook. What does `assert` do, and how
is that different from what happened when a `phpunit`/`pytest` test
failed back in the Jenkins modules?
