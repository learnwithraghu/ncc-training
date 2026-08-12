# Topic 05 - Building a Multi-Service Automation Script

**Time:** 20 minutes

## Goal

Combine sessions, clients, functions, API parameters, response parsing, pagination, and error handling in one inventory script.

## Design

The script will:

1. identify the current AWS account
2. count S3 buckets
3. count EC2 instances by state
4. count DynamoDB tables
5. print one report

All operations are read-only.

## Practice

```bash
mkdir -p ~/boto3-labs/topic-05
cd ~/boto3-labs/topic-05
nano aws_inventory.py
```

Add this script:

```python
import boto3
from botocore.exceptions import BotoCoreError, ClientError


def count_ec2_instances(session):
    ec2 = session.client("ec2")
    paginator = ec2.get_paginator("describe_instances")
    counts = {}

    for page in paginator.paginate():
        for reservation in page.get("Reservations", []):
            for instance in reservation.get("Instances", []):
                state = instance["State"]["Name"]
                counts[state] = counts.get(state, 0) + 1

    return counts


def count_dynamodb_tables(session):
    dynamodb = session.client("dynamodb")
    paginator = dynamodb.get_paginator("list_tables")
    return sum(len(page.get("TableNames", [])) for page in paginator.paginate())


def main():
    session = boto3.Session()
    sts = session.client("sts")
    s3 = session.client("s3")

    identity = sts.get_caller_identity()
    buckets = s3.list_buckets().get("Buckets", [])

    print("AWS INVENTORY")
    print(f"Account: {identity['Account']}")
    print(f"Region: {session.region_name}")
    print(f"S3 buckets: {len(buckets)}")
    print(f"EC2 by state: {count_ec2_instances(session)}")
    print(f"DynamoDB tables: {count_dynamodb_tables(session)}")


if __name__ == "__main__":
    try:
        main()
    except (BotoCoreError, ClientError) as error:
        print(f"Inventory failed: {error}")
        raise SystemExit(1)
```

Run it:

```bash
python3 aws_inventory.py
```

## Syntax Review

- functions separate service-specific logic
- one `Session` is shared with helper functions
- paginators retrieve complete EC2 and DynamoDB results
- `.get()` safely handles optional response lists
- `if __name__ == "__main__":` defines the script entry point
- known AWS SDK errors produce a controlled exit code

## Extend It

Add a function that counts SNS topics with the `list_topics` paginator, then include the count in the report.

## Checkpoint

Why is it useful to pass one session into the helper functions instead of creating unrelated credentials or configuration inside every function?
