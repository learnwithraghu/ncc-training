# Challenge 02 - Install a Small Helper Tool

Your app team wants a basic utility on both servers, and you want the install to be repeatable.

## Task

Write a playbook that:
- installs one package on both hosts
- uses the package manager module
- runs safely more than once
- has a clear file name
- lets you verify the package after the run

## Validate

```bash
ansible web2 -i inventory.ini -m command -a 'rpm -q htop || dpkg -l htop'
```
