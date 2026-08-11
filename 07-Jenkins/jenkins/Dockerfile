# syntax=docker/dockerfile:1
#
# Custom Jenkins image for this module. Built and rebuilt across the guided-learning topics:
#   Topic 04 - base image + plugins.txt
#   Topic 05 - bakes in application/ and Jenkinsfile
#   Topic 14 - adds the Docker CLI for the Docker-in-Jenkins stage
#
# This file shows the FINAL state. Earlier topics build it up incrementally — see each topic's
# guide.md for the diff at that point.
FROM jenkins/jenkins:lts-jdk17

USER root

# Python so pipeline Build/Lint/Test/Package stages can run the lab app directly (Topics 5, 10, 11)
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       python3 python3-pip python3-venv \
       ca-certificates curl gnupg \
    && rm -rf /var/lib/apt/lists/*

# Docker CLI so a pipeline stage can build images against the host's Docker daemon (Topic 14)
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/debian bookworm stable" \
       > /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends docker-ce-cli \
    && rm -rf /var/lib/apt/lists/*

# Plugins baked in at build time instead of clicked through Plugin Manager (Topic 4)
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

# Lab project + a reference Jenkinsfile baked in at build time (Topic 5)
COPY application /opt/lab-project/application
COPY Jenkinsfile /opt/lab-project/Jenkinsfile

USER jenkins
