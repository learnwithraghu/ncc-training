# Daypack New Style — AI Trip Planner on a Cluster

Work through these topics in order. Each folder has its own files and
`guide.md`. You do not need files from a previous folder (later Docker
folders already include the app).

The workload is **Daypack**, a Streamlit trip planner that calls a
KodeKloud OpenAI-compatible API via LangChain.

- `learnwithraghu/ai-k8-workshop:1.0` — Daypack on port 8501

## Instructor prerequisite

Before class, on a laptop with Docker and a filled module-root `.env`:

```bash
cd ~/ncc-training/15-ai-k8-full-project
docker login -u learnwithraghu
bash new-style/helpers/build-and-push.sh
```

On the teaching cluster host (kubectl only):

```bash
git clone https://github.com/learnwithraghu/ncc-training.git
cd ncc-training
bash 15-ai-k8-full-project/new-style/helpers/deploy-k8s.sh
```

That script applies topics 05–06 in namespace `daypack`, waits for Ready,
validates health via a short port-forward, then prints the command to open
the UI.

## Recommended Flow

1. Open the topic folder.
2. Read **What You'll Learn**.
3. Run the commands in **Guided Steps**.
4. Complete the **Task** and **Checkpoint**.
5. Read **What's Next?** and go to the next folder.

## Topic List

| Folder | Focus |
|--------|-------|
| [01-meet-the-app/](01-meet-the-app/) | Local Streamlit + LangChain |
| [02-dockerize/](02-dockerize/) | Dockerfile, bake `.env` |
| [03-build-and-run/](03-build-and-run/) | `docker build`, run, curl |
| [04-tag-and-push/](04-tag-and-push/) | Tag and push to Hub |
| [05-k8s-deployment/](05-k8s-deployment/) | Namespace + Deployment |
| [06-k8s-service/](06-k8s-service/) | Service + port-forward |

## Scope

Build an AI Docker image end to end and run it on Kubernetes. No Ingress,
Helm, volumes, or Secrets Manager — keys are baked into the image for class.
