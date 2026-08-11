# Jenkins Lab Project

A tiny, dependency-light Python CLI used by every guided-learning topic in `07-Jenkins`. It exists
so the pipelines have something real to lint, test, package, and containerize — the point is the
Jenkins/Docker workflow, not the app.

## Files

- `app.py` — a small CLI (`calc`, `is-prime`, `fizzbuzz` subcommands)
- `test_app.py` — pytest unit tests
- `check_syntax.sh` — `py_compile` + `flake8` lint check
- `requirements.txt` — `pytest` and `flake8`
- `Dockerfile` — used in Topic 14 when a pipeline stage builds this app's own image

## Run It Directly

```bash
cd /workspaces/ncc-training/07-Jenkins/application
pip install -r requirements.txt
python3 app.py fizzbuzz 15
python3 -m pytest
bash check_syntax.sh
```

## How Jenkins Uses This Folder

This folder is `COPY`'d into the custom Jenkins image (see `../jenkins/Dockerfile`) at
`/opt/lab-project/application`. Pipelines copy it from there into their own workspace at the start
of each run — see `../jenkins/Jenkinsfile` and Topic 7 for why.
