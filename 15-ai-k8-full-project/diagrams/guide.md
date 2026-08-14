# Rebuild the Daypack architecture diagram

Use this when you change the architecture picture. The PNG is already in
`images/architecture.png` so class does not need Graphviz.

The Python `diagrams` package draws AWS, Docker, and Kubernetes icons.
It needs **Graphviz** on the host, plus a local virtualenv (do not commit `.venv`).

## Once on this machine

macOS:

```bash
brew install graphviz
dot -V
```

Linux (Debian/Ubuntu):

```bash
sudo apt-get update
sudo apt-get install -y graphviz
dot -V
```

You need Python 3.10+ (`python3 --version`).

## Recreate the venv and generate the PNG

From the repo root:

```bash
cd 15-ai-k8-full-project/diagrams
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python generate_architecture.py
deactivate
```

Confirm the file updated:

```bash
ls -l ../images/architecture.png
```

On Windows PowerShell, replace the activate line with:

```powershell
.\.venv\Scripts\Activate.ps1
```

## What the picture shows

Left to right: **Build → Ship → Run**.

- **Build on EC2** — Daypack source, `docker build`. Today's lab still `COPY .env` here.
- **Ship** — Docker Hub `ai-k8-workshop:1.0`
- **Run on Kubernetes** — Namespace `daypack` is the cluster, not a box. Deployment (1 replica), Pod `:8501` with probes, ClusterIP, classroom `port-forward` (no Ingress)
- **KodeKloud AI** — HTTPS from the Pod to `/v1` with `deepseek-v4-flash`
- **Dashed box** — AWS Secrets Manager. Not wired in today's lab. That is the production-shaped secret store.

Do not change the Dockerfile from this guide.

## Edit the picture

1. Change `generate_architecture.py`.
2. Recreate or reuse the venv (`source .venv/bin/activate`).
3. Run `python generate_architecture.py`.
4. Commit `images/architecture.png` and the script. Leave `.venv` untracked.
