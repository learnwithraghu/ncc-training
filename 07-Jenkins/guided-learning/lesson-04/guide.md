# Lesson 04 - Freestyle Hello Job

Create your first Freestyle job with one shell step.

## Learn

- Create a Freestyle job in the UI
- Run a shell command
- Save a simple build result

## Practice

Use this command in the job:

```bash
cd "$WORKSPACE/../07-Jenkins/lab-project/python-app" || true
python3 app.py
```

Or keep it even simpler:

```bash
echo "Hello from Freestyle"
```

## Checkpoint

Can you run the job again without changing anything?
