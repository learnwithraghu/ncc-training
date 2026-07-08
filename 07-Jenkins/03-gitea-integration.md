# Lesson 3: Connecting Gitea to Jenkins

This lesson covers integrating Jenkins with Gitea repositories. You'll learn how to connect Jenkins to Gitea, trigger builds automatically, and use Jenkinsfiles from your repository.

## Learning Objectives

- Create Gitea Access Token
- Configure Gitea credentials in Jenkins
- Connect Jenkins to a Gitea repository
- Set up webhooks for automatic builds
- Use Jenkinsfiles from repository

## Prerequisites

- Jenkins installed and running (Lesson 1)
- Gitea account (creds provided)
- A Gitea repository (we will use `sample-config`)
- Basic understanding of Git

## Step 1: Create Gitea Application Token

### Why Application Token?

Jenkins needs authentication to access your Gitea repositories. An Application Token provides secure access without using your password.

### Create the Token

1. **Go to Gitea**: Log in to your Gitea server.

2. **Navigate to**: Settings (Profile Picture) → Applications

3. **Manage Access Tokens section**:
   - **Token Name**: `jenkins-ci`
   - **Click**: "Generate Token"

4. **IMPORTANT**: Copy the token immediately! You won't see it again.
   - Save it securely.

## Step 2: Configure Gitea Credentials in Jenkins

### Add Credentials

1. **In Jenkins**: Go to **Manage Jenkins** → **Credentials**

2. **Click**: **System** → **Global credentials (unrestricted)**

3. **Click**: **Add Credentials**

4. **Configure**:
   - **Kind**: `Secret text`
   - **Secret**: Paste your Gitea Token
   - **ID**: `gitea-token`
   - **Description**: `Gitea Access Token`
   
5. **Click**: **OK**

### Verify Credentials

- Your credentials should now appear in the list
- Note the ID: `gitea-token` (we'll use this later)

## Step 3: Create Jenkins Job Connected to Gitea

### Create Pipeline Job

1. **Jenkins Dashboard**: Click **New Item**

2. **Enter Job Name**: `sample-config-pipeline`

3. **Select**: **Pipeline**

4. **Click**: **OK**

### Configure Pipeline

1. **Scroll to Pipeline section**

2. **Definition**: Select **"Pipeline script from SCM"**

3. **SCM**: Select **Git**

4. **Repository URL**: 
   ```
   http://gitea-server:3000/username/sample-config.git
   ```
   (Replace `gitea-server:3000` and `username` with your actual Gitea URL and username)

5. **Credentials**: Select your Gitea credentials (`gitea-token`)

6. **Branch Specifier**: `*/main`

7. **Script Path**: `Jenkinsfile` (Assuming you uploaded the sample files to root of the repo)

8. **Click**: **Save**

### Test the Connection

1. **Click**: **Build Now**

2. **Check Console Output**:
   - Should show "Checking out code..."
   - Should successfully checkout the repository
   - Should find and execute the Jenkinsfile

## Step 4: Set Up Webhooks (Automatic Builds)

Webhooks allow Gitea to automatically trigger Jenkins builds when code is pushed.

### Configure Gitea Webhook

1. **Go to your Gitea repository**: Settings → Webhooks → Add Webhook → Gitea

2. **Configure Webhook**:
   - **Target URL**: `http://<JENKINS_IP>:8080/gitea-webhook/post`
     - Replace `<JENKINS_IP>` with your Jenkins IP
   - **HTTP Method**: POST
   - **Post Content Type**: `application/json`
   - **Trigger On**: Push Events
   - **Active**: ✅ Checked

3. **Click**: **Add Webhook**

### Configure Jenkins Job for Webhooks

1. **In your Jenkins job**: Click **Configure**

2. **Build Triggers section**: Check **"Poll SCM"** (standard for some Gitea plugins) or if you have the Gitea plugin installed, look for **Gitea hook** options.
   - *Note*: If using generic Git webhook, ensure standard "GitHub hook trigger for GITScm polling" is checked as a fallback or equivalent generic webhook trigger.

3. **Click**: **Save**

## Step 5: Uploading Sample Files

We have prepared some sample files in `04-Jenkins/sample-config-files`. You should upload these to your `sample-config` repository in Gitea.

1. **Initialize Git in the valid folder** or clone your empty Gitea repo.
2. **Copy** the files from `04-Jenkins/sample-config-files` to your repo folder.
3. **Push** to Gitea.

```bash
# Example
git clone http://gitea-server:3000/username/sample-config.git
cd sample-config
cp /path/to/ncc-training/04-Jenkins/sample-config-files/* .
git add .
git commit -m "Initial commit of sample config"
git push
```

## Key Takeaways

✅ **Gitea Tokens**: Secure way to authenticate  
✅ **Webhooks**: Enable automatic builds  
✅ **Pipelines**: Code from Gitea execution

## Next Steps

**Ready for the next lesson?** Move to [04-docker-build.md](./04-docker-build.md) to build Docker images in Jenkins!
