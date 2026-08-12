# Helm New Style — Signal Forge (Jenkins via Official Chart)

Work through these topics in order against a real Kubernetes cluster with
Helm installed. Each topic folder is independent: it has its own `guide.md`
and, where needed, lab values files. You do not need files from a previous
folder — but topics 03–08 expect the same release name and namespace.

The project is **Signal Forge**: Jenkins CI installed from the official
open-source chart `jenkins/jenkins` ([charts.jenkins.io](https://charts.jenkins.io/)).

- Namespace: `signal-forge`
- Release name: `signal-forge`
- Chart: `jenkins/jenkins`

## Recommended Flow

1. Open the topic folder.
2. Read **What You'll Learn (and Solve)** — five points on the goal.
3. Run the Helm / kubectl commands in order.
4. Complete the **Task** and answer the **Checkpoint**.
5. Read **What's Next?** — five "this is good, but…" points that lead to the next topic.

## Topic List

| Folder | Focus |
|--------|-------|
| [01-meet-helm/](01-meet-helm/) | Why Helm after kubectl; create the `signal-forge` namespace |
| [02-add-repo-and-search/](02-add-repo-and-search/) | Add `charts.jenkins.io`, search, `helm show` |
| [03-install-jenkins/](03-install-jenkins/) | `helm install` Signal Forge with lab values |
| [04-inspect-the-release/](04-inspect-the-release/) | `list` / `status` / `get`; open the Jenkins UI |
| [05-override-values/](05-override-values/) | Change release settings with `-f` and `--set` |
| [06-upgrade-and-rollback/](06-upgrade-and-rollback/) | `helm upgrade`, `history`, `rollback` |
| [07-template-and-dry-run/](07-template-and-dry-run/) | `helm template`, dry-run, lint values |
| [08-uninstall-and-cleanup/](08-uninstall-and-cleanup/) | `helm uninstall` and confirm cleanup |

## How practical folders are laid out

```text
values-lab.yaml      small overrides for the official Jenkins chart
values-upgrade.yaml  second values file for upgrade demos (where present)
guide.md             commands, steps, task, checkpoint, bookends
```

## Instructor Helper

```bash
cd ~/ncc-training/10-Helm/new-style/helpers
bash run-helm-lab.sh
```

The script adds the Jenkins repo, installs Signal Forge with lab values,
waits for the controller, smoke-checks the Service, exercises upgrade /
rollback, then uninstalls.

## Scope Boundary

This module teaches **consuming and operating** an open-source Helm chart.
It does not teach `helm create` or packaging your own chart. Jenkins product
pipelines stay in [07-Jenkins](../../07-Jenkins/README.md). Kubernetes
fundamentals stay in [09-Kubernetes](../../09-Kubernetes/README.md).
