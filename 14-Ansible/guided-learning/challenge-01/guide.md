# Challenge 01 - Meet the Lab and Ping Both Servers

This challenge matches Topic 01. Set up the inventory and prove both servers answer a ping.

## Task

Do the same flow you learned in Topic 01:
- create `inventory.ini`
- target `web1` and `web2`
- use the `ping` module
- confirm both hosts respond

## Practice

```bash
cat > inventory.ini <<'EOF'
[web]
web1 ansible_host=web1 ansible_user=root ansible_password=Passw0rd
web2 ansible_host=web2 ansible_user=root ansible_password=Passw0rd
EOF
ansible all -i inventory.ini -m ping
```

## Validate

```bash
ansible all -i inventory.ini -m ping
```
