# Topic 1: Install the AWS CLI

**Time:** ~20 minutes

## What You'll Learn (and Solve)

1. Install AWS CLI v2 with the official Linux installer on Ubuntu.
2. Confirm the binary is on your `PATH` with `aws --version`.
3. Skip the install cleanly when AWS CLI is already present.
4. Avoid mixing in the old `awscli` v1 package from `apt`.
5. Solve "I need `aws` before I can talk to ECR or describe my account."

## Goal
Get a working AWS CLI v2 on the Ubuntu lab host where the rest of this
Kubernetes module runs. This folder is self-contained — no manifests,
just the install steps.

This lab is Ubuntu only (`NAME="Ubuntu"` in `/etc/os-release`). Do not use
Amazon Linux `dnf` or Homebrew.

## Commands to Teach

```bash
aws --version
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

- `aws --version` — proves CLI v2 is installed and on your `PATH` before
  you change anything.
- `curl` downloads the official AWS CLI v2 installer zip for x86_64 Linux.
- `unzip` extracts the `aws/` install directory next to the zip.
- `sudo ./aws/install` places the CLI under `/usr/local/aws-cli` and links
  `aws` into `/usr/local/bin`.

## Guided Steps

1. Confirm you are on Ubuntu (`ID=ubuntu`, `NAME="Ubuntu"`). Stop if this
   is Amazon Linux or another distro:

```bash
cat /etc/os-release
```

2. Check whether AWS CLI is already installed:

```bash
aws --version
```

If you see `aws-cli/2.x.x`, you can skip to the Task. If the command is
missing, continue.

3. Install unzip if needed, then download and run the official installer:

```bash
sudo apt-get update -y
sudo apt-get install -y unzip
cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -o awscliv2.zip
sudo ./aws/install
```

If an older install already exists, use:

```bash
sudo ./aws/install --update
```

4. Confirm the install:

```bash
aws --version
which aws
```

You should see `aws-cli/2.` and a path under `/usr/local/bin` (or similar).

5. Clean up the installer files:

```bash
rm -rf /tmp/aws /tmp/awscliv2.zip
```

## Task

Install AWS CLI v2 (or confirm it is already present) and get
`aws --version` to print a `2.x` version string without sudo.

## Checkpoint

Why do we prefer the official AWS CLI v2 installer over `sudo apt install
awscli` on this lab host?

## What's Next?

This is good, but we still need:

1. Credentials so `aws` can call your account — not only a binary that
   prints a version.
2. A default region (`us-east-1`) so every later ECR command stays scoped.
3. A way to prove the identity you will use for ECR login and push.
4. Confirmation the `orbital-relay` ECR repository exists before you build.
5. Wire credentials into the CLI — **Topic 2: Configure the AWS CLI**.
