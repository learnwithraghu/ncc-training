# 04: Login and Save

**Time:** ~10 minutes

## Goal
Use the login page. Compose writes the username and password into the MySQL `logins` table.

If the stack from stage 03 is still running in that folder, stop it first so only one stack uses port 5000. Then start this folder's copy.

## Commands to Teach

```bash
cd ~/ncc-training/06-Docker-Compose/new-style/03-start-the-stack
docker compose down

cd ~/ncc-training/06-Docker-Compose/new-style/04-login-and-save
docker compose up -d --build
curl -X POST http://127.0.0.1:5000/login -d "username=intern&password=secret123"
```

## Guided Steps

1. Stop the previous stage stack if it is still up:

```bash
cd ~/ncc-training/06-Docker-Compose/new-style/03-start-the-stack
docker compose down
```

2. Start this folder's stack:

```bash
cd ~/ncc-training/06-Docker-Compose/new-style/04-login-and-save
docker compose up -d --build
docker compose ps
```

Wait until `web` and `db` are running. Give MySQL ~20 seconds on first start.

3. Open the login page in a browser:

```text
http://<HOST_IP>:5000
```

Or stay in the terminal and submit a login with `curl`:

```bash
curl -X POST http://127.0.0.1:5000/login \
  -d "username=intern" \
  -d "password=secret123"
```

You should see a welcome message that says the login was saved in MySQL.

4. Submit one more login (different username) so the table has more than one row:

```bash
curl -X POST http://127.0.0.1:5000/login \
  -d "username=raghu" \
  -d "password=demo"
```

Leave the stack running for stage 05.

## Task

Submit at least one login from the browser or with `curl`, and confirm you get the welcome page.

## Checkpoint
When you click Login, which service writes the row — `web` or `db`? Which service stores it?
