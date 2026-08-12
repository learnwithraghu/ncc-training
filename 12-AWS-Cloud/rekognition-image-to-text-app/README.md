# Simple AWS Rekognition Image-to-Text App

This small Flask app uploads a JPEG or PNG image, sends its bytes directly to AWS Rekognition, and displays the detected text. It does not save uploaded images.

## Requirements

- an EC2 instance with Python 3
- an attached IAM role that allows `rekognition:DetectText`
- an EC2 Region where Amazon Rekognition is available
- inbound TCP port `5000` allowed from your IP in the EC2 security group

No AWS access keys are needed. Boto3 automatically uses the EC2 instance role.

## Start the App

From the repository root on EC2:

```bash
cd 12-AWS-Cloud/rekognition-image-to-text-app
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python app.py
```

The app listens on port `5000`.

Open this URL in a browser:

```text
http://EC2_PUBLIC_IP:5000
```

Replace `EC2_PUBLIC_IP` with the instance's public IPv4 address or public DNS name.

## If Python venv Is Missing

On Amazon Linux:

```bash
sudo dnf install -y python3
```

On Ubuntu:

```bash
sudo apt update
sudo apt install -y python3 python3-venv
```

## Verify the EC2 Role

```bash
aws sts get-caller-identity
aws configure get region
```

The app defaults to `us-east-1`. To use another Region, set it before starting:

```bash
export AWS_DEFAULT_REGION=us-west-2
python app.py
```

## Security Group

Add an inbound rule with:

- type: Custom TCP
- port: `5000`
- source: your public IP address, for example `203.0.113.10/32`

Do not use `0.0.0.0/0` unless this temporary training app must be publicly reachable. The built-in Flask server is intended for classroom demonstrations, not production use.

Stop the app with `Ctrl+C`.
