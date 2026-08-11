# Challenge 04 - Create a Service User

Your app now needs a dedicated user account on both servers.

## Task

Write a playbook that:
- creates a user on both hosts
- sets a shell and home directory
- adds the user to a group if needed
- stays idempotent
- lets you verify the user exists

## Validate

```bash
ansible web2 -i inventory.ini -m command -a 'id demo_user'
```
