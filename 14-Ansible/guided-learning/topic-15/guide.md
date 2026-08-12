# Topic 15 - Audit Server Health and Create Locked Users

> **NCC-115: Do a basic admin check on web1 and web2, then create two local accounts**
>
> **Type:** Task · **Priority:** Medium · **Reporter:** Operations Team
>
> **Description**
> Before we hand a server to another team, we want a quick admin pass: confirm the host is healthy enough to keep working, and create two local users for maintenance access. We do not want passwords set for these accounts yet; they should exist but remain locked.
>
> **Acceptance Criteria**
> - The playbook runs against both `web1` and `web2`.
> - It checks CPU information and disk usage on each host.
> - It reports a warning or note if disk usage is high.
> - It creates two local users on each host.
> - The users exist without an active password.
>
> ## Learn
>
> - Follow the commands in order.
> - Treat each task as idempotent: running it twice should not break anything.
> - This sandbox uses Ansible 2.18.5.
> - Use `web1` and `web2` as your targets.
> - Access details: `web1` and `web2` are `root` / `Passw0rd`.
>
> ## Playbook Writing Quick Guide
>
> 1. `---` starts the YAML document.
> 2. `- name:` gives the play a readable title.
> 3. `hosts:` chooses the target group or host.
> 4. `become: true` runs tasks with elevated privileges.
> 5. `gather_facts:` controls whether Ansible collects host facts first.
> 6. `tasks:` holds the ordered list of actions.
> 7. Each task uses a module such as `ping`, `copy`, or `command`.
> 8. Module arguments define what the task should do.
> 9. `register:` saves output for later tasks.
> 10. `when:` and `tags:` help control when tasks run.
>
> ## The Playbook
>
> `admin-check.yml` combines three common admin tasks:
>
> 1. **Gather facts** - `ansible.builtin.setup` collects CPU and disk facts so we can inspect the machine without guessing.
> 2. **Audit** - `ansible.builtin.debug` prints the CPU model and root filesystem size/usage, and another task warns if disk usage is above a simple threshold.
> 3. **Create users** - `ansible.builtin.user` creates two local accounts and keeps their passwords locked.
>
> This is a good pattern for routine checks: inspect first, then act, then verify.
>
> ## Practice
>
> ```bash
> ansible-playbook admin-check.yml -i inventory.ini
> ```
>
> ## Validate
>
> ```bash
> ansible all -i inventory.ini -m command -a 'getent passwd opsone opstwo'
> ```
>
> Both hosts should show the two new users in `/etc/passwd`.
>
> ## Checkpoint
>
> Why is `password_lock: true` safer than setting a placeholder password, and what would you change if the users needed SSH key access later?
