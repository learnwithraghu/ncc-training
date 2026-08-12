# 02: Write the Stack

**Time:** ~15 minutes

## Goal
Walk the files that make the demo: a Python login page, a MySQL table, and a `docker-compose.yaml` that clubs them together.

Work only in this folder. It has its own copy of every file.

## Commands to Teach

```bash
cd ~/ncc-training/06-Docker-Compose/new-style/02-write-the-stack
ls
cat docker-compose.yaml
```

## Files in this folder

| File | Role |
|------|------|
| `app.py` | Flask login page. On submit, inserts username + password into MySQL |
| `Dockerfile` | Builds the Python web image |
| `docker-compose.yaml` | Clubs `web` + `db` in one stack |
| `init.sql` | Creates the `logins` table the first time MySQL starts |
| `requirements.txt` | Flask + PyMySQL |

## Guided Steps

1. Open this stage folder:

```bash
cd ~/ncc-training/06-Docker-Compose/new-style/02-write-the-stack
ls
```

2. Read the Compose file:

```bash
cat docker-compose.yaml
```

Notice two services:

- `web` — builds from the local Dockerfile, publishes port **5000**
- `db` — uses `mysql:8.0`, creates database `appdb`, loads `init.sql`

`depends_on: db` tells Compose to start MySQL before the web app.

3. Peek at the login app and the table:

```bash
head -n 20 app.py
cat init.sql
```

The table is simple:

```sql
CREATE TABLE IF NOT EXISTS logins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    password VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

Demo only: passwords are stored in plain text so you can see them with `SELECT`. Never do this in production.

## Task

Point to the two service names in `docker-compose.yaml` (`web` and `db`) and say which one is the login UI.

## Checkpoint
Which Compose key clubs the Python UI and MySQL into one stack file?
