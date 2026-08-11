# Jenkins on EC2 - Overview

## What is Jenkins?

Jenkins is a web-based automation server for CI/CD. In this module, Jenkins runs on an **Amazon Linux EC2** instance and is managed through the **Web UI**.

## What This Module Focuses On

- Installing Jenkins with commands
- Using a browser to manage Jenkins jobs
- Cloning this repository locally on EC2 for all lesson files
- Building simple Freestyle jobs
- Building simple Pipeline jobs
- Triggering jobs with the Build Now button
- Running Python syntax checks and unit tests

## Why This Setup?

This setup keeps the workflow simple:

- one EC2 server
- one browser UI
- one repo with all student files
- small Python projects for easy practice

## Core Concepts

- **Freestyle job**: UI-driven job with shell steps
- **Pipeline job**: job defined as code with stages
- **Workspace**: files Jenkins checks out or creates for a job
- **Build step**: command Jenkins runs during a job
- **Artifact**: file saved after the job finishes

## Sample Flow

```text
Clone repo -> Install Jenkins -> Open Web UI -> Create job -> Run Python check -> Run Python test
```

## Prerequisites

- Amazon Linux EC2 instance
- SSH access to the instance
- Python installed on the server
- Git installed on the server

## Learning Path

1. Prepare the EC2 host and clone the repo
2. Install Jenkins with commands
3. Open Jenkins in the browser
4. Create Freestyle jobs
5. Create Pipeline jobs
6. Run Python syntax and unit test jobs
7. Trigger builds with Build Now

## Lab Project

The `lab-project/` folder contains a tiny Python app and tests used in the lessons.
