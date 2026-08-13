# Topic 2: Configure the AWS CLI

**Time:** ~20 minutes

## What You'll Learn (and Solve)

1. Run `aws configure` with instructor-provided access keys.
2. Set the default region to `us-east-1` and output format to `json`.
3. Prove credentials work with `aws sts get-caller-identity`.
4. Confirm the `orbital-relay` ECR repository exists before you build.
5. Solve "aws is installed, but every API call fails with credentials."

## Goal
Configure the AWS CLI so later topics can log in to ECR and push the
Orbital Relay image. This folder is self-contained — no manifests.

Unlike the Docker module (instance IAM role only), this Kubernetes module
**does** use `~/.aws/credentials` from `aws configure`.

## Commands to Teach

```bash
aws configure
aws sts get-caller-identity
aws ecr describe-repositories --region us-east-1
```

- `aws configure` writes access key, secret, region, and output format to
  `~/.aws/credentials` and `~/.aws/config`.
- `sts get-caller-identity` is the smoke test that those credentials work.
- `ecr describe-repositories` confirms the registry your image will land in
  (the instructor creates the `orbital-relay` repository ahead of class).

## Guided Steps

1. Confirm AWS CLI v2 is available from Topic 1:

```bash
aws --version
```

2. Configure credentials with the access key and secret your instructor
   gives you:

```bash
aws configure
```

Enter:

- **AWS Access Key ID** — from the instructor
- **AWS Secret Access Key** — from the instructor
- **Default region name** — `us-east-1`
- **Default output format** — `json`

3. Prove the identity:

```bash
aws sts get-caller-identity
```

You should see JSON with `UserId`, `Account`, and `Arn`. Save the
`Account` value — you need it for the ECR URI in Topic 3.

4. Confirm the Orbital Relay ECR repository exists:

```bash
aws ecr describe-repositories \
  --repository-names orbital-relay \
  --region us-east-1
```

If this fails with `RepositoryNotFoundException`, stop and tell the
instructor before building an image.

5. Optional check that config files were written:

```bash
ls -la ~/.aws/
cat ~/.aws/config
```

Do not paste secret keys into chat, screenshots, or shared notes.

## Task

Complete `aws configure` for `us-east-1`, get a successful
`aws sts get-caller-identity`, and confirm the `orbital-relay` ECR
repository exists.

## Checkpoint

Why do we verify `sts get-caller-identity` *before* attempting
`docker push` to ECR?

## What's Next?

This is good, but we still need:

1. A Docker engine on this host so we can build a container image.
2. The Orbital Relay page baked into an image, not only credentials.
3. A local smoke test (`docker run` + `curl`) before anything hits the
   cluster.
4. An image in ECR that Kubernetes nodes can pull.
5. Install Docker (if needed), build, and push — **Topic 3: Build the
   Docker Image**.
