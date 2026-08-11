# SNS Lab: Email Subscription and Message Delivery

In this lab you will use the AWS Console to create an SNS topic, subscribe an email address, confirm the subscription, and publish a message to email.

## 1) Create an SNS topic

1. Open the AWS Console.
2. Go to **Amazon SNS**.
3. Choose **Topics**.
4. Click **Create topic**.
5. Select **Standard**.
6. Give it a name like `aws-cloud-email-topic`.
7. Click **Create topic**.

## 2) Subscribe an email address

1. Open the topic you created.
2. Click **Create subscription**.
3. Set **Protocol** to `Email`.
4. Enter your email address.
5. Click **Create subscription**.

## 3) Confirm the subscription

1. Check your inbox.
2. Open the confirmation email from Amazon SNS.
3. Click the confirmation link.

The subscription will not receive messages until it is confirmed.

## 4) Publish a test message

1. Go back to the SNS topic.
2. Choose **Publish message**.
3. Enter a subject like `SNS Test Message`.
4. Enter a message like `Hello from SNS`.
5. Click **Publish message**.

## 5) Verify delivery

Open your email inbox and confirm the message arrived.

## Notes

- SNS email delivery requires subscription confirmation.
- This is a simple push notification flow: publish once, deliver to all subscribed email addresses.
- You can later connect Lambda, EventBridge, or CloudWatch alarms to the same topic.

## Checkpoint

- Did the email subscription get confirmed?
- Did the test publish arrive in your inbox?
- Can you reuse the same topic for Lambda or alarm notifications?
