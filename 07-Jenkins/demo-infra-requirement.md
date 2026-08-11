# Demo Infra Requirement

## Infra Needed

- **Topic 1 only:** an EC2 instance running Amazon Linux, with `sudo` access. This is used once,
  deliberately, to show a manual Jenkins install failing.
- **Topics 2-15:** any machine with Docker already installed and running. The machine type does not
  matter (EC2, local laptop, a lab VM) — only that `docker` works.
- Free local ports `8080` (Jenkins web UI) and `50000` (Jenkins agent port)
- Internet access to pull `jenkins/jenkins:lts-jdk17` and apt packages during image builds

## Quick Validation

```bash
docker --version
docker info
docker ps
```

## Full Validation

Run the module validator before teaching or running the guided topics. It checks Docker
availability, free ports, and that all module files are present.

```bash
/workspaces/ncc-training/07-Jenkins/helpers/validate-infra.sh
```
