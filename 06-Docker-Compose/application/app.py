#!/usr/bin/env python3
from datetime import datetime
from pathlib import Path
import os
import socket

from flask import Flask, jsonify, request
import redis

app = Flask(__name__)

REDIS_HOST = os.getenv("REDIS_HOST", "redis")
REDIS_PORT = int(os.getenv("REDIS_PORT", "6379"))
QUEUE_NAME = os.getenv("QUEUE_NAME", "events")
DATA_DIR = Path(os.getenv("DATA_DIR", "/app/data"))

redis_client = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, decode_responses=True)


def redis_ok() -> bool:
    try:
        return bool(redis_client.ping())
    except redis.RedisError:
        return False


@app.get("/health")
def health():
    return jsonify(
        {
            "status": "healthy" if redis_ok() else "degraded",
            "redis": "up" if redis_ok() else "down",
            "timestamp": datetime.utcnow().isoformat() + "Z",
        }
    ), 200 if redis_ok() else 503


@app.get("/")
def index():
    hits = "unavailable"
    try:
        hits = str(redis_client.incr("web:hits"))
    except redis.RedisError:
        pass

    return jsonify(
        {
            "message": "Compose demo app is running",
            "container": socket.gethostname(),
            "environment": os.getenv("ENVIRONMENT", "dev"),
            "app_version": os.getenv("APP_VERSION", "0.0"),
            "hits": hits,
            "queue": QUEUE_NAME,
        }
    )


@app.post("/events")
def create_event():
    payload = request.get_json(silent=True) or {}
    title = payload.get("title", "untitled")
    event = {
        "title": title,
        "source": payload.get("source", "guided-learning"),
        "created_at": datetime.utcnow().isoformat() + "Z",
    }

    redis_client.rpush(QUEUE_NAME, str(event))
    return jsonify({"status": "queued", "event": event}), 201


@app.get("/events")
def queue_info():
    length = redis_client.llen(QUEUE_NAME)
    return jsonify({"queue": QUEUE_NAME, "pending": length})


@app.get("/processed")
def processed_events():
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    log_file = DATA_DIR / "processed.log"
    if not log_file.exists():
        return jsonify({"count": 0, "items": []})

    with log_file.open("r", encoding="utf-8") as handle:
        lines = [line.strip() for line in handle.readlines() if line.strip()]

    return jsonify({"count": len(lines), "items": lines})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)
