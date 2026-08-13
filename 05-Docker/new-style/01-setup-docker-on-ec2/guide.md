# 01: Setup Docker on EC2 Amazon Linux

**Time:** ~20 minutes

## Goal
SSH into an Amazon Linux 2023 EC2 instance, install Docker from the Amazon Linux repositories, and prove the daemon can run a container.

This folder is self-contained. It already has the Aether Launch `index.html` and `Dockerfile`. You do not need them until the next topic.

Do not use Ubuntu, Debian, or Docker's apt repository. This lab is Amazon Linux only.

## Commands to Teach

```bash
ssh -i your-key.pem ec2-user@<EC2_PUBLIC_IP>
sudo dnf update -y
sudo dnf install -y docker
docker run hello-world
docker ps -a
docker container prune -f
```

- `ssh` as `ec2-user` gets you onto the Amazon Linux instance where every later command runs.
- `dnf update` refreshes packages before you install Docker.
- `dnf install docker` is the Amazon Linux 2023 way to install the Docker engine. Docker is in the default Amazon Linux repos. You do not add Docker Inc's repository, and you do not use `amazon-linux-extras` (that is Amazon Linux 2 only).
- `docker run hello-world` is the first proof that Docker works on this box.
- `hello-world` exits as soon as it prints. `docker container prune` removes that leftover so later topics start clean.

## Guided Steps

1. From your laptop, SSH into the Amazon Linux 2023 EC2 instance your instructor provided:

```bash
ssh -i your-key.pem ec2-user@<EC2_PUBLIC_IP>
```

2. Confirm you are on Amazon Linux 2023 (`ID=amzn`). Stop if this is Ubuntu or another distro:

```bash
cat /etc/os-release
```

You should see `Amazon Linux 2023` (or similar) and `ID="amzn"`.

3. Install Docker from Amazon Linux repos, start the daemon, and add `ec2-user` to the docker group:

```bash
sudo dnf update -y
sudo dnf install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user
```

4. Apply the docker group, then confirm the install:

```bash
newgrp docker
docker --version
docker info
```

If `docker info` still asks for sudo, log out of SSH and log back in.

5. Run the smoke test:

```bash
docker run hello-world
```

6. Clean up the exited `hello-world` container:

```bash
docker ps -a
docker container prune -f
docker ps -a
```

`hello-world` is not a long-running service. After it prints, the container is **exited**. `docker container prune -f` deletes stopped containers. It does not delete images.

7. Clone the training repo if it is not already on the instance:

```bash
sudo dnf install -y git
git clone <REPO_URL> ~/ncc-training
cd ~/ncc-training/05-Docker/new-style/01-setup-docker-on-ec2
ls
```

You should see `guide.md`, `index.html`, and `Dockerfile` in this folder.

## Cleanup

```bash
docker ps -a
docker container prune -f
docker ps -a
```

Later topics use the container name `aether-web` and host port **8080**. If those are already taken, `docker run` fails. From topic 02 onward, start and finish with:

```bash
docker rm -f aether-web 2>/dev/null || true
docker container prune -f
docker ps
```

## Task

SSH to your Amazon Linux 2023 EC2 instance, install Docker with `dnf`, add `ec2-user` to the `docker` group, and run `docker run hello-world` without sudo.

## Checkpoint
Why do we install Docker on the EC2 instance instead of only on a laptop?
