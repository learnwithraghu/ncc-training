FROM python:3.12-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

# Classroom approach: bake local secrets into the image.
# Anyone who can pull the image can extract the key — lab keys only.
COPY .env .env

EXPOSE 8501

HEALTHCHECK --interval=30s --timeout=10s --start-period=15s --retries=3 \
    CMD curl --fail http://localhost:8501/_stcore/health || exit 1

ENV STREAMLIT_SERVER_FILE_WATCHER_TYPE=none

CMD ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
