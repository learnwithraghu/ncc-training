# Python Boto3 for AWS Automation

This module teaches students how to automate AWS with Python and Boto3 from AWS CloudShell.

## What You Will Learn

By the end of this module, you will be able to:

- create Boto3 sessions, clients, and resources
- pass parameters to AWS API operations
- read nested response dictionaries
- use paginators and waiters
- handle AWS API errors safely
- automate several AWS services with Python

## Environment

Use AWS CloudShell so Python, Boto3, AWS credentials, and the active AWS Region are already available.

Before starting, verify the environment:

```bash
python3 --version
aws sts get-caller-identity
aws configure get region
```

CloudShell uses the permissions of the signed-in IAM identity. Students must only run actions allowed by the instructor and should delete resources created during practice.

## Guided Learning

Work through the five topics in order:

1. [Boto3 Setup, Sessions, and Clients](guided-learning/topic-01/guide.md)
2. [Calling AWS APIs and Reading Responses](guided-learning/topic-02/guide.md)
3. [Parameters, Collections, and Resource Actions](guided-learning/topic-03/guide.md)
4. [Errors, Paginators, and Waiters](guided-learning/topic-04/guide.md)
5. [Building a Multi-Service Automation Script](guided-learning/topic-05/guide.md)

Each topic is designed for about 20 minutes.

## Student Challenge

After finishing all five topics, complete [challenge.md](challenge.md). It contains independent tasks covering S3, EC2, DynamoDB, SNS, Lambda, CloudWatch, and IAM.

## Cost and Safety

- Prefer read-only discovery tasks where possible.
- Use a clear prefix such as `ncc-boto3-<name>` for resources.
- Do not modify production resources.
- Never place access keys in Python files.
- Clean up chargeable resources immediately after validation.
