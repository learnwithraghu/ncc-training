# Lesson 05 - Python Syntax Check

Use Jenkins to verify Python syntax with `py_compile`.

## Learn

- Run a syntax-only check
- Keep the job fast
- Fail early on broken Python code

## Practice

```bash
cd python-app
python3 -m py_compile app.py test_app.py
```

## Checkpoint

What is the difference between syntax checking and running the app?
