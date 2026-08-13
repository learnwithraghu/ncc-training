# Topic 4: Tag and Push

**Time:** ~20 minutes

## What You'll Learn

1. Tag a local image for Docker Hub.
2. Log in as `learnwithraghu` and push.
3. Confirm the Hub tag Kubernetes will pull later.

## Goal

Publish `learnwithraghu/ai-k8-workshop:1.0` so a cluster host can pull
it without building Docker there.

## Commands

```bash
cp ../../.env .env
docker build -t daypack:1.0 .
docker tag daypack:1.0 learnwithraghu/ai-k8-workshop:1.0
docker login -u learnwithraghu
docker push learnwithraghu/ai-k8-workshop:1.0
```

Or use the instructor helper (build + validate + multi-arch push):

```bash
cd ~/ncc-training/15-ai-k8-full-project
bash new-style/helpers/build-and-push.sh
```

## Guided Steps

1. Bring secrets (bake needs `.env` in this folder):

```bash
cd ~/ncc-training/15-ai-k8-full-project/new-style/04-tag-and-push
cp ../../.env .env
```

2. Build (or reuse `daypack:1.0` from topic 03) and tag:

```bash
docker build -t daypack:1.0 .
docker tag daypack:1.0 learnwithraghu/ai-k8-workshop:1.0
```

3. Log in. Username is **`learnwithraghu`**. Use the access token the
   instructor gives you (nothing shows as you type):

```bash
docker login -u learnwithraghu
```

4. Push and confirm Hub shows `:1.0`:

```bash
docker push learnwithraghu/ai-k8-workshop:1.0
```

5. When finished with class push work: `docker logout`.

## Task

Docker Hub lists `learnwithraghu/ai-k8-workshop` with tag `1.0`.

## Checkpoint

Why tag `learnwithraghu/ai-k8-workshop:1.0` instead of only
`daypack:1.0` before `docker push`?

## What's Next?

Pull that image on the cluster with a Deployment.
**Topic 5: Kubernetes Deployment.**
