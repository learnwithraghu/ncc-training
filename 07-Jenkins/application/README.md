# Sample Application

This is the small stdlib-only Python project the whole module tests, lints,
unit-tests, and eventually containerizes from inside Jenkins pipelines.

| File | Purpose |
|------|---------|
| `app.py` | Valid CLI: `add`, `is_prime`, `fizzbuzz` subcommands |
| `broken.py` | Deliberately has a syntax error - used to prove a pipeline's syntax-check stage can fail a build |
| `test_app.py` | pytest unit tests for `app.py` |
| `requirements.txt` | `pytest` + `flake8`, installed inside the pipeline (not baked into the Jenkins image) |
| `Dockerfile` | Built by the pipeline in Topic 12, once tests pass |

This folder is the "final answer key" version. Each `guided-learning/topic-NN/`
folder that needs these files carries its **own copy** under `files/code/`
(and its own `files/Jenkinsfile`), so you can start from any topic without
depending on work left over from a previous one. See
[Guided Learning Focus](../README.md#guided-learning-focus) for why.

Run it directly with Python if you want to see it work before it ever
touches Jenkins:

```bash
python3 app.py fizzbuzz 15
python3 -m pytest test_app.py -v
python3 -m py_compile app.py      # passes
python3 -m py_compile broken.py   # fails - this is the point
```
