import csv
import io
import os
from decimal import Decimal, ROUND_HALF_UP
from urllib.parse import unquote_plus

import boto3

s3 = boto3.client("s3")

OUTPUT_BUCKET = os.environ.get("OUTPUT_BUCKET", "")
VAT_RATE = Decimal(os.environ.get("VAT_RATE", "0.15"))


def parse_bill_csv(csv_text):
    reader = csv.DictReader(io.StringIO(csv_text))
    row = next(reader)
    amount = Decimal(row["amount"])
    return {
        "bill_id": row.get("bill_id", "unknown"),
        "customer": row.get("customer", "unknown"),
        "amount": amount,
    }


def calculate_vat(amount):
    vat = (amount * VAT_RATE).quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)
    total = (amount + vat).quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)
    return vat, total


def lambda_handler(event, context):
    record = event["Records"][0]
    source_bucket = record["s3"]["bucket"]["name"]
    source_key = unquote_plus(record["s3"]["object"]["key"])

    obj = s3.get_object(Bucket=source_bucket, Key=source_key)
    csv_text = obj["Body"].read().decode("utf-8")

    bill = parse_bill_csv(csv_text)
    vat, total = calculate_vat(bill["amount"])

    result_text = (
        f"bill_id,{bill['bill_id']}\n"
        f"customer,{bill['customer']}\n"
        f"amount,{bill['amount']}\n"
        f"vat_rate,{VAT_RATE}\n"
        f"vat_amount,{vat}\n"
        f"total_amount,{total}\n"
    )

    if OUTPUT_BUCKET:
        output_key = f"processed/{bill['bill_id']}.txt"
        s3.put_object(
            Bucket=OUTPUT_BUCKET,
            Key=output_key,
            Body=result_text.encode("utf-8"),
            ContentType="text/plain",
        )

    return {
        "statusCode": 200,
        "body": result_text,
    }
