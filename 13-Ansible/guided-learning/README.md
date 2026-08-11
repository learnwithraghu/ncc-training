# Guided Learning - Ansible

This module uses one self-contained lesson per topic.

Sandbox note: this lab runs Ansible 2.18.5 and provides `web1` and `web2` as root-accessible targets (`root` / `Passw0rd`).

## Setup

Use the provided lab hosts:

- `web1` — `root` / `Passw0rd`
- `web2` — `root` / `Passw0rd`
- controller-side commands should use an inventory file in the working directory, such as `inventory.ini`

## Structure

- `topic-01/` through `topic-10/` hold the learning topics
- each topic has a `guide.md` file and a starter `.yml` playbook
- each topic is designed to take about 20 minutes

## Recommended Flow

1. Open the topic guide.
2. Read the explanation and commands.
3. Run the commands as you go.
4. Check the checkpoint prompt before moving on.
5. Finish the topic in about 20 minutes before moving to the next one.

## Topic List

- Topic 01 - What Ansible Is and Why It Matters
- Topic 02 - Inventory and Ad-Hoc Commands
- Topic 03 - SSH Connectivity and Facts
- Topic 04 - Playbooks and YAML Basics
- Topic 05 - Variables, Templates, and Debug
- Topic 06 - Packages, Services, and Handlers
- Topic 07 - Files, Copy, and Permissions
- Topic 08 - Loops, Conditionals, and Tags
- Topic 09 - Roles and Reusable Automation
- Topic 10 - Multi-Host App Deployment
- Challenge folder - five practice playbook prompts with starter playbooks
