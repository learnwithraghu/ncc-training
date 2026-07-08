# Day 5, Capstone Guide 7: Final Demo

## Goal
Present the complete end-to-end deployment and demonstrate a working application.

## Time
Approximately **20 minutes**.

---

## Demo Checklist

Use this checklist during your final demo:

- [ ] Show the GitHub repository with all code
- [ ] Show the Dockerfile and explain the image layers
- [ ] Run `docker compose up -d` and show the local app
- [ ] Show Kubernetes pods running
- [ ] Show the Helm release installed
- [ ] Access the application via port-forward or NodePort
- [ ] Scale the deployment and show new pods
- [ ] Rollback a Helm release and verify

## Suggested Demo Script

```bash
# 1. Show the repo structure
cd ~/ncc-labs
tree -L 2

# 2. Show Docker image
docker images | grep document-search

# 3. Run locally
cd day5/document-search
docker compose up -d
curl http://localhost:5000/health

# 4. Deploy to Kubernetes
kubectl apply -f k8s/
kubectl get pods

# 5. Deploy with Helm
helm install doc-search ./document-search-chart
helm list

# 6. Access the app
kubectl port-forward svc/document-search 5000:5000 &
curl http://localhost:5000/

# 7. Scale
kubectl scale deployment document-search --replicas=3
kubectl get pods

# 8. Cleanup
docker compose down
helm uninstall doc-search
kubectl delete -f k8s/
```

## Presentation Tips

- Explain one concept at a time
- Show the connection between days
- Highlight what you would change for production (registry, ingress, monitoring)

## Congratulations!

You have completed the NCC DevOps Bootcamp. You now have hands-on experience with Linux, Bash, Python, Git, GitHub, Docker, Docker Compose, Jenkins, GitHub Actions, ECR, Kubernetes, Helm, and a real capstone project.
