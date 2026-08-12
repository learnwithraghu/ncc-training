# Day 3, Part 2: Docker Compose

This module is a short demo: club a **Python login UI** and a **MySQL database** in one `docker-compose.yaml`.

You start both services with Compose, submit a login, then enter the MySQL container and `SELECT` the saved rows.

## What You Will Learn

By the end of this module, you will be able to:

- Explain why Compose is useful for multi-service apps
- Read a simple `docker-compose.yaml` with `web` + `db`
- Start the stack with `docker compose up -d --build`
- Use a login page that stores data in MySQL
- `exec` into the MySQL container and query the table

## Time Estimate

Approximately **1 hour** total, split into 5 named stages.

## Prerequisites

- Completion of [05-Docker](../05-Docker/README.md)
- Docker Engine and Compose plugin (`docker compose version`)
- Free host port **5000**

See [demo-infra-requirement.md](demo-infra-requirement.md) for the checklist.

## Guided Stages

Each practical stage folder in `new-style/` is independent. It includes the app files and a `guide.md`.

| Stage | Folder | Focus |
|-------|--------|-------|
| 01 Meet Compose | [new-style/01-meet-compose/](new-style/01-meet-compose/) | Why Compose clubs UI + DB |
| 02 Write the Stack | [new-style/02-write-the-stack/](new-style/02-write-the-stack/) | Compose file, Flask login, `init.sql` |
| 03 Start the Stack | [new-style/03-start-the-stack/](new-style/03-start-the-stack/) | `compose up` and open the login page |
| 04 Login and Save | [new-style/04-login-and-save/](new-style/04-login-and-save/) | Submit login; save to MySQL |
| 05 Inspect MySQL | [new-style/05-inspect-mysql/](new-style/05-inspect-mysql/) | `exec` into MySQL and `SELECT` |

## Getting Started

```bash
cd ~/ncc-training/06-Docker-Compose/new-style/01-meet-compose
```

Follow [new-style/README.md](new-style/README.md) for the full stage order.

## Sample App

- **web** — Flask login page on port **5000**
- **db** — MySQL 8 with database `appdb` and table `logins`

Demo only: passwords are stored in plain text so you can see them with `SELECT`. Never do this in production.

## Tips for Success

- `cd` into the stage folder you are teaching before running Compose
- Only one stack should use port 5000 at a time — `docker compose down` in the previous folder first
- Give MySQL ~20 seconds on first start before logging in

## Getting Help

1. Open the stage `guide.md` in `new-style/`
2. Check services: `docker compose ps`
3. Check logs: `docker compose logs`

```bash
docker compose --help
docker compose up --help
docker compose exec --help
```
