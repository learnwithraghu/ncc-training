# Module 7: Jenkins on EC2

This module shows how to run Jenkins on **Amazon Linux EC2** and use the **Jenkins Web UI** for all job work.

## What You Will Learn

- Set up Jenkins on EC2 with commands
- Access Jenkins through the browser, not Docker
- Clone this repo locally on EC2 for all lesson material
- Build simple **Freestyle** and **Pipeline** jobs
- Trigger jobs with the **Build Now** button
- Run basic **Python syntax checks** and **Python unit tests** in Jenkins
- Keep the exercises simple and repeatable

## Time Estimate

About **4 hours**.

## Prerequisites

- EC2 instance running Amazon Linux
- SSH access to the EC2 host
- Open ports for Jenkins web access
- Basic Linux, Git, and Python knowledge

## Guided Learning Lessons

| Lesson | Name | Focus |
|---|---|---|
| 1 | [guided-learning/lesson-01/](guided-learning/lesson-01/) | EC2 prep and repo clone |
| 2 | [guided-learning/lesson-02/](guided-learning/lesson-02/) | Install Jenkins with commands |
| 3 | [guided-learning/lesson-03/](guided-learning/lesson-03/) | First login and setup wizard |
| 4 | [guided-learning/lesson-04/](guided-learning/lesson-04/) | Freestyle job basics |
| 5 | [guided-learning/lesson-05/](guided-learning/lesson-05/) | Python syntax check job |
| 6 | [guided-learning/lesson-06/](guided-learning/lesson-06/) | Python unit test job |
| 7 | [guided-learning/lesson-07/](guided-learning/lesson-07/) | Pipeline with simple stages |
| 8 | [guided-learning/lesson-08/](guided-learning/lesson-08/) | Parameters and workspace files |
| 9 | [guided-learning/lesson-09/](guided-learning/lesson-09/) | Local repo job setup |
| 10 | [guided-learning/lesson-10/](guided-learning/lesson-10/) | Final mini CI flow |

## Module Structure

- `00-OVERVIEW.md` — Jenkins overview for this EC2-based workflow
- `guided-learning/` — 10 self-contained lessons
- `lab-project/` — sample Python project for the jobs
- `challenges/` — four simple PHP Jenkins challenges
- `scripts/` — optional setup notes and command snippets

## Key Artifact

A Jenkins instance on EC2 that runs Freestyle and Pipeline jobs against a small Python project.

## Completion Checklist

- [ ] Install Jenkins on Amazon Linux with commands
- [ ] Open Jenkins in the browser
- [ ] Clone this repo locally on EC2
- [ ] Create a Freestyle job
- [ ] Run Python syntax checks
- [ ] Run Python unit tests
- [ ] Create a simple Pipeline job
- [ ] Trigger a job with Build Now

Start with [00-OVERVIEW.md](00-OVERVIEW.md).
