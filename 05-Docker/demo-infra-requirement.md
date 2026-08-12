# Demo Infra Requirement

## Infra Needed

- Amazon Linux 2 EC2 instance with SSH access (port 22)
- SSH as `ec2-user`
- Security group allowing SSH; port **8080** if students open the Aether Launch page in a browser
- Internet access on the instance to pull base images and talk to ECR
- ECR repository already created in `us-east-1`
- Training repo cloned on the instance
- An IAM instance profile attached to the EC2 instance that can already push to and pull from ECR (no `~/.aws/credentials`)

## Quick Validation

On the EC2 instance:

```bash
uname -s
cat /etc/os-release | head -n 5
aws sts get-caller-identity
aws ecr describe-repositories --region us-east-1
```

After Docker is installed:

```bash
docker --version
docker info --format '{{.ServerVersion}}'
docker run --rm hello-world
```

## Instructor Lab Runner

```bash
cd ~/ncc-training/05-Docker/new-style/helpers
bash run-ecr-lab.sh
```

The script asks only for the ECR image URI (region is us-east-1). It uses the EC2 IAM role, serves the Aether Launch HTML from disk, bakes `aether-launch:1.0`, curls the company page, pushes, then pulls and runs again. Exit code 0 means the lab is ready to teach.
