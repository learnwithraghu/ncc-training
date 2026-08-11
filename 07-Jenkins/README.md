# Module 7: Jenkins on EC2

This module shows how to run Jenkins on **Ubuntu Server** and use the **Jenkins Web UI** for all job work.

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

- Ubuntu Server instance on EC2
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
- `helper-scripts/` — one-command Jenkins bootstrap and guided-learning job seeding
- `scripts/` — optional setup notes and command snippets

## Key Artifact

A Jenkins instance on EC2 that runs preconfigured jobs for the guided-learning lessons on Ubuntu.

## Completion Checklist

- [ ] Run the helper bootstrap script
- [ ] Use the updated manual install commands if you install by hand
- [ ] Open Jenkins in the browser
- [ ] Confirm the guided-learning jobs already exist
- [ ] Run the lesson 05-10 pipelines

Start with [00-OVERVIEW.md](00-OVERVIEW.md).
