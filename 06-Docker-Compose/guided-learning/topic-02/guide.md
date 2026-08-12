# Topic 2: Compose File Structure Walkthrough

**Time:** 20 minutes

## Goal
Read the Compose file and understand service definitions.

## Commands to Use
```bash
cd /workspaces/ncc-training/06-Docker-Compose/application
vi docker-compose.yaml
```

## Guided Steps
1. Open `docker-compose.yaml` in `vi`.
2. Find the `web` and `db` services.
3. Review `build`, `ports`, `volumes`, `depends_on`, and `healthcheck` on
   each.
4. Explain what the `db_data` named volume stores, and why it's only
   attached to `db`.
5. Compare the two `environment:`/`env_file:` blocks: `web` loads
   `.env.example` (`DB_HOST`, `DB_USER`, `DB_PASSWORD`, ...), but `db`
   sets its own variables directly (`MYSQL_ROOT_PASSWORD`,
   `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD`) with the *same*
   values, spelled the official MySQL image's way. Explain why one file
   can't just feed both sides - the app and the MySQL image agree on
   different variable names for the same information.

## Checkpoint
Why does the `db` service need its own copy of the database credentials
instead of reusing `.env.example` directly?
