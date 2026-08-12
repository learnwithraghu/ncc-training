# Guided Learning - Jenkins

This module uses one self-contained lesson per topic.

## Structure

- `topic-01/` through `topic-12/` hold the learning topics
- each topic has a single `guide.md` file
- most topics also ship a `files/` folder with the exact Jenkinsfile
  and/or code you'll drop onto the volume for that topic
- each topic is designed to take about 20 minutes

## Recommended Flow

1. Open the topic guide.
2. Read the explanation and commands.
3. Copy anything in `files/` to the right place (usually `~/jenkins-code`
   on the EC2 host) as instructed.
4. Run the commands and build the pipeline job as you go.
5. Check the checkpoint prompt before moving on.

## Guided Learning Focus

Every topic from `topic-04` onward is **self-contained**: it ships its
own copy of the `Jenkinsfile` and code files it needs under `files/`,
even when that duplicates a file from an earlier topic. You can start the
module at any topic (say, to re-run a demo) without hunting down
artifacts left over from a previous one - just copy that topic's `files/`
and go.

## Topic List

- Topic 01 - The Manual Way: Jenkins on EC2
- Topic 02 - Meet Jenkins in Docker
- Topic 03 - Unlock and First Login
- Topic 04 - The Local Volume: Where Your Code Lives
- Topic 05 - Your First Pipeline Job
- Topic 06 - Reading Code From the Mounted Folder
- Topic 07 - Testing Python Syntax With py_compile
- Topic 08 - Linting With flake8
- Topic 09 - Parameterized Pipelines
- Topic 10 - Unit Tests With pytest + JUnit Reports
- Topic 11 - Archiving Artifacts and Build History
- Topic 12 - Docker-in-Jenkins: Build and Tag the App Image
