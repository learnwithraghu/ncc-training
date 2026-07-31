# Step 01: Application Overview

## Goal
Meet the document-search application, understand its files, and prepare your local secrets file.

## Time
Approximately **15 minutes**.

## What You Are Learning
Before Docker or AWS, a tutor always starts with the **application itself**. If you do not know what the app needs to run, you cannot package or deploy it safely.

---

## Folder Contents

You are working in:

```text
01-application-overview/
├── guide.md           ← you are here
├── app.py             ← Flask web API
├── requirements.txt   ← Python dependencies
├── .env_example       ← safe template (committed)
└── .gitignore         ← keeps real .env out of git
```

## Walkthrough: What Each File Does

### `app.py`
A small Flask API with two routes:

| Route | Purpose |
|-------|---------|
| `GET /` | Confirms the app is running and shows `LLM_MODEL` / `AWS_REGION` |
| `GET /health` | Simple health check for later Docker and ECS checks |

It loads variables with `python-dotenv` so local `.env` values appear in the process environment.

### `requirements.txt`
Lists Python packages. Today that is Flask and python-dotenv. Later steps keep this file as-is unless the app grows.

### `.env_example`
A **template** with placeholder values. Safe to commit. It documents every variable the app and later AWS steps need:

- AWS CLI credentials and region
- LLM key and model name
- ECR repository name and account ID

### `.gitignore`
Blocks `.env` from being committed. Real keys stay on your machine only.

---

## Hands-On: Prepare Your Secrets File

1. Open a terminal in this folder:

```bash
cd 11-Capstone-Document-Search/01-application-overview
```

2. Copy the template:

```bash
cp .env_example .env
```

3. Edit `.env` and replace every placeholder with your real values.

4. Confirm `.env` is ignored by git:

```bash
git check-ignore -v .env || echo "If this prints nothing outside a git repo, that is OK for class copies"
```

## Optional: Run the App Without Docker

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python app.py
```

In another terminal:

```bash
curl http://localhost:5000/
curl http://localhost:5000/health
```

Stop the app with `Ctrl+C` when finished.

---

## Checkpoint

Answer before moving on:

1. Which file is safe to commit — `.env` or `.env_example`?
2. What does `/health` return, and why will that matter for ECS later?
3. Name three categories of values stored in `.env_example`.

## Next Step

When you finish, go to **[02-dockerize](../02-dockerize/)** — same application code, plus a Dockerfile. That step also explains **baking secrets into the image** for this classroom lab (we will not use AWS Secrets Manager here).
