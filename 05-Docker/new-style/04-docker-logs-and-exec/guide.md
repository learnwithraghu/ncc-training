# 04: Docker Logs and Exec

**Time:** ~20 minutes

## Goal
Read container logs and open a shell inside the running container so you can debug what you built.

## Commands to Teach

```bash
docker logs appdemo
docker logs -f appdemo
docker exec -it appdemo sh
docker rm -f appdemo
```

- `docker logs` prints stdout and stderr from the container process.
- `docker logs -f` follows new log lines the same way `tail -f` follows a file.
- `docker exec -it … sh` opens an interactive shell in the already-running container.
- `docker rm -f` force-removes a container in one step (stop + delete).

## Guided Steps

1. Build and start the sample app if it is not already running:

```bash
cd ~/ncc-training/05-Docker/application
docker build -t ncc-training-app:1.0 .
docker rm -f appdemo 2>/dev/null || true
docker run -d --name appdemo -p 5000:5000 ncc-training-app:1.0
```

2. Generate some log lines, then read them:

```bash
curl http://127.0.0.1:5000/
curl http://127.0.0.1:5000/health
docker logs appdemo
```

3. Follow logs live. In one terminal run:

```bash
docker logs -f appdemo
```

In a second SSH session, curl the app again and watch the new lines appear. Stop following with `Ctrl+C`.

4. Open a shell inside the container:

```bash
docker exec -it appdemo sh
```

Inside the container, try:

```bash
id
printenv
ps
exit
```

You should see the non-root `appuser` from the Dockerfile.

5. Clean up:

```bash
docker rm -f appdemo
```

## Task

Build and run `ncc-training-app:1.0` as `appdemo`. Curl `/` and `/health`, read the logs, exec into the container, and find the value of `ENVIRONMENT`. Then remove the container with `docker rm -f`.

## Checkpoint
When a container is running but the HTTP response looks wrong, why do you usually start with `docker logs` before `docker exec`?
