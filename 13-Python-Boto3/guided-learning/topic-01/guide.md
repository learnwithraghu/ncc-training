# Topic 01 - Boto3 Setup, Sessions, and Clients

**Time:** 20 minutes

## Goal

Understand the basic Boto3 syntax and make a safe AWS API call from CloudShell.

## Learn

Boto3 automatically uses the AWS credentials and Region available in CloudShell. Do not put access keys in your script.

The common starting objects are:

- `boto3.Session()` - describes the current AWS SDK session
- `session.client("service")` - provides low-level service API operations
- `session.resource("service")` - provides a higher-level object interface for supported services

Client method names usually match AWS API operation names converted to `snake_case`. For example, the STS `GetCallerIdentity` operation becomes `get_caller_identity()`.

## Practice

Create a workspace:

```bash
mkdir -p ~/boto3-labs/topic-01
cd ~/boto3-labs/topic-01
nano identity.py
```

Add this script:

```python
import boto3

session = boto3.Session()
sts = session.client("sts")

identity = sts.get_caller_identity()

print(f"Region: {session.region_name}")
print(f"Account: {identity['Account']}")
print(f"ARN: {identity['Arn']}")
```

Run it:

```bash
python3 identity.py
```

## Syntax Breakdown

```python
import boto3
session = boto3.Session()
client = session.client("sts")
response = client.get_caller_identity()
```

- imports are placed at the top
- strings such as `"sts"` identify an AWS service
- method calls use parentheses
- AWS responses are Python dictionaries
- dictionary values are accessed with keys such as `response["Account"]`

## Try It

Add this line to display all available profile names:

```python
print(f"Profiles: {session.available_profiles}")
```

## Checkpoint

Why should a CloudShell Boto3 script use the existing session credentials instead of hard-coded access keys?
