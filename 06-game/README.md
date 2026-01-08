# Linux Commando Game

A fun, interactive MCQ game to test your Linux knowledge!

## How to Play
1. Answer 10 questions about Linux commands.
2. Get instant feedback.
3. See your final rank at the end!

## Running with Docker

### Build the Image
```bash
docker build -t linux-game .
```

### Run the Game(Detach mode)
```bash
docker run -p 8080:80 linux-game
```

Then open your browser to [http://localhost:8080](http://localhost:8080).

### Stop the Game
Find the container ID:
```bash
docker ps
```

Stop it:
```bash
docker stop <container_id>
```
