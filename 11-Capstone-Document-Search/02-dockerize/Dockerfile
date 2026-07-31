# Build for ECS Fargate (x86_64) even on Apple Silicon
FROM --platform=linux/amd64 python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

# Classroom approach: bake local secrets into the image.
# Do NOT use AWS Secrets Manager in this lab.
COPY .env .env

EXPOSE 5000

CMD ["python", "app.py"]
