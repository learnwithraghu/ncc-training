# Guided Learning - Ansible

This module uses one self-contained lesson per topic.

Sandbox note: this lab runs Ansible 2.18.5 and provides `web1` and `web2` as root-accessible targets (`root` / `Passw0rd`).

## Setup

Use the provided lab hosts:

- `web1` — `root` / `Passw0rd`
- `web2` — `root` / `Passw0rd`
- controller-side commands should use an inventory file in the working directory, such as `inventory.ini` — Topic 01 builds it

## Structure

- `topic-01/` through `topic-13/` hold the learning topics
- `challenge-01/` through `challenge-05/` are inserted between topics as practice stops
- each topic and challenge has a `guide.md` file and a starter `.yml` playbook, except Topic 01 (builds the inventory) and Topic 03 (ad-hoc `ansible -m command` only, no playbook)
- each stop is designed to take about 20 minutes

## Recommended Flow

Each topic tells a small story:

1. Read the goal.
2. Run the commands that solve it.
3. Validate on `web1` or `web2`.
4. Check the checkpoint prompt before moving on.
5. Finish the topic in about 20 minutes before moving to the next one.

## Topic List

- Topic 01 - Build the Inventory
- Topic 02 - Meet the Lab and Check the Servers
- Challenge 01 - Prove Both Servers Respond
- Topic 03 - Build Your Server List and Ask Quick Questions
- Challenge 02 - Install a Small Helper Tool
- Topic 04 - Check CPU and Disk Space on Each Server
- Challenge 03 - Place the Same File on Both Hosts
- Topic 05 - Write Your First Playbook
- Challenge 04 - Create a Service User
- Topic 06 - Use One Template for Both Servers
- Topic 07 - Install the Web Server and Keep It Running
- Topic 08 - Put the Same File in the Right Place
- Topic 09 - Do the Same Setup for a Small Group of Packages
- Topic 10 - Pack the Web Server Steps into a Role
- Topic 11 - Deploy the Small App Across Both Servers
- Challenge 05 - Start a Service and Restart Only on Change
- Topic 12 - Install Different Things on Different Hosts, One Playbook
- Topic 13 - Install, Run, and Verify a Package in One Playbook
