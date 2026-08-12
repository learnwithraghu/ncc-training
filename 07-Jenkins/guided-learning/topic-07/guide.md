# Topic 7: Testing Python Syntax With py_compile

**Time:** 20 minutes

## Goal
Give the Jenkins container Python, then build a pipeline stage that fails
the build the moment a `.py` file on the mounted volume has a syntax
error - and watch it turn green once you fix the file.

## Files Provided
- `files/code/app.py` (valid), `files/code/broken.py` (syntax error) -
  drop onto `~/jenkins-code` on the host.
- `files/Jenkinsfile` - loops over every `.py` file in `/var/jenkins_code`
  and runs `python3 -m py_compile` on it.

## Commands to Use
```bash
# one-time: give the Jenkins container a Python interpreter
docker exec -u root jenkins bash -c "apt-get update && apt-get install -y python3"
docker exec jenkins python3 --version
```

## Guided Steps
1. The official `jenkins/jenkins:lts-jdk17` image does not ship Python.
   Install it once, as root, inside the running container with the
   command above. This survives container restarts (it's baked into the
   writable container layer, not the volumes) but **not** `docker rm -f`
   - if you recreate the container later, repeat this step.
2. Copy this topic's `files/code/app.py` and `files/code/broken.py` onto
   `~/jenkins-code` on the host.
3. Create a Pipeline job, e.g. `python-syntax-check`, and paste in this
   topic's `files/Jenkinsfile`.
4. Click **Build Now**. The build should **fail (red)** - read the
   console output and find the exact line where `py_compile` reports the
   `SyntaxError` in `broken.py`.
5. On the host, fix `broken.py` (add the missing colon after
   `def broken_function(a, b):`) or simply delete it from
   `~/jenkins-code`.
6. Click **Build Now** again. The build should now **pass (green)**.
7. Notice the pipeline didn't need to know the filenames in advance - the
   `for f in *.py` loop picks up whatever is currently on the mounted
   volume. Drop in a third `.py` file and rebuild to prove it.

## Checkpoint
`py_compile` only catches syntax errors - it will happily accept code
with an unused import or a line that's 200 characters long. What kind of
problem would you need a *different* tool to catch, and which stage will
Topic 8 add for that?
