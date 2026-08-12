# Demo Infra Requirement

## Infra Needed

- Amazon Linux 2 EC2 instance with SSH access (port 22)
- SSH as `ec2-user`
- Security group allowing SSH; port 5000 is optional (students curl `/health` from the instance itself)
- Internet access on the instance to pull base images and talk to ECR
- ECR repository already created in `us-east-1`
- Training repo cloned on the instance (`git clone` or instructor-provided copy)
- IAM permissions on the instance role or `~/.aws/credentials` to push images:

```text
ecr:GetAuthorizationToken
ecr:BatchCheckLayerAvailability
ecr:PutImage
ecr:InitiateLayerUpload
ecr:UploadLayerPart
ecr:CompleteLayerUpload
ecr:DescribeRepositories
ecr:DescribeImages
```

## Quick Validation

On the EC2 instance:

```bash
uname -s
cat /etc/os-release | head -n 5
aws sts get-caller-identity
aws ecr describe-repositories --region us-east-1
```

After Docker is installed (topic 01 or the instructor helper):

```bash
docker --version
docker info --format '{{.ServerVersion}}'
docker run --rm hello-world
```

## Instructor Lab Runner

Prove the full student path before class. Pass the ECR image URI (repository plus tag):

```bash
cd ~/ncc-training/05-Docker/new-style/helpers
chmod +x run-ecr-lab.sh
./run-ecr-lab.sh --ecr-image-uri <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/<repo>:<tag>
```

The script installs Docker on Amazon Linux 2, builds `application/`, curls `/health`, and pushes to ECR. Exit code 0 means the lab is ready to teach.
