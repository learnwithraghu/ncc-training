# Topic 05 - Variables, Templates, and Debug

Use variables and Jinja2 templates to personalize configuration and inspect values.

## Learn

- Follow the commands in order.
- Treat each task as idempotent: running it twice should not break anything.
- Use `web1` and `web2` as your targets.

## Practice

```bash
ansible-playbook vars.yml -i inventory.ini
ansible web1 -i inventory.ini -m debug -a 'var=ansible_hostname'
```

## Checkpoint

Where would you store values that change between environments?
