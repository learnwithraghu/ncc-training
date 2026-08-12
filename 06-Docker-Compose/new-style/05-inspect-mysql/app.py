#!/usr/bin/env python3
"""Tiny login demo. Saves username + password to MySQL. Demo only — never do this in production."""
import os
import time

from flask import Flask, request
import pymysql

app = Flask(__name__)

DB_HOST = os.getenv("DB_HOST", "db")
DB_PORT = int(os.getenv("DB_PORT", "3306"))
DB_USER = os.getenv("DB_USER", "appuser")
DB_PASSWORD = os.getenv("DB_PASSWORD", "apppassword")
DB_NAME = os.getenv("DB_NAME", "appdb")

LOGIN_PAGE = """
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Compose Login Demo</title>
  <style>
    body { font-family: sans-serif; max-width: 360px; margin: 60px auto; }
    label { display: block; margin: 12px 0 4px; }
    input { width: 100%; padding: 8px; box-sizing: border-box; }
    button { margin-top: 16px; padding: 8px 16px; }
  </style>
</head>
<body>
  <h1>Login</h1>
  <p>Submit a username and password. Compose saves them in MySQL.</p>
  <form method="POST" action="/login">
    <label>Username</label>
    <input name="username" required>
    <label>Password</label>
    <input name="password" type="password" required>
    <button type="submit">Login</button>
  </form>
</body>
</html>
"""


def get_connection(retries=20):
    last_error = None
    for _ in range(retries):
        try:
            return pymysql.connect(
                host=DB_HOST,
                port=DB_PORT,
                user=DB_USER,
                password=DB_PASSWORD,
                database=DB_NAME,
            )
        except pymysql.MySQLError as err:
            last_error = err
            time.sleep(1)
    raise last_error


@app.get("/")
def index():
    return LOGIN_PAGE


@app.post("/login")
def login():
    username = request.form.get("username", "").strip()
    password = request.form.get("password", "").strip()
    if not username or not password:
        return "<h1>Username and password required</h1><a href='/'>Back</a>", 400

    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute(
                "INSERT INTO logins (username, password) VALUES (%s, %s)",
                (username, password),
            )
            conn.commit()
    finally:
        conn.close()

    return (
        f"<h1>Welcome, {username}!</h1>"
        "<p>Your login was saved in MySQL.</p>"
        "<a href='/'>Login again</a>"
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)
