# 04: Docker Logs and Exec

**Time:** ~20 minutes

## Goal
Read nginx logs and open a shell inside the running Aether Launch container.

Work only in this folder. It has its own `index.html` and `Dockerfile`.

## Commands to Teach

```bash
docker logs aether-web
docker logs -f aether-web
docker exec -it aether-web sh
docker rm -f aether-web
```

- `docker logs` prints nginx access and error output.
- `docker logs -f` follows new requests.
- `docker exec -it … sh` opens a shell in the already-running container.
- `docker rm -f` force-removes the container so the next topic can reuse the name `aether-web` and port 8080.

## Guided Steps

1. Start clean, then build and run from this folder:

```bash
cd ~/ncc-training/05-Docker/new-style/04-docker-logs-and-exec
docker rm -f aether-web 2>/dev/null || true
docker container prune -f
docker build -t aether-launch:1.0 .
docker run -d --name aether-web -p 8080:80 aether-launch:1.0
```

2. Generate a request, then read logs:

```bash
curl -sS -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8080
docker logs aether-web
```

3. Follow logs live (`Ctrl+C` to stop). In a second SSH session, curl again:

```bash
docker logs -f aether-web
```

4. Exec into the container and find the baked page:

```bash
docker exec -it aether-web sh
```

Inside:

```bash
ls /usr/share/nginx/html
grep -o "Aether Launch" /usr/share/nginx/html/index.html
which curl
exit
```

`curl` is there because the Dockerfile ran `apk add --no-cache curl`.

5. Clean up so the next topic can reuse `aether-web` and port 8080:

```bash
docker rm -f aether-web
docker container prune -f
docker ps -a
```

## Cleanup

If `docker run` fails with **name already in use** or **port is already allocated**, or when you finish this topic:

```bash
docker rm -f aether-web 2>/dev/null || true
docker container prune -f
docker ps -a
```

If `docker exec` says the container is not running, start it again with the `docker run` in step 1.

If port 8080 is still busy:

```bash
docker ps --format 'table {{.Names}}\t{{.Ports}}'
docker rm -f <NAME>
```

## Task

Build and run `aether-launch:1.0` from this folder. Curl the page, read logs, exec in, and confirm `index.html` contains **Aether Launch**. Then `docker rm -f aether-web`.

## Checkpoint
When the page looks wrong in the browser, why do you usually start with `docker logs` before `docker exec`?
