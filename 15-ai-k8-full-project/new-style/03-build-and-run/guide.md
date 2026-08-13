# Topic 3: Build and Run

**Time:** ~20 minutes

## What You'll Learn

1. `docker build` a tagged Daypack image.
2. Run it on host port 8501.
3. Validate with curl (health + Streamlit HTML shell).

## Goal

Prove the container works on your laptop before you push to Docker Hub.

## Commands

```bash
cp ../../.env .env
docker rm -f daypack 2>/dev/null || true
docker build -t daypack:1.0 .
docker run -d --name daypack -p 8501:8501 daypack:1.0
curl -fsS http://127.0.0.1:8501/_stcore/health
curl -fsS http://127.0.0.1:8501 | grep -o Streamlit
```

Streamlit renders **Daypack** in the browser via JavaScript. A plain
`curl` only sees the HTML shell (`Streamlit` in the title) — that is
enough to prove the container is serving the UI.

## Guided Steps

1. Bring secrets and clean any old container:

```bash
cd ~/ncc-training/15-ai-k8-full-project/new-style/03-build-and-run
cp ../../.env .env
docker rm -f daypack 2>/dev/null || true
```

2. Build:

```bash
docker build -t daypack:1.0 .
```

3. Run and wait a few seconds for Streamlit to start:

```bash
docker run -d --name daypack -p 8501:8501 daypack:1.0
sleep 8
curl -fsS http://127.0.0.1:8501/_stcore/health
curl -fsS http://127.0.0.1:8501 | grep -o Streamlit
```

4. Open `http://localhost:8501` and generate one short trip plan.

5. Cleanup when you are done with this topic:

```bash
docker rm -f daypack
```

## Task

Health returns OK and the HTML shell contains `Streamlit`. The browser
shows **Daypack** and plans a trip using the baked `.env`.

## Checkpoint

If port 8501 is already in use, what do you check first —
`docker ps` or the Dockerfile?

## What's Next?

Tag the image for Docker Hub and push
`learnwithraghu/ai-k8-workshop:1.0`. **Topic 4: Tag and Push.**
