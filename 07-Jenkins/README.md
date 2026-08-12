# Day 4, Part 1: Jenkins

This module covers Jenkins: why installing it by hand is painful, why
running it in Docker fixes that, and how to build real Pipeline jobs that
read code from a local volume and test it.

## What You Will Learn

By the end of this module, you will be able to:

- Explain why manually installing Jenkins on a bare EC2 instance is
  fragile, and why running it as a Docker container avoids that
- Run Jenkins in Docker with a named volume (`jenkins_home`) for its own
  state and a bind mount for source code you control
- Create and configure Pipeline jobs from the Jenkins console
- Write pipeline stages that read code straight from a mounted host
  folder instead of pulling from git
- Build a syntax-check → lint → unit-test → package pipeline for a small
  Python project
- Use build parameters, archived artifacts, and JUnit test reports
- Let a pipeline drive the host's Docker daemon to build and tag an image

## Time Estimate

Approximately **4 hours** total, split into 12 guided topics at about 20
minutes each.

## Prerequisites

- Completion of [Day 3](../00-course-roadmap.md#day-3-docker-and-compose)
- Comfortable with basic Docker commands (`docker run`, `-v`, `-p`)
- Access to launch EC2 instances (Topics 1-2 each need a fresh one)

## Guided Learning Topics

Work through the topics in `guided-learning/` in order:

| Topic | Folder | Focus |
|-------|--------|-------|
| Topic 1 | [guided-learning/topic-01/](guided-learning/topic-01/) | The manual way: Jenkins on EC2 |
| Topic 2 | [guided-learning/topic-02/](guided-learning/topic-02/) | Meet Jenkins in Docker |
| Topic 3 | [guided-learning/topic-03/](guided-learning/topic-03/) | Unlock and first login |
| Topic 4 | [guided-learning/topic-04/](guided-learning/topic-04/) | The local volume: where your code lives |
| Topic 5 | [guided-learning/topic-05/](guided-learning/topic-05/) | Your first pipeline job |
| Topic 6 | [guided-learning/topic-06/](guided-learning/topic-06/) | Reading code from the mounted folder |
| Topic 7 | [guided-learning/topic-07/](guided-learning/topic-07/) | Testing Python syntax with py_compile |
| Topic 8 | [guided-learning/topic-08/](guided-learning/topic-08/) | Linting with flake8 |
| Topic 9 | [guided-learning/topic-09/](guided-learning/topic-09/) | Parameterized pipelines |
| Topic 10 | [guided-learning/topic-10/](guided-learning/topic-10/) | Unit tests with pytest + JUnit reports |
| Topic 11 | [guided-learning/topic-11/](guided-learning/topic-11/) | Archiving artifacts and build history |
| Topic 12 | [guided-learning/topic-12/](guided-learning/topic-12/) | Docker-in-Jenkins: build and tag the app image |

## Getting Started

Topic 1 needs a fresh, disposable Amazon Linux EC2 instance with `sudo`
access (it gets terminated at the end of the topic). Topics 2-12 need a
**second**, separate EC2 instance where you install Docker and git and
run Jenkins as a container - that instance stays up for the rest of the
module.

Verify Docker is installed once you reach Topic 2:

```bash
docker --version
docker info
```

### Quick Jenkins Check

Once the container from Topic 2 is running:

```bash
docker ps --filter name=jenkins
curl -sI http://localhost:8080 | head -1
```

If that returns an HTTP response, you're ready to continue.

## 🛠️ Sample Application

This module uses a tiny, dependency-free Python CLI as the "code under
test" for every pipeline you build. It lives in `application/`:

- `app.py` - valid CLI (`add`, `is_prime`, `fizzbuzz`)
- `broken.py` - a file with a real syntax error, used to prove a
  syntax-check stage actually fails builds
- `messy.py` - valid but full of style problems, used to demonstrate
  linting
- `test_app.py` - pytest unit tests
- `Dockerfile` - built by a pipeline stage in Topic 12

**Location:** `application/` directory (each guided-learning topic that
needs these files carries its own copy under `topic-NN/files/`, so no
topic depends on another one having run first).

## 📚 Additional Resources

### Official Documentation
- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Pipeline Syntax Reference](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [Official Jenkins Docker Image](https://github.com/jenkinsci/docker/)

### Guided Learning
- [guided-learning/](guided-learning/) - 12 self-contained Jenkins topics

### Next Steps After This Module
- **CI/CD on GitHub**: [08-GitHub-Actions](../08-GitHub-Actions/)
- **Orchestration**: [09-Kubernetes](../09-Kubernetes/)
- **Config Management**: [14-Ansible](../14-Ansible/)

## 💡 Tips for Success

**Practice Regularly:**
- Rebuild jobs after every change instead of guessing what will happen
- Deliberately break `app.py` or `test_app.py` to see a red build before
  fixing it - reading a failure is as valuable as reading a pass

**Keep the Two Volumes Straight:**
- `jenkins_home` (named volume) = Jenkins's own state
- `~/jenkins-code` (bind mount) = your source code, edited on the host

**Build Real Pipelines:**
- Once comfortable, point a pipeline at a small script of your own
- Add stages incrementally, the same way Topics 7-12 did

## 🤝 Getting Help

**During the Module:**
1. Check the container's logs: `docker logs jenkins`
2. Check a specific build's console output in the Jenkins UI
3. Re-read the topic's `files/Jenkinsfile` line by line
4. Consult instructor or peers
5. Search the official Jenkins documentation

**Common Commands for Help:**
```bash
docker logs -f jenkins
docker exec jenkins jenkins-plugin-cli --list
docker exec jenkins ls -la /var/jenkins_code
```

## Guided Learning Focus

The topic guides are the primary path through this module. Each lesson
is self-contained, ships its own files, and is designed to take about 20
minutes.
