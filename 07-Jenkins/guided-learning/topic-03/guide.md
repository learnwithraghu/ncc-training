# Topic 3: Unlock and First Login

**Time:** 20 minutes

## Goal
Finish the Jenkins setup wizard: retrieve the initial admin password from
inside the container, install the suggested plugins, and create a real
admin user so you stop relying on the one-time password.

## Commands to Use
```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
docker exec jenkins jenkins-plugin-cli --list
```

## Guided Steps
1. Browse to `http://<public-ip>:8080`. Jenkins asks for an "unlock" code.
2. Get that code by reading it from inside the running container - this
   is the `jenkins_home` named volume from Topic 2, mounted at
   `/var/jenkins_home` - not from anywhere on the host filesystem, since
   nothing was bind-mounted there.
3. Paste the password in and click "Install suggested plugins." Watch the
   plugin install screen; this is downloading and unpacking `.hpi` files
   into the same `jenkins_home` volume.
4. Create your first real admin user (username, password, name, email)
   when prompted. Do **not** skip this and keep using the admin token -
   you want a normal login for the rest of the module.
5. Accept the default Jenkins URL on the final wizard screen, then click
   "Start using Jenkins."
6. From the Jenkins dashboard, go to **Manage Jenkins → Plugins →
   Installed plugins** and confirm `git`, `pipeline`, and `junit` are
   present (they come from the suggested set).

## Checkpoint
Why did the initial admin password come from a `docker exec` into the
container instead of a file you could open directly on the EC2 host?
