# Lambda: Currency Rates Email Sender

This Lambda function runs on invocation, fetches the top 10 currency rates against USD, and sends the result through Amazon SNS email subscription.

## 1) What you upload

Upload these files from your laptop into the Lambda zip:

- `lambda_function.py` - Lambda entry point
- `requirements.txt` - required package list

## 2) Install packages locally

If you are packaging on your laptop:

```bash
pip install -r requirements.txt -t .
```

Then zip the folder contents and upload the zip to Lambda.

## 3) Configure Lambda

Set:

- Runtime: Python 3.x
- Handler: `lambda_function.lambda_handler`
- Timeout: at least 10 seconds

## 4) Add environment variables

- `SNS_TOPIC_ARN` - the SNS topic ARN to publish to

## 5) Create the SNS email subscription

1. Open Amazon SNS in the AWS console.
2. Create a topic.
3. Add an email subscription to that topic.
4. Confirm the subscription from the email you receive.

SNS will handle the email delivery after that.

## 6) Invoke the function

Trigger the function manually from the Lambda console or CLI.

## 7) What the function does

- Gets currency rates from a public rates API
- Picks the top 10 currencies
- Sends the list to SNS
- SNS delivers the email to subscribed recipients

## Output

If `SNS_TOPIC_ARN` is not set, the function returns the rates as text instead of sending a notification.
