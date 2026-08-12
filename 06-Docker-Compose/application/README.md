# Docker Compose Training App

This application is used by the guided learning in the `06-Docker-Compose` module.
It's a small Flask API backed by MySQL — two services, one Compose file.

## Services

- `web`: Flask API
- `db`: MySQL 8.0

## Endpoints

- `GET /` - app info
- `GET /health` - health status (includes database connectivity)
- `POST /items` - insert a row (`{"name": "..."}`)
- `GET /items` - list rows

## Quick Start

```bash
cd /workspaces/ncc-training/06-Docker-Compose/application
docker compose up -d --build
until curl -fsS http://localhost:5000/health; do sleep 1; done
curl -X POST http://localhost:5000/items -H 'Content-Type: application/json' -d '{"name":"demo"}'
curl http://localhost:5000/items
docker compose down
```

## Log Into the DB Container and Run MySQL Commands

```bash
docker compose exec db mysql -u appuser -p appdb
# password: apppassword (from docker-compose.yaml)
```

Then at the `mysql>` prompt:

```sql
SHOW TABLES;
SELECT * FROM items;
DESCRIBE items;
```

## Notes

- `db` data is persisted in the `db_data` volume - it survives
  `docker compose down` (without `-v`) and comes back on the next `up`.
- `init.sql` is mounted into `/docker-entrypoint-initdb.d/` and only runs
  the *first* time the `db_data` volume is created (creates the `items`
  table and seeds two rows).
- The `db` service's `environment:` block uses MySQL's own variable names
  (`MYSQL_ROOT_PASSWORD`, `MYSQL_DATABASE`, ...), which are **not** the
  same names the app reads from `.env.example` (`DB_NAME`, `DB_USER`, ...)
  - both sides are kept in sync by hand, on purpose. See Topic 2's guide.
