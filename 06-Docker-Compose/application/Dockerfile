# syntax=docker/dockerfile:1
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py worker.py ./

ENV PYTHONUNBUFFERED=1 \
    ENVIRONMENT=training \
    APP_VERSION=1.0 \
    REDIS_HOST=redis \
    REDIS_PORT=6379 \
    QUEUE_NAME=events \
    DATA_DIR=/app/data

RUN useradd --create-home --shell /usr/sbin/nologin appuser \
    && mkdir -p /app/data \
    && chown -R appuser:appuser /app

USER appuser

EXPOSE 5000

HEALTHCHECK --interval=20s --timeout=3s --start-period=5s --retries=3 \
  CMD python -c "from urllib.request import urlopen; urlopen('http://127.0.0.1:5000/health', timeout=2)"

CMD ["python", "app.py"]
