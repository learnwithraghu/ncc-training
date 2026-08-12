# Topic 17 - Install and Start Docker on web1 and web2

You already installed packages and managed services with Ansible (Topic 07).
Now do the same for Docker on both web hosts so they can run containers.

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

`docker-install.yml` has two tasks on the `web` group (`web1` and `web2`):

1. **Install** - `ansible.builtin.dnf` puts the `docker` package on each host.
2. **Start** - `ansible.builtin.systemd` sets `enabled: true` and `state: started`
   so Docker starts now and again after reboot.

Same pattern as Topic 07 (install nginx, then start it) — different package and
service name.

## Practice

```bash
ansible-playbook -i inventory.ini guided-learning/topic-17/docker-install.yml
```

Or, from inside the topic folder:

```bash
cd guided-learning/topic-17
ansible-playbook docker-install.yml -i ../../inventory.ini
```

## Validate

```bash
ansible all -i inventory.ini -m command -a 'docker --version'
ansible all -i inventory.ini -m command -a 'systemctl is-active docker'
ansible all -i inventory.ini -m command -a 'systemctl is-enabled docker'
```

Both hosts should show a Docker version, `active`, and `enabled`.

## Checkpoint

Why set both `state: started` and `enabled: true` on the Docker service?
