# 02: Serve the Company Page on EC2

**Time:** ~20 minutes

## Goal
Build the Aether Launch image on this EC2 instance and serve the company page on host port 8080.

Work only in this folder. It has its own `index.html` and `Dockerfile`.

## Commands to Teach

```bash
cd ~/ncc-training/05-Docker/new-style/02-serve-on-ec2
docker build -t aether-launch:1.0 .
docker run -d --name aether-web -p 8080:80 aether-launch:1.0
curl http://127.0.0.1:8080
docker rm -f aether-web
```

- `cd` into this topic folder so `docker build` uses this folder's `Dockerfile` and `index.html`.
- `docker build -t aether-launch:1.0 .` reads the Dockerfile, copies the HTML into the image, and names the result `aether-launch:1.0`.
- `docker run -p 8080:80` publishes host port 8080 to nginx port 80 inside the container.
- `curl` proves the company page is reachable on this host.

## Guided Steps

1. Open this topic folder and confirm the page and Dockerfile are here:

```bash
cd ~/ncc-training/05-Docker/new-style/02-serve-on-ec2
ls
head -n 5 index.html
cat Dockerfile
```

You should see a two-line Dockerfile: `FROM nginx:1.27-alpine` and `COPY index.html` into nginx's html folder. Next topic adds package install and a health check.

2. Build the image from this folder:

```bash
docker build -t aether-launch:1.0 .
docker images | grep aether-launch
```

The trailing `.` is the build context: this directory. Docker uses the `Dockerfile` here and copies `index.html` into the image.

3. Run the image and publish port 8080:

```bash
docker rm -f aether-web 2>/dev/null || true
docker run -d --name aether-web -p 8080:80 aether-launch:1.0
docker ps
```

4. Hit the page from the same EC2 instance:

```bash
curl -sS http://127.0.0.1:8080 | head
```

You should see `Aether Launch` in the HTML.

5. Optional: from your laptop browser, open `http://<EC2_PUBLIC_IP>:8080` if the security group allows port 8080.

6. Stop the container when you are done looking:

```bash
docker rm -f aether-web
```

The image `aether-launch:1.0` stays on the instance. Next topic walks the Dockerfile line by line.

## Task

From this folder, `docker build -t aether-launch:1.0 .`, run the image with `8080:80`, and curl the page until you see **Aether Launch**. Then remove the container.

## Checkpoint
Why does `docker build` need the `.` at the end, and what files from this folder end up inside the image?
