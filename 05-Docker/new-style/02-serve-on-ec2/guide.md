# 02: Serve the Company Page on EC2

**Time:** ~20 minutes

## Goal
Build the Aether Launch image on this EC2 instance and serve the company page on host port 8080.

Work only in this folder. It has its own `index.html` and `Dockerfile`.

`COPY` puts `index.html` **inside the image**. It does not copy the file onto the EC2 disk, and it does not change nginx on the host.

## Commands to Teach

```bash
cd ~/ncc-training/05-Docker/new-style/02-serve-on-ec2
docker build -t aether-launch:1.0 .
docker run -d --name aether-web -p 8080:80 aether-launch:1.0
curl http://127.0.0.1:8080
docker rm -f aether-web
```

- `cd` into this topic folder so `docker build` uses this folder's `Dockerfile` and `index.html`.
- `docker build -t aether-launch:1.0 .` copies `index.html` into the image at `/usr/share/nginx/html/`.
- Run the image you just built (`aether-launch:1.0`). Do not run `nginx:1.27-alpine` or you will get the default nginx page.
- `docker run -p 8080:80` publishes host port 8080 to nginx port 80 inside the container.
- `curl` proves the company page is reachable on this host.
- `docker rm -f aether-web` removes the container so a second `docker run --name aether-web` does not fail.

## Guided Steps

1. Open this topic folder and confirm the page and Dockerfile are here:

```bash
cd ~/ncc-training/05-Docker/new-style/02-serve-on-ec2
pwd
ls
head -n 5 index.html
cat Dockerfile
```

You must be in `02-serve-on-ec2` so `index.html` is in the build context. The Dockerfile is two lines: `FROM nginx:1.27-alpine` and `COPY index.html` into nginx's html folder.

Start clean so a leftover container from a retry does not block port 8080:

```bash
docker rm -f aether-web 2>/dev/null || true
docker container prune -f
docker ps -a
```

2. Build the image from this folder, then prove `COPY` landed in the image (not on the EC2 disk):

```bash
docker build -t aether-launch:1.0 .
docker images | grep aether-launch
docker run --rm aether-launch:1.0 ls /usr/share/nginx/html
docker run --rm aether-launch:1.0 grep -o "Aether Launch" /usr/share/nginx/html/index.html
```

You should see `index.html` listed and `Aether Launch` printed. `ls` on the EC2 host will not show a new file under `/usr/share/nginx`. That path exists only inside the container.

3. Run **that** image and publish port 8080:

```bash
docker rm -f aether-web 2>/dev/null || true
docker run -d --name aether-web -p 8080:80 aether-launch:1.0
docker ps
docker exec aether-web ls /usr/share/nginx/html
```

4. Hit the page from the same EC2 instance:

```bash
curl -sS http://127.0.0.1:8080 | head
```

You should see `Aether Launch` in the HTML. If you see `Welcome to nginx!`, you ran the stock `nginx` image instead of `aether-launch:1.0`. Remove the container and run the command in step 3 again.

5. Optional: from your laptop browser, open `http://<EC2_PUBLIC_IP>:8080` if the security group allows port 8080.

6. Clean up when you are done:

```bash
docker rm -f aether-web
docker container prune -f
docker ps -a
```

The image `aether-launch:1.0` stays on the instance. Next topic walks the Dockerfile line by line.

## Cleanup

If `docker run` fails with **name already in use** or **port is already allocated**, or when you finish this topic:

```bash
docker rm -f aether-web 2>/dev/null || true
docker container prune -f
docker ps -a
```

- `docker rm -f aether-web` stops and deletes the lab container even if it is still running.
- `docker container prune -f` deletes other **exited** containers.
- Images stay (`docker images`). You do not need to delete `aether-launch:1.0`.

If port 8080 is still busy:

```bash
docker ps --format 'table {{.Names}}\t{{.Ports}}'
docker rm -f <NAME>
```

## Task

From this folder, `docker build -t aether-launch:1.0 .`, confirm `Aether Launch` is inside `/usr/share/nginx/html/index.html` in the image, run `aether-launch:1.0` with `8080:80`, and curl the page. Then `docker rm -f aether-web`.

## Checkpoint
Why does `COPY` in the Dockerfile not create a new `index.html` on the EC2 disk?
