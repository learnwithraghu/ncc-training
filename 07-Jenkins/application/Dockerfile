# syntax=docker/dockerfile:1
# Built BY the Jenkins pipeline in Topic 14 (Docker-in-Jenkins), not by Jenkins itself.
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

CMD ["python", "app.py", "fizzbuzz", "15"]
