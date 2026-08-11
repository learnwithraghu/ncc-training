# Guided Learning - Jenkins on EC2

This module uses one self-contained lesson per folder.

## Lab Setup

- Jenkins runs on an **Amazon Linux EC2** instance
- Access Jenkins through the **Web UI**
- Use the helper bootstrap script to install Jenkins and seed guided-learning jobs
- Clone this repository locally so learners have all files
- Use the Jenkins **Build Now** button to run each lesson
- Load the Pipeline Jenkinsfile from the local cloned repo

## Structure

- `lesson-01/` through `lesson-10/` hold the learning lessons
- each lesson has a single `guide.md` file
- each lesson is designed to take about 20 minutes

## Recommended Flow

1. Open the lesson guide.
2. Read the explanation and commands.
3. Run the commands as you go.
4. Check the checkpoint prompt before moving on.
5. Finish the lesson in about 20 minutes before moving to the next one.

## Lesson List

- Lesson 01 - EC2 Boot and Repo Clone
- Lesson 02 - Jenkins Bootstrap Script
- Lesson 03 - Jenkins Web UI First Steps
- Lesson 04 - Freestyle Hello Job
- Lesson 05 - Python Syntax Check
- Lesson 06 - Python Unit Test Job
- Lesson 07 - Simple Pipeline Stages
- Lesson 08 - Parameters and Workspace Notes
- Lesson 09 - Local Repo Pipeline Job
- Lesson 10 - Build Now CI Flow
