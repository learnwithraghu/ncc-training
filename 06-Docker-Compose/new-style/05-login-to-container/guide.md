# 05: Login to a Container

**Time:** ~10 minutes

## Goal
Open a shell inside a running Compose container. This is how you "log in" to a container to look around.

Work only in this folder (or keep using a previous stage's running stack).

## Commands to Teach

```bash
cd ~/ncc-training/06-Docker-Compose/new-style/05-login-to-container
docker compose up -d --build
docker compose ps
docker compose exec web sh
docker compose exec db bash
```

- `docker compose exec <service> sh` (or `bash`) opens an interactive shell in that service's container.
- `-it` is implied by Compose when you attach to a shell this way.
- `exit` leaves the container shell. The container keeps running.

## Guided Steps

1. Stop any earlier stage stack if it still holds port 5000, then start this one:

```bash
cd ~/ncc-training/06-Docker-Compose/new-style/04-login-and-save
docker compose down

cd ~/ncc-training/06-Docker-Compose/new-style/05-login-to-container
docker compose up -d --build
docker compose ps
```

You should see `web` and `db` running.

2. Log in to the **web** (Python) container:

```bash
docker compose exec web sh
```

Inside the container:

```bash
hostname
pwd
ls
python --version
exit
```

You are now on the host again. The `web` container is still up.

3. Log in to the **db** (MySQL) container:

```bash
docker compose exec db bash
```

Inside:

```bash
hostname
which mysql
mysql --version
exit
```

Next stage you will use this same idea to open the MySQL client and `SELECT` from `logins`.

Leave the stack running for stage 06, or stop it if you are done for now:

```bash
# optional
# docker compose down
```

## Task

`exec` into both `web` and `db`, run `hostname` in each, then `exit`. Tell the instructor which service you were inside.

## Checkpoint
Does `docker compose exec web sh` start a new container, or open a shell in the one that is already running?
