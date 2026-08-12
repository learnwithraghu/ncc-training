# Topic 02 - Calling AWS APIs and Reading Responses

**Time:** 20 minutes

## Goal

Call an AWS API, inspect its response, and safely read nested dictionaries and lists.

## Learn

Most Boto3 client methods return a dictionary. The dictionary can contain strings, numbers, lists, other dictionaries, and response metadata.

Use:

- `response["Key"]` when the key must exist
- `response.get("Key", default)` when the key may be missing
- a `for` loop to process a list of resources

## Practice

```bash
mkdir -p ~/boto3-labs/topic-02
cd ~/boto3-labs/topic-02
nano list_buckets.py
```

Add this read-only script:

```python
import boto3

s3 = boto3.client("s3")
response = s3.list_buckets()
buckets = response.get("Buckets", [])

print(f"Found {len(buckets)} bucket(s)")

for bucket in buckets:
    name = bucket["Name"]
    created = bucket["CreationDate"]
    print(f"- {name} | created: {created}")
```

Run it:

```bash
python3 list_buckets.py
```

## Inspect the Response

Temporarily add pretty printing:

```python
from pprint import pprint

pprint(response)
```

Notice that `Buckets` is a list and each item in that list is a dictionary.

## Pass Request Parameters

API parameters use keyword arguments. This example asks EC2 for information about available Regions:

```python
import boto3

ec2 = boto3.client("ec2")
response = ec2.describe_regions(AllRegions=False)

for region in response.get("Regions", []):
    print(region["RegionName"])
```

Python argument names and capitalization must match the Boto3 documentation exactly.

## Checkpoint

What is the difference between `response["Buckets"]` and `response.get("Buckets", [])`, and when is the second form safer?
