# Topic 5: Logs and Exec

**Time:** 20 minutes

## Goal
Read container logs and open an interactive shell for troubleshooting.

## Commands to Use
```bash
docker run -d --name appdemo -p 5000:5000 your-image-name
docker logs appdemo
docker logs -f appdemo
docker exec -it appdemo sh
docker rm -f appdemo
```

## Guided Steps
1. Start the sample app container.
2. Read its logs.
3. Follow the logs live with `-f`.
4. Open a shell inside the container.
5. Explain when `docker exec` is useful during debugging.

## Checkpoint
Why is `docker logs` often the first command you use when a container behaves strangely?
