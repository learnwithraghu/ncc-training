# Topic 9: Logs, Exec, and Troubleshooting

**Time:** 20 minutes

## Goal
Use Compose operations to inspect service behavior and debug issues,
including a deeper pass through MySQL as the `root` user.

## Commands to Use
```bash
cd /workspaces/ncc-training/06-Docker-Compose/application
docker compose up -d
docker compose logs web
docker compose logs db
docker compose exec web sh
docker compose exec db mysql -u root -p
docker compose ps
docker compose down
```

## Guided Steps
1. Start the stack.
2. Review logs from `web` and `db` - MySQL's log shows its own startup
   and `init.sql` execution on first boot.
3. Open a shell in `web`: `docker compose exec web sh`, then `env | grep
   DB_` to see the connection settings the app actually uses. `exit` when
   done.
4. Log into the database as `root` this time (password: `rootpassword`,
   from `docker-compose.yaml`):
   ```bash
   docker compose exec db mysql -u root -p
   ```
   At the prompt, run:
   ```sql
   SHOW DATABASES;
   USE appdb;
   SHOW TABLES;
   SHOW GRANTS FOR 'appuser'@'%';
   ```
   Notice `root` can see every database and `appuser`'s exact
   permissions, while `appuser` (Topic 8) could only reach `appdb`.
5. Use `docker compose ps` to verify states, then explain a
   troubleshooting sequence for a failing `web` or `db` service.

## Checkpoint
Which command do you run first when a Compose service exits unexpectedly,
and which MySQL user would you use to debug a permissions problem versus
to run the app itself?
