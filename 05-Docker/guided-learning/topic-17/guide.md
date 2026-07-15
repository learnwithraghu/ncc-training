# Topic 17: Saving and Loading Images

**Time:** 20 minutes

## Goal
Learn how to move Docker images between hosts without using a registry.

## Why This Matters
In many training, lab, or air-gapped environments you cannot reach Docker Hub or a private registry. `docker save` exports an image to a tar archive, and `docker load` imports it back into Docker on another machine.

## Commands to Use

```bash
# Save an image to a tar file
docker save -o ncc-app.tar ncc-training-app:1.0

# Compress it for easier transfer
gzip ncc-app.tar

# On another host, decompress and load it
gunzip ncc-app.tar.gz
docker load -i ncc-app.tar

# Verify the image is present
docker images ncc-training-app:1.0
```

## Guided Steps

1. Build or tag the sample app image so you have something to export.
2. Run `docker save -o ncc-app.tar ncc-training-app:1.0` and check the file size.
3. Explain that the tar contains the image layers and metadata.
4. (Optional) Compress the tar with `gzip` to make transfer faster.
5. Run `docker load -i ncc-app.tar` to re-import the image.
6. Confirm the image appears with `docker images`.

## Checkpoint

When would you use `docker save` and `docker load` instead of pushing to a registry?

## Extra Tip

You can save multiple images into one tar file:

```bash
docker save -o bundle.tar image1:tag image2:tag
```

