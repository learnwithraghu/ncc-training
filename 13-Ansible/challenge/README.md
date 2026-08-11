# Ansible Challenges

Use `inventory.ini` with `web1` and `web2`.

## Challenge 1
- Create a playbook that pings both hosts and prints a short success message.
- Use the `ping` module, not shell commands.
- Keep the playbook idempotent.
- Run it with `ansible-playbook`.
- Verify it works on both `web1` and `web2`.

Validate:
```bash
ansible web1 -i inventory.ini -m ping
```

## Challenge 2
- Write a playbook that installs one package on both hosts.
- Use the package manager module for the target system.
- Make the task safe to run multiple times.
- Name the playbook clearly.
- Show the package version or install result after running it.

Validate:
```bash
ansible web2 -i inventory.ini -m command -a 'rpm -q htop || dpkg -l htop'
```

## Challenge 3
- Write a playbook that creates a file in `/tmp` on both hosts.
- Set the file content, owner, and permissions.
- Use an Ansible module instead of `echo` or `touch`.
- Make sure the task does not duplicate content.
- Re-run it to confirm it stays unchanged.

Validate:
```bash
ansible web1 -i inventory.ini -m command -a 'cat /tmp/challenge-03.txt'
```

## Challenge 4
- Write a playbook that creates a user on both hosts.
- Add the user to a group if needed.
- Set a home directory and shell.
- Ensure the task is idempotent.
- Verify the user exists after the playbook runs.

Validate:
```bash
ansible web2 -i inventory.ini -m command -a 'id demo_user'
```

## Challenge 5
- Write a playbook that starts and enables a service on both hosts.
- Restart the service only when a config file changes.
- Use a handler for the restart.
- Keep the config and service tasks in the same playbook.
- Confirm the service is active after execution.

Validate:
```bash
ansible web1 -i inventory.ini -m command -a 'systemctl is-active nginx'
```
