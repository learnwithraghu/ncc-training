# Topic 16 - Stand Up a Jenkins Master/Slave Pair

You now know enough Ansible to replace the manual Jenkins install from the
`07-Jenkins` module with a playbook - and to prep a second host as a build
agent at the same time.

## Learn

- `web1` becomes the Jenkins **master** (the controller running the web UI
  on port 8080).
- `web2` becomes the Jenkins **slave** (an agent the master reaches over
  SSH to run jobs).
- Jenkins needs Java, its own yum repo and signing key, then the `jenkins`
  package - the same steps as the manual install in
  `07-Jenkins/guided-learning/topic-01`, just expressed as tasks.
- An agent only needs Java installed - Jenkins itself connects over SSH to
  launch it, and `web1`/`web2` already accept `root` / `Passw0rd`, the
  same login `inventory.ini` uses. No extra keys or users needed.

## Practice

```bash
ansible-playbook -i inventory.ini guided-learning/topic-16/jenkins-master-slave.yml
```

## Validate

```bash
ansible web1 -i inventory.ini -m service_facts
ansible web2 -i inventory.ini -m command -a 'java -version'
```

Then, from a browser, open `http://<web1-address>:8080` and finish the
setup wizard (the initial admin password is at
`/var/lib/jenkins/secrets/initialAdminPassword` on web1). Add `web2` as a
node: **Manage Jenkins > Nodes > New Node**, launch method **Launch agents
via SSH**, host `web2`, credentials kind **Username with password**,
`root` / `Passw0rd`, and host key verification strategy **Non verifying**.

## Checkpoint

This reuses the same `root` / `Passw0rd` login as `inventory.ini` to keep
the lab simple. In a real environment, what would you set up instead so
Jenkins doesn't need the root password to reach its agents?
