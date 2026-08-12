# Python Boto3 Multi-Resource Challenge

Complete these challenges independently in AWS CloudShell after Topics 01-05. Each challenge focuses on a different AWS resource and can be implemented as a separate Python file.

## Rules

- Confirm your AWS identity and Region before making changes.
- Use Boto3; do not solve the task by running AWS CLI commands from Python.
- Never hard-code credentials, account IDs, Regions, or existing resource IDs.
- Use paginators where the API can return multiple pages.
- Catch `ClientError` for AWS API failures.
- Print a clear summary of every action.
- Prefix created resources with `ncc-boto3-`.
- Add `CreatedBy=student` and `Course=NCC` tags where the service supports tags.
- Do not modify resources you did not create.
- Complete cleanup before moving to the next challenge.

## Challenge 1 - S3: Build a File Archive

Write `challenge_s3.py` that:

1. creates a uniquely named S3 bucket in the current Region
2. uploads a text file created by the script
3. lists the objects in the bucket
4. downloads the object under a new local filename
5. verifies that the downloaded content matches the original
6. deletes the objects and bucket when the user confirms cleanup

Remember that bucket creation syntax differs for `us-east-1`. Your script must handle that difference.

## Challenge 2 - EC2: Produce an Instance Report

Write `challenge_ec2.py` that:

1. retrieves every EC2 instance in the current Region
2. extracts the instance ID, Name tag, type, state, private IP, and launch time
3. groups the instances by state
4. writes the report to `ec2-report.json`
5. prints the total number of instances in each state

This is a read-only challenge. Use a paginator and handle missing tags or IP addresses.

## Challenge 3 - DynamoDB: Create and Query a Table

Write `challenge_dynamodb.py` that:

1. creates a table named with your `ncc-boto3-` prefix
2. uses `student_id` as a string partition key
3. selects on-demand billing
4. waits until the table exists
5. inserts at least three student records
6. retrieves one record by key
7. scans and prints all challenge records
8. deletes the table and waits until it is gone

Use a DynamoDB resource for item operations and a client waiter for table state changes.

## Challenge 4 - SNS: Publish a Notification

Write `challenge_sns.py` that:

1. creates an SNS topic
2. prints its returned topic ARN
3. tags the topic
4. publishes a test message to the topic
5. prints the returned message ID
6. lists topics and confirms that the new topic exists
7. deletes the topic

An email subscription is optional and must only use an address you control. Never add another person without permission.

## Challenge 5 - Lambda: Audit Functions

Write `challenge_lambda.py` that:

1. lists every Lambda function in the current Region
2. retrieves the configuration for each function
3. reports its name, runtime, memory, timeout, last modified time, and role
4. marks functions with a timeout greater than 30 seconds as `REVIEW`
5. writes the results to `lambda-report.json`

This is a read-only challenge. The script must still produce a valid empty report when no functions exist.

## Challenge 6 - CloudWatch: Inspect EC2 CPU Metrics

Write `challenge_cloudwatch.py` that:

1. asks the user for an EC2 instance ID
2. requests the last hour of `AWS/EC2` `CPUUtilization`
3. uses a five-minute period and the `Average` statistic
4. sorts returned data points by timestamp
5. prints the minimum, maximum, and average CPU utilization
6. explains clearly when no data points are available

Validate that the instance exists before requesting its metrics.

## Challenge 7 - IAM: Create a Security Inventory

Write `challenge_iam.py` that:

1. lists all IAM users
2. reports whether each user has a console password
3. counts access keys by status
4. lists directly attached managed policies
5. writes the results to `iam-report.json`
6. prints a warning for users with two active access keys

This is read-only. IAM is global, so do not assume the current CloudShell Region changes the results.

## Final Integration Challenge

Write `aws_audit.py` that combines at least four read-only challenges into one report containing:

- execution timestamp in UTC
- AWS account ID
- active Region
- one section per AWS service
- a list of warnings
- a non-zero exit code if an AWS API request fails

Save the report as JSON and upload it to an S3 bucket created for the challenge. Download the report to verify it, then empty and delete the bucket.

## Completion Check

Be ready to explain:

1. where your script used a client and where it used a resource
2. why pagination was required
3. how you handled optional response fields
4. which operations needed a waiter
5. how the script avoided changing unrelated AWS resources
6. how you confirmed that cleanup completed
