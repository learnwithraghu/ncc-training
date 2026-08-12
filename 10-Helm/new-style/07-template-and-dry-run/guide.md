# Topic 7: Template and Dry-Run

**Time:** ~20 minutes

## What You'll Learn (and Solve)

1. Render chart YAML locally with `helm template`.
2. Preview an upgrade with `--dry-run`.
3. Spot Service / StatefulSet bits in the rendered output.
4. Run `helm lint` against a chart path pulled locally (optional) or understand lint's role.
5. Solve "I want to review what Helm would apply before it applies it."

## Goal
Practice safe preview commands against the official Jenkins chart and your lab
values — without relying on hope.

## Commands to Teach

```bash
cd ~/ncc-training/10-Helm/new-style/07-template-and-dry-run
helm template signal-forge jenkins/jenkins -n signal-forge -f values-lab.yaml | head -n 80
helm template signal-forge jenkins/jenkins -n signal-forge -f values-lab.yaml \
  | grep -E 'kind:|nodePort:|32080' | head -n 40
helm upgrade signal-forge jenkins/jenkins -n signal-forge -f values-upgrade.yaml --dry-run
helm pull jenkins/jenkins --untar --untardir /tmp/signal-forge-chart
helm lint /tmp/signal-forge-chart/jenkins -f values-lab.yaml
```

- `helm template` — client-side render; no cluster required for the render itself.
- `--dry-run` on upgrade/install — server-side validation path without keeping changes.
- `helm pull --untar` + `helm lint` — lint a chart directory with your values.

## Guided Steps

1. Render with lab values and skim the top of the output:

```bash
cd ~/ncc-training/10-Helm/new-style/07-template-and-dry-run
helm repo update
helm template signal-forge jenkins/jenkins -n signal-forge -f values-lab.yaml | head -n 80
```

2. Prove your NodePort override appears in the render:

```bash
helm template signal-forge jenkins/jenkins -n signal-forge -f values-lab.yaml \
  | grep -n "32080" | head
```

3. Dry-run an upgrade to the upgrade values:

```bash
helm upgrade signal-forge jenkins/jenkins -n signal-forge -f values-upgrade.yaml --dry-run
```

Read the notes; confirm nothing permanently switched the live Service unless
you omit `--dry-run`.

4. Lint the pulled chart with lab values:

```bash
rm -rf /tmp/signal-forge-chart
helm pull jenkins/jenkins --untar --untardir /tmp/signal-forge-chart
helm lint /tmp/signal-forge-chart/jenkins -f values-lab.yaml
```

## Task

Show a `helm template` snippet that includes `32080`, and a successful
`helm upgrade ... --dry-run`.

## Checkpoint

What's the practical difference between `helm template` and
`helm upgrade --dry-run`?

## What's Next?
This is good, but we still need:

1. A clean way to remove the release when class is over.
2. Confirmation that Pods and Services disappear.
3. Awareness of leftover PVCs when persistence is enabled (ours is off).
4. A habit of uninstalling lab releases so clusters stay tidy.
5. Uninstall — **Topic 8: Uninstall and Cleanup**.
