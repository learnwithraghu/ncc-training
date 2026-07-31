# Step 02: Dockerize the Application

## Goal
Write a Dockerfile for the document-search app and understand how this lab **bakes secrets into the image**.

## Time
Approximately **20 minutes**.

## What You Brought Forward From Step 01

```text
02-dockerize/
├── guide.md
├── app.py
├── requirements.txt
├── .env_example
├── .gitignore
├── Dockerfile          ← new
└── .dockerignore       ← new
```

If you just arrived here, copy your filled `.env` from Step 01:

```bash
cp ../01-application-overview/.env ./.env
```

Or create it again:

```bash
cp .env_example .env
# edit .env with real values
```

---

## Tutor Talk: What Is a Dockerfile?

A Dockerfile is a recipe. Docker reads it top to bottom and produces an **image**. The image is a frozen snapshot of:

- a base OS / language runtime
- your installed dependencies
- your application files
- (in this lab) your `.env` secrets file

Later you will run that image as a **container**.

---

## Step-by-Step: Build the Dockerfile Mentally

Open `Dockerfile` and walk each line with your tutor:

1. **`FROM --platform=linux/amd64 python:3.11-slim`**  
   Start from a slim Python image. Force `linux/amd64` so the same image works on ECS Fargate (x86_64), even if you build on an Apple Silicon Mac.

2. **`WORKDIR /app`**  
   Set the working directory inside the image.

3. **`COPY requirements.txt` + `pip install`**  
   Install dependencies in their own layer so rebuilds are faster when only app code changes.

4. **`COPY app.py .`**  
   Add the application source.

5. **`COPY .env .env`**  
   Bake secrets into the image (explained next).

6. **`EXPOSE 5000`**  
   Document the port the process listens on.

7. **`CMD ["python", "app.py"]`**  
   Default process when a container starts.

---

## Secrets in This Lab: Bake Into the Image

### What we are doing
For this classroom capstone we **copy `.env` into the image** at build time:

```dockerfile
COPY .env .env
```

When the container starts, `python-dotenv` loads that file and the app can read `LLM_API_KEY`, `LLM_MODEL`, and AWS-related values.

### What we are NOT doing
We will **not** use AWS Secrets Manager, SSM Parameter Store, or ECS secret injection in this module. Those are better for production, but they add IAM and console complexity. Your tutor is keeping the path short:

```text
fill .env → docker build (bakes .env) → push image → run on ECS
```

### Honest trade-off (say this out loud)
Baking secrets into an image means **anyone who can pull the image can extract the secrets**. That is acceptable only for a supervised lab with disposable keys. In production you would inject secrets at runtime and never commit or bake them.

### Practical rules for class
- Keep a real `.env` on your laptop only.
- Never push `.env` to GitHub (`.gitignore` already blocks it).
- Rebuild the image if you rotate keys.
- Treat lab images as temporary; delete them from ECR after class if asked.

---

## `.dockerignore`

This file keeps junk out of the build context. Notice we **do not** ignore `.env` here, because the Dockerfile must be able to `COPY` it.

---

## Hands-On Checklist (No Build Yet)

You do **not** need to run `docker build` in this folder yet. That is the next step. Before you leave:

1. Confirm `Dockerfile` exists and includes `COPY .env .env`
2. Confirm `.env` exists next to the Dockerfile (filled values)
3. Confirm `.dockerignore` does not list `.env`

---

## Checkpoint

1. Why do we set `--platform=linux/amd64`?
2. Why does this lab bake `.env` instead of using Secrets Manager?
3. What is the main security downside of baking secrets into an image?

## Next Step

Go to **[03-local-image-test](../03-local-image-test/)** — same files, plus commands to **build** and **test** the image on your machine.
