# Challenge 05 - Start a Service and Restart Only on Change

You want nginx available on both servers, but you only want a restart when the config changes.

## Task

Write a playbook that:
- installs nginx
- deploys a config file
- starts and enables the service
- uses a handler for restarts
- confirms the service is active

## Validate

```bash
ansible web1 -i inventory.ini -m command -a 'systemctl is-active nginx'
```
