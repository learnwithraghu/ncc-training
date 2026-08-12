# Topic 10: Service Scaling Patterns

**Time:** 20 minutes

## Goal
Try to scale a service and learn from what breaks - this Compose file
only has one stateless service (`web`) and one stateful service (`db`),
and neither scales the way you might first expect.

## Commands to Use
```bash
cd /workspaces/ncc-training/06-Docker-Compose/application
docker compose up -d
docker compose up -d --scale web=3
docker compose ps
docker compose up -d --scale web=1
docker compose down
```

## Guided Steps
1. Start the default stack (one `web`, one `db`).
2. Try to scale `web` to three instances: `docker compose up -d --scale
   web=3`. Read the error - it fails because `ports: ["5000:5000"]`
   tries to bind host port 5000 three times.
3. Explain the fix in words (don't apply it): remove the fixed host port
   and either publish an ephemeral port per replica, or put a reverse
   proxy/load balancer in front - scaling a stateless service still needs
   something to route traffic across the replicas.
4. Scale back to `web=1` and confirm the stack is healthy again.
5. Discuss `db`: even if you *could* run three MySQL containers, they
   wouldn't share `db_data` or agree on writes - `db` isn't a candidate
   for `--scale` at all without real database replication.

## Checkpoint
What type of service is usually safest to scale with `--scale`, and what
has to exist in front of it for scaling to actually work?
