#!/usr/bin/env python3
from datetime import datetime
from pathlib import Path
import os
import time

import redis

REDIS_HOST = os.getenv("REDIS_HOST", "redis")
REDIS_PORT = int(os.getenv("REDIS_PORT", "6379"))
QUEUE_NAME = os.getenv("QUEUE_NAME", "events")
DATA_DIR = Path(os.getenv("DATA_DIR", "/app/data"))


def main() -> None:
    client = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, decode_responses=True)
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    output_file = DATA_DIR / "processed.log"

    print(f"Worker started, listening on queue: {QUEUE_NAME}", flush=True)

    while True:
        try:
            item = client.lpop(QUEUE_NAME)
            if item:
                print(f"Processing event: {item}", flush=True)
                with output_file.open("a", encoding="utf-8") as handle:
                    handle.write(f"{datetime.utcnow().isoformat()}Z processed {item}\n")
            else:
                time.sleep(1)
        except redis.RedisError:
            # Keep the worker alive while redis restarts.
            print("Redis unavailable, retrying...", flush=True)
            time.sleep(2)


if __name__ == "__main__":
    main()
