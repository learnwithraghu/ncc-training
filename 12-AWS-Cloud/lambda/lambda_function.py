import os
import json
from datetime import datetime, timezone
from urllib.request import urlopen

import boto3

SNS_TOPIC_ARN = os.environ.get("SNS_TOPIC_ARN", "")


def fetch_currency_rates():
    url = "https://open.er-api.com/v6/latest/USD"
    with urlopen(url, timeout=10) as response:
        data = json.loads(response.read().decode("utf-8"))

    rates = data.get("rates", {})
    return list(rates.items())[:10]


def build_message(rates):
    lines = ["Top 10 currency rates against USD:", ""]
    for currency, rate in rates:
        lines.append(f"{currency}: {rate}")
    lines.append("")
    lines.append(f"Generated at: {datetime.now(timezone.utc).isoformat()}")
    return "\n".join(lines)


def send_sns_message(subject, body):
    sns = boto3.client("sns")
    sns.publish(TopicArn=SNS_TOPIC_ARN, Subject=subject[:100], Message=body)


def lambda_handler(event, context):
    rates = fetch_currency_rates()
    body = build_message(rates)

    if SNS_TOPIC_ARN:
        send_sns_message("Top 10 Currency Rates", body)
        return {"statusCode": 200, "body": "SNS notification sent successfully"}

    return {"statusCode": 200, "body": body}
