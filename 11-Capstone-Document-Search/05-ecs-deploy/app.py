"""
Document Search API — Capstone starter application.

Reads LLM settings from the environment (.env when run locally).
"""
import os

from dotenv import load_dotenv
from flask import Flask, jsonify

load_dotenv()

app = Flask(__name__)


@app.route("/")
def home():
    return jsonify(
        {
            "message": "Document Search API is running",
            "llm_model": os.getenv("LLM_MODEL", "not-set"),
            "llm_api_endpoint": os.getenv("LLM_API_ENDPOINT", "not-set"),
            "aws_region": os.getenv("AWS_REGION", "not-set"),
        }
    )


@app.route("/health")
def health():
    return jsonify({"status": "healthy"})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
