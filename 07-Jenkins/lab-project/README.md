# Jenkins Lab Project

This is a tiny sample project used in the NCC Jenkins module.

It contains a small shell script, a test, and a `Jenkinsfile` so learners can practice:

- Freestyle jobs
- Declarative pipelines
- Gitea integration
- Build-on-push webhooks

## Files

- `app.sh` — prints a greeting and the build number
- `run.sh` — runs `app.sh` and saves the output
- `test.sh` — checks that the output is correct
- `Jenkinsfile` — declarative pipeline used in the Jenkins lessons

## Run locally

```bash
./run.sh
./test.sh
```
