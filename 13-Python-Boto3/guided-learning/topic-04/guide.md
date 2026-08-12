# Topic 04 - Errors, Paginators, and Waiters

**Time:** 20 minutes

## Goal

Write reliable Boto3 scripts that handle API errors, retrieve every result page, and wait for asynchronous AWS operations.

## Handle AWS API Errors

Boto3 raises `botocore.exceptions.ClientError` when AWS rejects a request.

```python
import boto3
from botocore.exceptions import ClientError

s3 = boto3.client("s3")
bucket_name = "this-bucket-should-not-exist-ncc-example"

try:
    s3.head_bucket(Bucket=bucket_name)
    print(f"{bucket_name} exists and is accessible")
except ClientError as error:
    code = error.response["Error"]["Code"]
    message = error.response["Error"]["Message"]
    print(f"AWS error {code}: {message}")
```

Catch specific SDK errors. Avoid a bare `except:` because it can hide Python bugs and keyboard interrupts.

## Retrieve Every Page

Many list operations return only one page. A paginator repeatedly calls the API by using the service's continuation token.

```bash
mkdir -p ~/boto3-labs/topic-04
cd ~/boto3-labs/topic-04
nano paginated_instances.py
```

```python
import boto3

ec2 = boto3.client("ec2")
paginator = ec2.get_paginator("describe_instances")

instance_count = 0

for page in paginator.paginate():
    for reservation in page.get("Reservations", []):
        for instance in reservation.get("Instances", []):
            instance_count += 1
            print(instance["InstanceId"], instance["State"]["Name"])

print(f"Total instances: {instance_count}")
```

Run it:

```bash
python3 paginated_instances.py
```

## Wait for State Changes

AWS operations are often asynchronous. Waiters poll until a resource reaches a target state:

```python
ec2 = boto3.client("ec2")
waiter = ec2.get_waiter("instance_running")
waiter.wait(InstanceIds=["i-0123456789abcdef0"])
print("The instance is running")
```

Do not run this example with the placeholder ID. In a real script, use an instance ID returned by an earlier API call.

## Checkpoint

Why can a script that calls `describe_instances()` only once miss resources, and why is a waiter better than a fixed `time.sleep(60)`?
