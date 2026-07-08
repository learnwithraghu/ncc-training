# Day 5, Capstone Guide 2: Dockerize the Application

## Goal
Build a Docker image for the document-search application.

## Time
Approximately **20 minutes**.

## Prerequisites

- Docker installed and running
- Application source code available

---

## Step 1: Prepare the Application

Create the capstone application directory:

```bash
mkdir -p ~/ncc-labs/day5/document-search
cd ~/ncc-labs/day5/document-search
```

Create a simple `app.py`:

```python
from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def home():
    return jsonify({"message": "Document Search API is running"})

@app.route("/health")
def health():
    return jsonify({"status": "healthy"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

Create `requirements.txt`:

```
flask==3.0.0
```

## Step 2: Create the Dockerfile

```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]
```

## Step 3: Build the Image

```bash
docker build -t document-search:latest .
```

## Step 4: Test Locally

```bash
docker run -d -p 5000:5000 --name doc-search document-search:latest
curl http://localhost:5000/
curl http://localhost:5000/health
docker stop doc-search && docker rm doc-search
```

---

## Check Your Understanding

1. What does `docker build -t document-search:latest .` do?
2. Why do we use `python:3.11-slim` instead of `python:3.11`?
3. What port does the application listen on?
