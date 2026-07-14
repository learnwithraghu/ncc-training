# Demo Infra Requirement

## Infra Needed
- Python 3.10+ and pip
- Docker Engine
- Optional for cloud deployment guides: AWS CLI and authenticated AWS account

## Quick Validation
```bash
python3 --version
python3 -m pip --version
docker --version
command -v aws && aws sts get-caller-identity || echo 'aws cli/auth optional unless doing ECR/ECS guides'
```
