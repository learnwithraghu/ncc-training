# Topic 12 - Install Different Things on Different Hosts, One Playbook

Your app team needs pandas on `web1` (a data-processing box) and nginx on `web2` (a web-facing box) - two completely different installs, but you want to hand over one file, not two.

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

Every playbook so far in this module has had **one** play (one
`hosts:` line) targeting the whole `web` group. `multi-play.yml` has
**two** plays in the same file:

- The first play sets `hosts: web1` and installs `pandas` there (via
  `pip`, after making sure `pip` itself is present).
- The second play sets `hosts: web2` and installs `nginx` there.

Each play only touches the host it names - `web2` never sees the
pandas tasks, and `web1` never sees the nginx task. Ansible runs the
plays top to bottom, one after another, but still from a single
`ansible-playbook` command against a single file.

## Practice

```bash
ansible-playbook multi-play.yml -i inventory.ini
```

## Validate

```bash
ansible web1 -i inventory.ini -m command -a 'pip3 show pandas'
ansible web2 -i inventory.ini -m command -a 'rpm -q nginx || dpkg -l nginx'
```

`web1` should show the pandas package; `web2` should show nginx.
Neither host should have the other one's software.

## Checkpoint

Instead of two plays, you could have used one play with `hosts: web`
and put `when: inventory_hostname == 'web1'` on the pandas tasks (and
`== 'web2'` on the nginx task). What would that version do differently
if you added a `web3` host tomorrow, compared to this topic's two-play
version?
