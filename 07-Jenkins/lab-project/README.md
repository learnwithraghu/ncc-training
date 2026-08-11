# Jenkins Lab Project

This folder contains a tiny Python project for the Jenkins lessons.

## Files

- `python-app/app.py` — tiny Python module
- `python-app/test_app.py` — unit tests
- `python-app/check_syntax.sh` — syntax check helper
- `python-app/requirements.txt` — empty on purpose for the simple lab
- `Jenkinsfile` — simple pipeline example

## Use in Jenkins

Typical steps for the jobs:

- run `python3 -m py_compile app.py`
- run `python3 -m unittest -v`
- archive a small text artifact if needed
