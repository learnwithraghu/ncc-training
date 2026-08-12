# Built BY the pipeline in Topic 12, from inside the Jenkins container,
# against the Docker daemon of the host EC2 instance.
FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

ENTRYPOINT ["python", "app.py"]
CMD ["fizzbuzz", "15"]
