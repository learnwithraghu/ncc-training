# Docker Compose New Style — Login UI + MySQL Demo

Work through these stages in order. Each practical stage folder is independent: it has its own `app.py`, `Dockerfile`, `docker-compose.yaml`, and `guide.md`.

The demo clubs a **Python login page** and **MySQL** in one Compose file. Login saves a row. You log into containers with `exec`, then open MySQL and `SELECT` the table.

## Recommended Flow

1. Open the stage folder.
2. Walk through the commands.
3. Complete the **Task**.
4. Answer the checkpoint before moving on.

## Stage List

| Folder | Focus |
|--------|-------|
| [01-meet-compose/](01-meet-compose/) | Why Compose clubs UI + DB together |
| [02-write-the-stack/](02-write-the-stack/) | Read `docker-compose.yaml`, Flask login, `init.sql` |
| [03-start-the-stack/](03-start-the-stack/) | `docker compose up -d --build` and open port 5000 |
| [04-login-and-save/](04-login-and-save/) | Submit login; row is stored in MySQL |
| [05-login-to-container/](05-login-to-container/) | `docker compose exec` — open a shell in `web` and `db` |
| [06-inspect-mysql/](06-inspect-mysql/) | MySQL client inside `db` and `SELECT` from `logins` |

## How each practical folder is laid out

```text
app.py               Flask login page (saves to MySQL)
Dockerfile           builds the web image
docker-compose.yaml  web + db services
init.sql             creates the logins table
requirements.txt     Flask + PyMySQL
.dockerignore        keeps guide.md out of the build
guide.md             commands, steps, task, checkpoint
```

## Demo Story

```text
Browser / curl  -->  web (Python)  -->  db (MySQL logins table)
                         ^                  ^
              compose exec web sh    compose exec db bash
                                            |
                                   compose exec db mysql ...
                                   SELECT * FROM logins;
```

## Scope Boundary

This is a short Compose demo only. No scaling, no env files, no production auth. Passwords are stored in plain text on purpose so students can see them with `SELECT`.
