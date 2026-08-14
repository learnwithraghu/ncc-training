# Day 5, Part 2: Helm

This module teaches Helm the same way Kubernetes is taught: a linear
**new-style** story. You install **Signal Forge** — Jenkins CI from the
official open-source chart (`jenkins/jenkins` on
[charts.jenkins.io](https://charts.jenkins.io/)) — then practice Helm
features on that release.

## What You Will Learn

By the end of this module, you will be able to:

- Explain chart vs release and why Helm sits on top of kubectl
- Add a chart repository, search, and inspect chart values
- Install Jenkins with a small lab values file
- Inspect a release (`list`, `status`, `get`)
- Override values, upgrade, roll back, template, dry-run, and uninstall

## Time Estimate

Approximately **2.5 hours** total, split into 8 topics at about 15–25 minutes each.

## Prerequisites

- Completion of [09-Kubernetes](../09-Kubernetes/README.md)
- Helm installed (`helm version`)
- Kubernetes cluster access (`kubectl`)

## Verify Your Environment

```bash
bash 10-Helm/new-style/helpers/run-helm-lab.sh
```

The helper installs Signal Forge with lab values, waits for Jenkins, exercises
upgrade/rollback and template/dry-run, then uninstalls. Fix any failures before
teaching.

See [demo-infra-requirement.md](demo-infra-requirement.md) for the checklist.

## Guided Learning Topics

Work through topics in [new-style/](new-style/) in order — see
[new-style/README.md](new-style/README.md) for folder layout and scope.

| Topic | Folder | Focus |
|-------|--------|-------|
| 01 Meet Helm | [new-style/01-meet-helm/](new-style/01-meet-helm/) | Helm mindset, `signal-forge` namespace |
| 02 Add Repo and Search | [new-style/02-add-repo-and-search/](new-style/02-add-repo-and-search/) | Jenkins chart repo, search, show |
| 03 Install Jenkins | [new-style/03-install-jenkins/](new-style/03-install-jenkins/) | `helm install` with lab values |
| 04 Inspect the Release | [new-style/04-inspect-the-release/](new-style/04-inspect-the-release/) | list / status / get / UI login |
| 05 Override Values | [new-style/05-override-values/](new-style/05-override-values/) | `-f` and `--set` |
| 06 Upgrade and Rollback | [new-style/06-upgrade-and-rollback/](new-style/06-upgrade-and-rollback/) | upgrade, history, rollback |
| 07 Template and Dry-Run | [new-style/07-template-and-dry-run/](new-style/07-template-and-dry-run/) | template, dry-run, lint |
| 08 Uninstall and Cleanup | [new-style/08-uninstall-and-cleanup/](new-style/08-uninstall-and-cleanup/) | uninstall and tidy the cluster |

## Instructor diagrams

Classroom diagrams live in [images/](images/) (`helm-overview.png`, `why-helm.png`).

## Lab Defaults

- Namespace / release: `signal-forge`
- Chart: `jenkins/jenkins`
- Admin: `admin` / `Passw0rd`
- Service: NodePort **32080** (upgrade demo uses **32081**)
- Persistence: disabled for easy teardown
