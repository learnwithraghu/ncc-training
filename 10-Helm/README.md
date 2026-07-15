# Day 5, Part 2: Helm

This module teaches Helm through a guided-learning path from chart basics to a capstone-style workflow.

## What You Will Learn

By the end of this module, you will be able to:

- Explain Helm chart, release, and values concepts
- Search and inspect chart repositories
- Create, lint, template, and package Helm charts
- Install, upgrade, rollback, and uninstall releases safely
- Build a practical chart workflow for the document-search app shape

## Time Estimate

Approximately **3 to 3.5 hours** total, split into 10 guided topics at about 20 minutes each.

## Prerequisites

- Completion of [09-Kubernetes](../09-Kubernetes/README.md)
- Helm installed (`helm version`)
- Kubernetes cluster access

## Verify Your Environment

Before starting the topics, run the infrastructure validator to confirm Helm, kubectl, and the cluster can execute every command used across the 10 guided topics:

```bash
/workspaces/ncc-training/10-Helm/helpers/validate-infra.sh
```

The validator checks Helm environment, repository discovery, release install/uninstall, chart creation, templating, linting, dry-run, upgrades, rollbacks, packaging, and the capstone workflow. Fix any failures before teaching or running the module.

## Guided Learning Topics

Work through topics in [guided-learning/](guided-learning/) in order:

| Topic | Folder | Focus |
|-------|--------|-------|
| Topic 1 | [guided-learning/topic-01/](guided-learning/topic-01/) | Helm mindset and environment checks |
| Topic 2 | [guided-learning/topic-02/](guided-learning/topic-02/) | Chart and repository discovery |
| Topic 3 | [guided-learning/topic-03/](guided-learning/topic-03/) | Release lifecycle basics |
| Topic 4 | [guided-learning/topic-04/](guided-learning/topic-04/) | Create your first chart |
| Topic 5 | [guided-learning/topic-05/](guided-learning/topic-05/) | Values and template fundamentals |
| Topic 6 | [guided-learning/topic-06/](guided-learning/topic-06/) | Service and deployment templating |
| Topic 7 | [guided-learning/topic-07/](guided-learning/topic-07/) | Lint, template, and dry-run validation |
| Topic 8 | [guided-learning/topic-08/](guided-learning/topic-08/) | Upgrade, rollback, and value overrides |
| Topic 9 | [guided-learning/topic-09/](guided-learning/topic-09/) | Package and reuse a chart |
| Topic 10 | [guided-learning/topic-10/](guided-learning/topic-10/) | Capstone Helm mini workflow |

## Topic Assets

Topics that need helper files include local `assets/` folders, so each lesson can run independently from its own topic directory.

## Legacy References

Legacy narrative guides remain as reference material:

- [guide_01_helm_basics.md](guide_01_helm_basics.md)
- [guide_02_chart_for_capstone.md](guide_02_chart_for_capstone.md)

Primary learner flow is now the guided-learning topic sequence.
