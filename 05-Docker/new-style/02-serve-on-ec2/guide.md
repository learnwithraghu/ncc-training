# 02: Serve the Company Page on EC2

**Time:** ~20 minutes

## Goal
Serve the Aether Launch HTML page from this EC2 instance and publish a host port. The files stay on disk. They are not baked into an image yet.

Work only in this folder. It has its own `index.html`.

## Commands to Teach

```bash
cd ~/ncc-training/05-Docker/new-style/02-serve-on-ec2
docker run -d --name aether-web -p 8080:80 -v "$PWD":/usr/share/nginx/html:ro nginx:1.27-alpine
curl http://127.0.0.1:8080
docker rm -f aether-web
```

- `cd` into this topic folder so the volume mount points at `index.html`.
- `docker run -p 8080:80` publishes host port 8080 to nginx port 80 inside the container.
- `-v "$PWD":/usr/share/nginx/html:ro` mounts the EC2 files into nginx. Change `index.html` on the instance and refresh — no rebuild.
- `curl` proves the company page is reachable on this host.

## Guided Steps

1. Open this topic folder and confirm the page is here:

```bash
cd ~/ncc-training/05-Docker/new-style/02-serve-on-ec2
ls
head -n 5 index.html
```

2. Start nginx with the HTML mounted from EC2:

```bash
docker rm -f aether-web 2>/dev/null || true
docker run -d --name aether-web -p 8080:80 \
  -v "$PWD":/usr/share/nginx/html:ro \
  nginx:1.27-alpine
docker ps
```

The image is stock `nginx`. Your company page is still just a file on the instance.

3. Hit the page from the same EC2 instance:

```bash
curl -sS http://127.0.0.1:8080 | head
```

You should see `Aether Launch` in the HTML.

4. Optional: from your laptop browser, open `http://<EC2_PUBLIC_IP>:8080` if the security group allows port 8080.

5. Stop the container when you are done looking:

```bash
docker rm -f aether-web
```

The `index.html` file remains on EC2. Next topic bakes that file into an image.

## Task

From this folder, run nginx with a bind mount, publish `8080:80`, and curl the page until you see **Aether Launch**. Then remove the container. Do not use `docker build` yet.

## Checkpoint
What is the difference between files mounted from EC2 with `-v` and files copied into an image with a Dockerfile?
