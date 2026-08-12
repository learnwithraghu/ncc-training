# Topic 14 - Prove External Reachability from Every Web Host

> **NCC-114: Confirm web1 and web2 can actually reach the internet**
>
> **Type:** Task · **Priority:** High · **Reporter:** Network Team
>
> **Description**
> Deploys keep failing partway through because a host can't reach an
> external package mirror, and nobody notices until the job dies deep
> in a task. We want a playbook that checks outbound connectivity up
> front, against a known-good address, and fails loudly if it's broken.
>
> **Acceptance Criteria**
> - The playbook runs against both `web1` and `web2`.
> - It sends a real HTTP request to `https://www.google.com`, not just a
>   ping.
> - The playbook **fails** (not a warning) on any host that doesn't get
>   back a 200.
> - The failure message names the host that couldn't reach the internet.

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

`google-check.yml` chains two tasks, same shape as Topic 13's
install-run-verify chain, but for reachability instead of a package:

1. **Request** - `ansible.builtin.uri` sends a real HTTP GET to
   `https://www.google.com` from the target host itself (not from the
   controller). The result is `register`ed as `google_check`.
   `ignore_errors: true` keeps a failed request from stopping the play
   immediately - we want *both* hosts to get checked even if one is
   offline, and we want our own `assert` message, not Ansible's
   default connection-error output.
2. **Verify** - `ansible.builtin.assert` checks that `google_check`
   actually has a `status` and that it equals `200`. If the request
   never completed, or came back with anything other than 200,
   `assert` fails the task - and the whole playbook run - with the
   `fail_msg`, naming the exact host.

This is a `ping`-module check's cousin: `ping` (Topic 02) only proves
Ansible can reach the host over SSH. This proves the host itself can
reach something out on the internet.

## Practice

```bash
ansible-playbook google-check.yml -i inventory.ini
```

## Validate

```bash
ansible all -i inventory.ini -m uri -a 'url=https://www.google.com status_code=200'
```

Both hosts should report success, and the playbook run itself should
have printed the `assert` module's `success_msg` for each host.

## Checkpoint

If `web2` had no outbound internet access at all, what would
`google_check.status` look like on that host, and why does the
`google_check.status is defined` check in the `assert` matter as much
as the `== 200` check?
