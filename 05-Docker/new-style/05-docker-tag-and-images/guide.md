# 05: Image Names and Tagging Convention

**Time:** ~20 minutes

## Goal
Name images the way registries expect: `name:version`, extra tags like `:latest`, and the ECR URI shape you will push next.

Work only in this folder. It has its own `index.html` and `Dockerfile`.

## Commands to Teach

```bash
docker build -t aether-launch:1.0 .
docker tag aether-launch:1.0 aether-launch:latest
docker tag aether-launch:1.0 aether-launch:1.0.0
docker images | grep aether-launch
```

- Image name: lowercase, hyphenated, no spaces — `aether-launch`.
- Version tag: `1.0` or `1.0.0`. Prefer a version over using only `latest`.
- `docker tag` adds another name to the same IMAGE ID. It does not rebuild.
- ECR will look like `<account>.dkr.ecr.us-east-1.amazonaws.com/aether-launch:1.0`.

## Guided Steps

1. Build from this folder with the version tag:

```bash
cd ~/ncc-training/05-Docker/new-style/05-docker-tag-and-images
docker build -t aether-launch:1.0 .
```

2. Add convention tags. Same image, three names:

```bash
docker tag aether-launch:1.0 aether-launch:latest
docker tag aether-launch:1.0 aether-launch:1.0.0
docker images | grep aether-launch
```

All three rows should share one IMAGE ID.

3. Inspect what you built:

```bash
docker inspect aether-launch:1.0 --format '{{.RepoTags}}'
docker inspect aether-launch:1.0 --format '{{.Config.ExposedPorts}}'
```

Port `80/tcp` should be listed.

4. Practice the ECR naming shape (do not push yet):

```bash
docker tag aether-launch:1.0 \
  123456789012.dkr.ecr.us-east-1.amazonaws.com/aether-launch:1.0
```

Replace `123456789012` with a fake or real account id. This is only a local name until `docker push`.

5. Remove the practice registry tag and `latest`. Keep `:1.0`:

```bash
docker rmi 123456789012.dkr.ecr.us-east-1.amazonaws.com/aether-launch:1.0 2>/dev/null || true
docker rmi aether-launch:latest
docker images | grep aether-launch
```

## Task

Build `aether-launch:1.0` from this folder. Tag it as `:1.0`, `:1.0.0`, and `:latest`. Prove they share one IMAGE ID. Remove `:latest` only and keep `:1.0`.

## Checkpoint
Why is `aether-launch:1.0` a better production name than `aether-launch:latest`?
