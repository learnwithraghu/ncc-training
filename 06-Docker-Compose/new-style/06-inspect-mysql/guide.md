# 06: Inspect MySQL

**Time:** ~15 minutes

## Goal
After you can log into a container (stage 05), open a MySQL terminal inside `db`, select the database, and see the `logins` table rows from the login page.

Work in this folder. Start its stack (or keep using stage 05's stack if it is still up — pick one).

## Commands to Teach

```bash
cd ~/ncc-training/06-Docker-Compose/new-style/06-inspect-mysql
docker compose up -d --build
docker compose exec db mysql -u appuser -papppassword appdb
```

Inside MySQL:

```sql
SHOW TABLES;
SELECT * FROM logins;
EXIT;
```

## Guided Steps

1. If stage 05 is still running and you already practiced `exec` there, stay in that folder, submit a login if needed, and skip to step 3.

Otherwise start this folder's stack and submit one login first:

```bash
cd ~/ncc-training/06-Docker-Compose/new-style/05-login-to-container
docker compose down

cd ~/ncc-training/06-Docker-Compose/new-style/06-inspect-mysql
docker compose up -d --build
```

Wait for MySQL, then save a row:

```bash
curl -X POST http://127.0.0.1:5000/login \
  -d "username=intern" \
  -d "password=secret123"
```

2. List Compose containers and find `db`:

```bash
docker compose ps
```

3. Enter the MySQL container and open the MySQL client:

```bash
docker compose exec db mysql -u appuser -papppassword appdb
```

Notes:

- `docker compose exec db` runs a command inside the `db` service container (same idea as stage 05's shell login)
- `mysql -u appuser -papppassword appdb` opens MySQL as `appuser` on database `appdb`
- There is no space between `-p` and the password

4. Inside the MySQL prompt, inspect the table:

```sql
SHOW TABLES;
DESCRIBE logins;
SELECT id, username, password, created_at FROM logins;
```

You should see the usernames and passwords from the login page.

5. Leave MySQL and stop the demo stack:

```sql
EXIT;
```

```bash
docker compose down
```

## Task

`exec` into the `db` container, open MySQL, run `SELECT * FROM logins;`, and show the instructor the rows from your login demo.

## Checkpoint
Which command puts you inside the MySQL container so you can run `SELECT`?
