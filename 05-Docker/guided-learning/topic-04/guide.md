# Topic 4: Environment Variables and Inspect

**Time:** 20 minutes

## Goal
Pass settings into containers and inspect the runtime configuration.

## Commands to Use
```bash
docker run -d --name appdemo -p 5000:5000 -e ENVIRONMENT=training -e APP_VERSION=2.0 your-image-name
docker inspect appdemo
docker exec appdemo printenv | grep -E 'ENVIRONMENT|APP_VERSION'
docker rm -f appdemo
```

## Guided Steps
1. Run the sample app image with environment variables.
2. Inspect the container to find the configuration.
3. Use `printenv` inside the container.
4. Confirm that the app sees the values.
5. Explain why runtime variables are better than hard-coding secrets.

## Checkpoint
When would you set an environment variable at run time instead of inside the image?
