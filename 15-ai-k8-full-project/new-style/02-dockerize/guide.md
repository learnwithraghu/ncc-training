# Topic 2: Dockerize

**Time:** ~20 minutes

## What You'll Learn

1. Write a slim Python Dockerfile for Streamlit.
2. Bake classroom `.env` into the image on purpose.
3. Use a health check on `/_stcore/health`.

## Goal

Have a Dockerfile ready to build. You do **not** build yet — that is
topic 03.

## Commands

```bash
cp ../../.env .env
cat Dockerfile
cat .dockerignore
```

## Guided Steps

1. `cd` into this folder and bring secrets:

```bash
cd ~/ncc-training/15-ai-k8-full-project/new-style/02-dockerize
cp ../../.env .env
```

2. Open `Dockerfile` and walk the layers:

   - `FROM python:3.12-slim` — small base image.
   - Install `curl` for the HEALTHCHECK.
   - `COPY requirements.txt` then `pip install`.
   - `COPY app.py` and **`COPY .env .env`** — bake secrets for class.
   - `EXPOSE 8501` and Streamlit `CMD`.

3. Open `.dockerignore`. It keeps `guide.md` out of the build context.
   It does **not** ignore `.env` — the bake step needs that file.

## Secrets in This Lab: Bake Into the Image

```dockerfile
COPY .env .env
```

We do **not** use Kubernetes Secrets or a vault here. Anyone who can
pull the image can extract the key. Use disposable classroom keys only.

## Task

Confirm `.env` sits next to the Dockerfile, `Dockerfile` copies it, and
port **8501** is exposed with a HEALTHCHECK.

## Checkpoint

1. Why bake `.env` instead of mounting it at runtime in this class?
2. What process listens on 8501?
3. What URL path does the HEALTHCHECK call?

## What's Next?

Build the image, run it, and curl health + the homepage.
**Topic 3: Build and Run.**
