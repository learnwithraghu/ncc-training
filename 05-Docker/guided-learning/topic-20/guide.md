# Topic 20: Docker Mini Workflow

**Time:** 20 minutes

## Goal
Combine the Docker concepts from this module into one short workflow.

## Commands to Use
```bash
cd /workspaces/ncc-training/05-Docker/application
vi Dockerfile
docker build -t ncc-training-app:final .
docker run -d --name appdemo -p 5000:5000 -v appdata:/app/data ncc-training-app:final
curl -X POST http://localhost:5000/write -H 'Content-Type: application/json' -d '{"message":"final workflow"}'
curl http://localhost:5000/read
docker rm -f appdemo
```

## Guided Steps
1. Build the application image.
2. Run it with a named volume.
3. Write data into the container through the app endpoint.
4. Read the saved data back.
5. Explain how this final workflow combines build, run, networking, and storage.

## Checkpoint
Which Docker concepts from this module did you use in the final workflow?
