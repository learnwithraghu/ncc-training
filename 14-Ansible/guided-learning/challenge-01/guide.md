# Challenge 01 - Prove Both Servers Respond

You need a quick confidence check before a rollout, so you ask both servers to answer a simple ping.

## Task

Write a playbook that:
- pings `web1` and `web2`
- uses the `ping` module
- prints a short success message
- stays idempotent

## Validate

```bash
ansible web1 -i inventory.ini -m ping
```
