# Step 02: Dockerize the Application

## Goal
Write a Dockerfile for the License Renewal Streamlit app and understand baking secrets into the image.

## Time
Approximately **20 minutes**.

## What You Brought Forward

```text
02-dockerize/
├── guide.md
├── requirements.txt
├── app/app.py
├── sample-documents/
├── Dockerfile          ← new
└── .dockerignore       ← new
```

Bring secrets forward:

```bash
cp ../01-application-overview/.env ./.env
# or: cp ../.env_example .env
```

---

## Tutor Talk: Dockerfile Walkthrough

Open `Dockerfile`:

1. **`FROM --platform=linux/amd64 python:3.11-slim`** — ECS Fargate compatible.
2. Install `gcc` and `curl` for dependency builds and health checks.
3. **`COPY requirements.txt` + `pip install`** — Streamlit, PDF, Excel, `requests`.
4. **`COPY app/ ./app/`** — application package.
5. **`COPY .env .env`** — bake secrets for this classroom lab.
6. **`EXPOSE 8501`** — Streamlit port.
7. **`CMD streamlit run app/app.py ...`** — start the UI.

## Secrets in This Lab: Bake Into the Image

```dockerfile
COPY .env .env
```

We **do not** use AWS Secrets Manager here. Anyone who can pull the image can extract secrets — acceptable only for supervised labs with disposable keys.

`.dockerignore` keeps `sample-documents/` and markdown out of the image, but **does not** ignore `.env` (the bake step needs it).

---

## Hands-On Checklist (No Build Yet)

1. Confirm `Dockerfile` copies `app/` and `.env`
2. Confirm `.env` exists beside the Dockerfile with real `LLM_*` values
3. Confirm port **8501** is exposed

## Checkpoint

1. Why `linux/amd64`?
2. Why bake `.env` instead of Secrets Manager in this class?
3. What process listens on 8501?

## Next Step

Go to **[03-local-image-test](../03-local-image-test/)** — build and test the image locally.
