# 01: Setup Docker on EC2 Amazon Linux 2

**Time:** ~20 minutes

## Goal
SSH into an Amazon Linux 2 EC2 instance, install Docker, and prove the daemon can run a container.

## Commands to Teach

```bash
ssh -i your-key.pem ec2-user@<EC2_PUBLIC_IP>
sudo yum update -y
sudo amazon-linux-extras install docker -y
docker run hello-world
```

- `ssh` as `ec2-user` gets you onto the Amazon Linux 2 instance where every later command runs.
- `yum update` refreshes packages before you install Docker.
- `amazon-linux-extras install docker` is the Amazon Linux 2 way to install the Docker engine.
- `docker run hello-world` is the first proof that Docker works on this box.

## Guided Steps

1. From your laptop, SSH into the Amazon Linux 2 EC2 instance your instructor provided:

```bash
ssh -i your-key.pem ec2-user@<EC2_PUBLIC_IP>
```

2. Confirm you are on Amazon Linux 2:

```bash
cat /etc/os-release
```

You should see `Amazon Linux 2` in `PRETTY_NAME`.

3. Install Docker, start the daemon, and add `ec2-user` to the docker group:

```bash
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user
```

4. Apply the docker group in this shell, then confirm the install:

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

You should see a message that the Docker client contacted the daemon, pulled the image, and ran a container.

6. Clone the training repo if it is not already on the instance (install git first if needed):

```bash
sudo yum install -y git
git clone <REPO_URL> ~/ncc-training
cd ~/ncc-training
```

## Task

SSH to your Amazon Linux 2 EC2 instance, install Docker with `amazon-linux-extras`, add `ec2-user` to the `docker` group, and run `docker run hello-world` without sudo. Do not move on until that command succeeds.

## Checkpoint
Why do we install and run Docker on EC2 Amazon Linux 2 instead of building images only on a laptop?
