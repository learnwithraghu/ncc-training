# Lambda: S3 Bill VAT Processor

This Lambda runs when a CSV file lands in S3. It reads the bill data, calculates VAT, and stores the result in another S3 bucket.

## 1) What you upload

Upload these files from your laptop into the Lambda zip:

- `lambda_function.py` - Lambda entry point
- `requirements.txt` - required package list

## 2) Sample CSV file

Use this one-line CSV as the input file:

```csv
bill_id,customer,amount
BILL-1001,Acme Corp,100.00
```

## 3) How it works

- A CSV file is uploaded to the input S3 bucket
- S3 triggers the Lambda function
- Lambda reads the bill amount
- Lambda calculates VAT and total amount
- Lambda saves the result to the output S3 bucket

## 4) Configure Lambda

Set:

- Runtime: Python 3.x
- Handler: `lambda_function.lambda_handler`
- Timeout: at least 10 seconds

## 5) Add environment variables

- `OUTPUT_BUCKET` - bucket where processed results are stored
- `VAT_RATE` - optional VAT rate, default is `0.15`

## 6) Create the S3 trigger

1. Open the input bucket in the S3 console.
2. Go to **Properties**.
3. Scroll to **Event notifications**.
4. Create a notification for `ObjectCreated` events.
5. Set the destination to the Lambda function.

## 7) Give Lambda permissions

Lambda needs permission to:

- read from the input bucket
- write to the output bucket
- be invoked by S3

## 8) Invoke the flow

Upload the sample CSV to the input bucket.

The Lambda will process it automatically and write the calculation to the output bucket.

## Output example

```text
bill_id,BILL-1001
customer,Acme Corp
amount,100.00
vat_rate,0.15
vat_amount,15.00
total_amount,115.00
```
