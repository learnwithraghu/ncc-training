# Topic 2: Add Repo and Search

**Time:** ~15 minutes

## What You'll Learn (and Solve)

1. Add the official Jenkins chart repository.
2. Update local repo indexes with `helm repo update`.
3. Search for the Jenkins chart with `helm search repo`.
4. Inspect chart metadata and default values with `helm show`.
5. Solve "where do production-quality charts actually come from?"

## Goal
Connect to [charts.jenkins.io](https://charts.jenkins.io/) and inspect the
official `jenkins/jenkins` chart **before** installing it.

## Commands to Teach

```bash
helm repo add jenkins https://charts.jenkins.io
helm repo update
helm search repo jenkins/jenkins
helm show chart jenkins/jenkins
helm show values jenkins/jenkins | head -n 40
```

- `repo add` — registers a chart repository under a short name (`jenkins`).
- `repo update` — refreshes the local index so search sees current versions.
- `search repo` — finds charts by name.
- `show chart` / `show values` — read metadata and the huge default values file.

## Guided Steps

1. Add and update the Jenkins repo:

```bash
helm repo add jenkins https://charts.jenkins.io
helm repo update
helm repo list
```

2. Search for the chart you will install:

```bash
helm search repo jenkins/jenkins
```

3. Inspect the chart and skim defaults:

```bash
helm show chart jenkins/jenkins
helm show values jenkins/jenkins | head -n 40
```

Notice how large the defaults are. In the next topics you will override only a
small lab slice (`values-lab.yaml`) instead of editing the whole chart.

## Task

Add the Jenkins repo, find `jenkins/jenkins` with search, and print the chart
metadata with `helm show chart`.

## Checkpoint

Why do we run `helm repo update` after `helm repo add`?

## What's Next?
This is good, but we still need:

1. An actual install, not only browsing a chart.
2. Lab-friendly overrides (NodePort, no PVC, known admin password).
3. A release name so we can manage this install later.
4. Proof that Kubernetes objects appeared from the chart.
5. First install — **Topic 3: Install Jenkins**.
