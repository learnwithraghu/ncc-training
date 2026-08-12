# Topic 8: Uninstall and Cleanup

**Time:** ~15 minutes

## What You'll Learn (and Solve)

1. Remove the Signal Forge release with `helm uninstall`.
2. Confirm Helm no longer lists the release.
3. Confirm Kubernetes objects are gone (or still terminating).
4. Know what would remain if persistence had been enabled.
5. Solve "class is over — how do I leave the cluster clean?"

## Goal
Tear down the Jenkins Helm release safely and close the Helm module.

## Commands to Teach

```bash
cd ~/ncc-training/10-Helm/new-style/08-uninstall-and-cleanup
helm list -n signal-forge
helm uninstall signal-forge -n signal-forge
helm list -n signal-forge
kubectl get all -n signal-forge
kubectl delete namespace signal-forge
```

- `helm uninstall` — deletes the release and the resources it owns.
- Deleting the namespace is optional but keeps training clusters tidy.
- With `persistence.enabled: false` (lab values), there should be no PVC left
  behind. If you turn persistence on later, uninstall may leave PVCs unless
  you delete them deliberately.

## Guided Steps

1. Confirm the release is present (reinstall if needed):

```bash
cd ~/ncc-training/10-Helm/new-style/08-uninstall-and-cleanup
helm list -n signal-forge
helm status signal-forge -n signal-forge 2>/dev/null || \
  helm install signal-forge jenkins/jenkins -n signal-forge -f values-lab.yaml
```

2. Uninstall:

```bash
helm uninstall signal-forge -n signal-forge
helm list -n signal-forge
```

3. Confirm cluster objects:

```bash
kubectl get all,pvc -n signal-forge
```

Pods/Services from the release should disappear (or show Terminating briefly).
PVCs should be empty because lab values disabled persistence.

4. Optional: remove the namespace entirely:

```bash
kubectl delete namespace signal-forge
```

## Task

Uninstall `signal-forge` and show `helm list` empty for that namespace (or the
namespace deleted).

## Checkpoint

If `persistence.enabled` were `true`, what extra object might still exist after
`helm uninstall`, and why does that matter in a shared training cluster?

## What's Next?
This Helm track is good, but we still need:

1. App-level packaging for *your* services, not only consuming Jenkins.
2. Environment-specific values (dev/stage/prod) as a team habit.
3. CI that runs `helm template` / `--dry-run` on every PR.
4. Chart version pinning so classrooms don't float to breaking chart releases.
5. Capstone deployment practice — continue in **[11-Capstone-Document-Search](../../11-Capstone-Document-Search/README.md)** (and keep using Helm there when charts appear).
