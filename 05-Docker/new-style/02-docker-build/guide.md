# 02: Docker Build

**Time:** ~20 minutes

## Goal
Read the sample Dockerfile and master `docker build` so you can turn application source into a local image on EC2.

## Commands to Teach

```bash
cd ~/ncc-training/05-Docker/application
vi Dockerfile
docker build -t ncc-training-app:1.0 .
docker images
```

- `cd` puts you in the build context. The `.` at the end of `docker build` is this directory.
- `vi Dockerfile` is how you read the recipe before you build it.
- `docker build -t name:tag .` is the command you will reuse for the rest of this module.
- `docker images` confirms the image exists locally after the build.

## Guided Steps

1. Go to the sample app on the EC2 instance:

```bash
cd ~/ncc-training/05-Docker/application
ls
```

You should see `Dockerfile`, `app.py`, `requirements.txt`, and `.dockerignore`.

2. Open the Dockerfile and walk through it:

```bash
vi Dockerfile
```

Notice the base image (`python:3.11-slim`), the copy of `requirements.txt` before app code, the non-root user, and the `HEALTHCHECK`.

3. Build the image. The tag is a name you choose; we start with `ncc-training-app:1.0`:

```bash
docker build -t ncc-training-app:1.0 .
```

The trailing `.` is the build context. Docker sends this directory to the daemon and follows `Dockerfile` in it.

4. Confirm the image is on this EC2 host:

```bash
docker images
docker images | grep ncc-training-app
```

5. Build a second time without changing files. Layers that did not change should come from cache. That is why `docker build` is fast after the first successful run.

## Task

From `05-Docker/application` on EC2, build the sample app with your own tag, for example `ncc-training-app:student`. Use `docker images` to prove the tagged image exists. Then change a comment in the Dockerfile, rebuild the same tag, and explain which layers were reused from cache.

## Checkpoint
Why does `docker build` need both a tag (`-t`) and a build context (`.`)?
