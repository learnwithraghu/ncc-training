# 03: Start the Stack

**Time:** ~15 minutes

## Goal
Start the Python login UI and MySQL together with one Compose command. Open the login page on port 5000.

Work only in this folder.

## Commands to Teach

```bash
cd ~/ncc-training/06-Docker-Compose/new-style/03-start-the-stack
docker compose up -d --build
docker compose ps
curl http://127.0.0.1:5000
```

- `docker compose up -d --build` builds the web image and starts `web` + `db` in the background.
- `docker compose ps` shows both services.
- `curl` proves the login HTML is reachable.

## Guided Steps

1. Open this stage folder:

```bash
cd ~/ncc-training/06-Docker-Compose/new-style/03-start-the-stack
ls
```

2. Start the stack:

```bash
docker compose up -d --build
```

The first run downloads MySQL and builds the Python image. Wait until it finishes.

3. Check both services are up:

```bash
docker compose ps
docker compose logs --tail=20
```

You should see `web` and `db`. If MySQL is still starting, wait a few seconds and check again.

4. Hit the login page from the host:

```bash
curl http://127.0.0.1:5000
```

You should see HTML that includes `<h1>Login</h1>`.

5. In a browser (if the host is reachable), open:

```text
http://<HOST_IP>:5000
```

Leave the stack running for the next stages. Do not run `docker compose down` yet.

## Task

Start the stack from this folder and prove the login page responds on port 5000 with `curl` or a browser.

## Checkpoint
What single command starts both the Python UI and MySQL?
