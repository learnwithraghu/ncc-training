#!/usr/bin/env python3
from datetime import datetime
import os
import socket

from flask import Flask, jsonify, request
import pymysql
import pymysql.cursors

app = Flask(__name__)

DB_HOST = os.getenv("DB_HOST", "db")
DB_PORT = int(os.getenv("DB_PORT", "3306"))
DB_USER = os.getenv("DB_USER", "appuser")
DB_PASSWORD = os.getenv("DB_PASSWORD", "apppassword")
DB_NAME = os.getenv("DB_NAME", "appdb")


def get_connection():
    return pymysql.connect(
        host=DB_HOST,
        port=DB_PORT,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
        cursorclass=pymysql.cursors.DictCursor,
        connect_timeout=3,
    )


def db_ok() -> bool:
    try:
        conn = get_connection()
        try:
            with conn.cursor() as cursor:
                cursor.execute("SELECT 1")
        finally:
            conn.close()
        return True
    except pymysql.MySQLError:
        return False


@app.get("/health")
def health():
    healthy = db_ok()
    return jsonify(
        {
            "status": "healthy" if healthy else "degraded",
            "database": "up" if healthy else "down",
            "timestamp": datetime.utcnow().isoformat() + "Z",
        }
    ), 200 if healthy else 503


@app.get("/")
def index():
    return jsonify(
        {
            "message": "Compose demo app is running",
            "container": socket.gethostname(),
            "environment": os.getenv("ENVIRONMENT", "dev"),
            "app_version": os.getenv("APP_VERSION", "0.0"),
            "database": DB_NAME,
        }
    )


@app.post("/items")
def create_item():
    payload = request.get_json(silent=True) or {}
    name = payload.get("name", "").strip()
    if not name:
        return jsonify({"error": "name is required"}), 400

    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("INSERT INTO items (name) VALUES (%s)", (name,))
            conn.commit()
            item_id = cursor.lastrowid
            cursor.execute("SELECT id, name, created_at FROM items WHERE id = %s", (item_id,))
            item = cursor.fetchone()
    finally:
        conn.close()

    item["created_at"] = item["created_at"].isoformat() + "Z"
    return jsonify({"status": "created", "item": item}), 201


@app.get("/items")
def list_items():
    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT id, name, created_at FROM items ORDER BY id DESC")
            rows = cursor.fetchall()
    finally:
        conn.close()

    for row in rows:
        row["created_at"] = row["created_at"].isoformat() + "Z"
    return jsonify({"count": len(rows), "items": rows})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)
