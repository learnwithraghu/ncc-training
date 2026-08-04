# Jenkins Lab Project

This is a tiny sample project used in the NCC Jenkins module.

It contains a small shell script, a test, and a `Jenkinsfile` so learners can practice:

- Freestyle jobs
- Declarative pipelines
- Interactive pipeline input
- Gitea integration
- Local Docker image builds
- Build-on-push webhooks

## Files

- `app.sh` — prints a greeting and the build number
- `run.sh` — runs `app.sh` and saves the output
- `test.sh` — checks that the output is correct
- `Jenkinsfile` — declarative pipeline used in the Jenkins lessons
- `docker-example/Dockerfile` — small image used by the Docker build lesson
- `docker-example/Jenkinsfile` — pipeline used to build the image
- `docker-example/README.md` — Docker example notes

## Run locally

```bash
./run.sh
./test.sh
```

The Docker example is built by Jenkins in Topic 12. It is intentionally built locally and is not pushed to a registry.
