# 01: Meet Compose

**Time:** ~10 minutes

## Goal
Understand why Docker Compose exists: one YAML file that starts a Python UI and a MySQL database together.

## Why Compose

In the Docker module you ran **one** container at a time.

Real apps need more than one service:

- a **web UI** (Python / Flask)
- a **database** (MySQL)

Compose lets you club those services in one file: `docker-compose.yaml`.

```text
docker compose up
        |
        +---> web  (Python login page on port 5000)
        |
        +---> db   (MySQL storing login rows)
```

You do not run two long `docker run` commands. You start the whole stack with one command.

## Commands to Teach

```bash
docker compose version
cd ~/ncc-training/06-Docker-Compose/new-style
ls
```

- `docker compose version` proves the Compose plugin is installed.
- The numbered folders under `new-style/` are the stages for this demo.

## Guided Steps

1. Confirm Compose is available:

```bash
docker compose version
```

2. Open the module stages:

```bash
cd ~/ncc-training/06-Docker-Compose/new-style
ls
```

You should see:

```text
01-meet-compose
02-write-the-stack
03-start-the-stack
04-login-and-save
05-login-to-container
06-inspect-mysql
```

3. Read the demo story out loud:

- Stage 02 writes a Python login UI + MySQL + Compose file
- Stage 03 starts both services
- Stage 04 logs in and saves a row
- Stage 05 opens a shell inside the containers (`exec`)
- Stage 06 enters MySQL and `SELECT`s the table

## Task

Explain in one sentence: what two services does this Compose demo club together?

## Checkpoint
Why is Compose useful when an app needs both a UI and a database?
