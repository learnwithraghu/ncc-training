# Topic 2: Images and Layers

**Time:** 20 minutes

## Goal
Learn how images are built from layers and how Docker caches them.

## Commands to Use
```bash
docker images
docker pull python:3.11-slim
docker history python:3.11-slim
```

## Guided Steps
1. List your local images.
2. Pull a base Python image.
3. Inspect the image history.
4. Talk through how each layer adds filesystem changes.
5. Explain why layer ordering matters for rebuild speed.

## Checkpoint
Why does Docker rebuild faster when unchanged layers stay near the top of the file?
