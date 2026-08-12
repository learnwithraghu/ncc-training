# 05: Docker Tag and Images

**Time:** ~20 minutes

## Goal
List images, create extra tags for the same build, inspect image metadata, and understand what `docker rmi` actually removes.

## Commands to Teach

```bash
docker images
docker tag ncc-training-app:1.0 ncc-training-app:latest
docker inspect ncc-training-app:1.0
docker rmi ncc-training-app:latest
```

- `docker images` lists local images and their tags.
- `docker tag` adds another name to the same image ID. It does not rebuild.
- `docker inspect` shows the JSON metadata Docker stored for that image.
- `docker rmi` removes a tag. The image layers stay until no tag points at them.

## Guided Steps

1. Make sure the image exists. Build it if `docker images` does not show it:

```bash
cd ~/ncc-training/05-Docker/application
docker build -t ncc-training-app:1.0 .
docker images
```

Note the IMAGE ID for `ncc-training-app:1.0`.

2. Add a second tag that points at the same image:

```bash
docker tag ncc-training-app:1.0 ncc-training-app:latest
docker images | grep ncc-training-app
```

`:1.0` and `:latest` should share the same IMAGE ID. That is one image with two names.

3. Inspect the image and find the exposed port and environment variables:

```bash
docker inspect ncc-training-app:1.0
docker inspect ncc-training-app:1.0 --format '{{.Config.ExposedPorts}}'
docker inspect ncc-training-app:1.0 --format '{{.Config.Env}}'
```

4. Remove only the `latest` tag and list images again:

```bash
docker rmi ncc-training-app:latest
docker images | grep ncc-training-app
```

`ncc-training-app:1.0` should still be there. You deleted a name, not the build.

5. Keep `ncc-training-app:1.0` for the ECR topic. Do not delete the last tag yet.

## Task

Build `ncc-training-app:1.0`, tag the same image as both `:1.0` and `:latest`, and confirm they share one IMAGE ID. Inspect the image and write down the exposed port. Remove `:latest` only, then prove `:1.0` is still on the instance.

## Checkpoint
Why is tagging with a version such as `:1.0` safer than relying only on `:latest` when you later push to ECR?
