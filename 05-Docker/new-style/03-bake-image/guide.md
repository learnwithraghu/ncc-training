# 03: Bake the Page into an Image

**Time:** ~20 minutes

## Goal
Slow down on a fuller Dockerfile: install a package, `COPY` `index.html` in, rebuild, and run without a bind mount.

Work only in this folder. It has its own `index.html` and `Dockerfile`.

## Commands to Teach

```bash
cd ~/ncc-training/05-Docker/new-style/03-bake-image
vi Dockerfile
docker build -t aether-launch:1.0 .
docker run -d --name aether-web -p 8080:80 aether-launch:1.0
```

- `vi Dockerfile` is how you read the recipe: base image, package install, `COPY`.
- `RUN apk add --no-cache curl` is package installation inside the image.
- `docker build -t aether-launch:1.0 .` bakes `index.html` into the image layers.
- `docker run -p 8080:80 aether-launch:1.0` serves the baked page. No `-v` mount.

## Guided Steps

1. Stay in this folder:

```bash
cd ~/ncc-training/05-Docker/new-style/03-bake-image
ls
```

2. Open the Dockerfile:

```bash
vi Dockerfile
```

You should see:

- `FROM nginx:1.27-alpine` — the base image
- `RUN apk add --no-cache curl` — Alpine package install (needed for the health check)
- `COPY index.html /usr/share/nginx/html/index.html` — the company page is now part of the image
- `EXPOSE 80` — documents the container port

3. Build the image. The name `aether-launch` is the repository. `1.0` is the version tag:

```bash
docker build -t aether-launch:1.0 .
docker images | grep aether-launch
```

4. Run the baked image. Do not use a volume:

```bash
docker rm -f aether-web 2>/dev/null || true
docker run -d --name aether-web -p 8080:80 aether-launch:1.0
curl -sS http://127.0.0.1:8080 | grep -o "Aether Launch" | head -n 1
```

The HTML came from the image, not from a live mount of this folder.

5. Leave the container running if you want, or clean up:

```bash
docker rm -f aether-web
```

## Task

From this folder, read the Dockerfile, explain the `apk add` line, build `aether-launch:1.0`, run it on `8080:80`, and curl until you see **Aether Launch**. Do not use `-v`.

## Checkpoint
Why does `COPY` in the Dockerfile mean you can delete the EC2 files later and the site still runs?
