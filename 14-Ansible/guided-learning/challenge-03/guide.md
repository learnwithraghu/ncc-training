# Challenge 03 - Place the Same File on Both Hosts

You need a small config note copied to both servers with the right permissions.

## Task

Write a playbook that:
- creates a file in `/tmp`
- sets content, owner, and permissions
- uses an Ansible module, not shell commands
- avoids duplicate content
- can be re-run safely

## Validate

```bash
ansible web1 -i inventory.ini -m command -a 'cat /tmp/challenge-03.txt'
```
