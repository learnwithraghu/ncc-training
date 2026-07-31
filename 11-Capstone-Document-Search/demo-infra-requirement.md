# Demo Infra Requirement

## Infra Needed

- Docker (Docker Compose optional for Step 03)
- AWS CLI with credentials that can use ECR
- AWS Console access for ECR, ECS, VPC/security groups, and CloudWatch Logs
- A VPC with at least one public subnet (default VPC is fine)
- Security group allowing inbound TCP `8501` from your IP
- Outbound internet from the ECS task so it can reach `LLM_API_ENDPOINT`
- Working LLM API key, endpoint (chat completions URL), and model name

## Quick Validation

```bash
docker --version
docker compose version
aws --version
aws sts get-caller-identity
aws ecr describe-repositories --region "${AWS_REGION:-us-east-1}"
aws ecs list-clusters --region "${AWS_REGION:-us-east-1}"
```

Per-step env check (example for Step 01):

```bash
cd 01-application-overview
test -f ../.env_example && echo "module env template present"
cp -n ../.env_example .env
# edit .env — set LLM_API_KEY, LLM_API_ENDPOINT, LLM_MODEL
```

Local app smoke (optional, without Docker):

```bash
cd 01-application-overview
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
streamlit run app/app.py
# open http://localhost:8501
```

## Console Checks

- Amazon ECR: can create repository `document-search`
- Amazon ECS: can create a Fargate cluster and service
- EC2 → Security Groups: inbound TCP `8501`
- CloudWatch Logs: task logs visible after deploy
- Browser can open Streamlit UI and upload a PDF
