# Docker Build Example

This folder is the Docker build context used in Jenkins Topic 13.

Build it locally with:

```bash
docker build --build-arg BUILD_NUMBER=local -t jenkins-lab:local .
```

The Jenkins lesson builds the image for local inspection only. It does not push the image to a registry.
