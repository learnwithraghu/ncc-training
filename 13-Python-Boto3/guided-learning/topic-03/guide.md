# Topic 03 - Parameters, Collections, and Resource Actions

**Time:** 20 minutes

## Goal

Pass structured parameters to Boto3 and use the higher-level resource interface.

## Learn

Boto3 clients closely match AWS service APIs. Boto3 resources provide Python objects and collections for supported services.

Common parameter shapes include:

- strings: `Bucket="my-bucket"`
- booleans: `DryRun=True`
- lists: `InstanceIds=["i-123", "i-456"]`
- dictionaries: `Tagging={"TagSet": [...]}`
- lists of dictionaries: `Filters=[{"Name": "...", "Values": ["..."]}]`

## Practice: Filter EC2 Instances

```bash
mkdir -p ~/boto3-labs/topic-03
cd ~/boto3-labs/topic-03
nano instances.py
```

Add this read-only script:

```python
import boto3

ec2 = boto3.resource("ec2")

filters = [
    {
        "Name": "instance-state-name",
        "Values": ["running", "stopped"],
    }
]

instances = ec2.instances.filter(Filters=filters)

for instance in instances:
    name = "unnamed"

    for tag in instance.tags or []:
        if tag["Key"] == "Name":
            name = tag["Value"]
            break

    print(f"{instance.id}: {name} ({instance.state['Name']})")
```

Run it:

```bash
python3 instances.py
```

## Client and Resource Comparison

The following forms refer to S3 in different ways:

```python
import boto3

s3_client = boto3.client("s3")
s3_resource = boto3.resource("s3")

response = s3_client.list_buckets()

for bucket in s3_resource.buckets.all():
    print(bucket.name)
```

Use a client when you want direct access to service API operations. Use a resource when its object-oriented interface makes the script clearer. Not every AWS service has a resource interface.

## Safe Write Preview

Some APIs support `DryRun=True`, including selected EC2 operations. A dry run checks permissions without performing the action. It does not exist for every API, so verify support in the Boto3 documentation.

## Checkpoint

In the EC2 filter, why are `Filters` and `Values` lists even when the script provides only one filter and one value?
