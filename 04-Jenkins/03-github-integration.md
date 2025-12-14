# Lesson 3: Connecting GitHub to Jenkins

This lesson covers integrating Jenkins with GitHub repositories. You'll learn how to connect Jenkins to GitHub, trigger builds automatically, and use Jenkinsfiles from your repository.

## Learning Objectives

- Create GitHub Personal Access Token
- Configure GitHub credentials in Jenkins
- Connect Jenkins to a GitHub repository
- Set up webhooks for automatic builds
- Use Jenkinsfiles from repository

## Prerequisites

- Jenkins installed and running (Lesson 1)
- GitHub account
- A GitHub repository (you can use this `ncc-training` repo)
- Basic understanding of Git

## Step 1: Create GitHub Personal Access Token

### Why Personal Access Token?

Jenkins needs authentication to access your GitHub repositories. A Personal Access Token (PAT) provides secure access without using your password.

### Create the Token

1. **Go to GitHub**: https://github.com → Your Profile → Settings

2. **Navigate to**: Developer settings → Personal access tokens → Tokens (classic)

3. **Click**: "Generate new token (classic)"

4. **Configure Token**:
   - **Note**: `Jenkins CI/CD`
   - **Expiration**: Choose appropriate (90 days recommended for learning)
   - **Select scopes**:
     - ✅ `repo` (Full control of private repositories)
     - ✅ `admin:repo_hook` (Full control of repository hooks)
     - ✅ `read:user` (Read user profile data)

5. **Click**: "Generate token"

6. **IMPORTANT**: Copy the token immediately! You won't see it again.
   - Save it securely (password manager, notes, etc.)

## Step 2: Configure GitHub Credentials in Jenkins

### Add Credentials

1. **In Jenkins**: Go to **Manage Jenkins** → **Credentials**

2. **Click**: **System** → **Global credentials (unrestricted)**

3. **Click**: **Add Credentials**

4. **Configure**:
   - **Kind**: `Secret text`
   - **Secret**: Paste your GitHub Personal Access Token
   - **ID**: `github-token`
   - **Description**: `GitHub Personal Access Token`
   
5. **Click**: **OK**

### Verify Credentials

- Your credentials should now appear in the list
- Note the ID: `github-token` (we'll use this later)

## Step 3: Alternative - SSH Key Method

If you prefer SSH keys over tokens:

### Generate SSH Key on Jenkins Server

```bash
# SSH into Jenkins server
ssh -i your-key-pair.pem ubuntu@<JENKINS_IP>

# Generate SSH key
ssh-keygen -t ed25519 -C "jenkins@yourdomain.com" -f ~/.ssh/jenkins_github_key

# Display public key
cat ~/.ssh/jenkins_github_key.pub
```

### Add to GitHub

1. **Copy the public key** (from above command)

2. **GitHub**: Settings → SSH and GPG keys → New SSH key

3. **Paste the key** and save

### Add SSH Key to Jenkins

1. **Jenkins**: Manage Jenkins → Credentials → System → Global credentials

2. **Add Credentials**:
   - **Kind**: `SSH Username with private key`
   - **Username**: `git`
   - **Private Key**: Enter directly (paste private key content from `~/.ssh/jenkins_github_key`)
   - **ID**: `github-ssh-key`
   - **Description**: `GitHub SSH Key`

3. **Click**: **OK**

## Step 4: Create Jenkins Job Connected to GitHub

### Create Pipeline Job

1. **Jenkins Dashboard**: Click **New Item**

2. **Enter Job Name**: `ncc-training-pipeline`

3. **Select**: **Pipeline**

4. **Click**: **OK**

### Configure Pipeline

1. **Scroll to Pipeline section**

2. **Definition**: Select **"Pipeline script from SCM"**

3. **SCM**: Select **Git**

4. **Repository URL**: 
   ```
   https://github.com/your-username/ncc-training.git
   ```
   (Replace with your actual repository URL)

5. **Credentials**: Select your GitHub credentials (`github-token` or `github-ssh-key`)

6. **Branch Specifier**: `*/main` (or `*/master` if your default branch is master)

7. **Script Path**: `04-Jenkins/scripts/Jenkinsfile`

8. **Click**: **Save**

### Test the Connection

1. **Click**: **Build Now**

2. **Check Console Output**:
   - Should show "Checking out code from GitHub..."
   - Should successfully checkout the repository
   - Should find and execute the Jenkinsfile

3. **If it fails**: Check credentials and repository URL

## Step 5: Set Up Webhooks (Automatic Builds)

Webhooks allow GitHub to automatically trigger Jenkins builds when code is pushed.

### Configure GitHub Webhook

1. **Go to your GitHub repository**: Settings → Webhooks → Add webhook

2. **Configure Webhook**:
   - **Payload URL**: `http://<JENKINS_IP>:8080/github-webhook/`
     - Replace `<JENKINS_IP>` with your EC2 public IP
     - Example: `http://54.123.45.67:8080/github-webhook/`
   - **Content type**: `application/json`
   - **Events**: Select "Just the push event"
   - **Active**: ✅ Checked

3. **Click**: **Add webhook**

### Configure Jenkins Job for Webhooks

1. **In your Jenkins job**: Click **Configure**

2. **Build Triggers section**: Check **"GitHub hook trigger for GITScm polling"**

3. **Click**: **Save**

### Test Webhook

1. **Make a small change** to your repository:
   ```bash
   # On your local machine
   echo "# Test" >> README.md
   git add README.md
   git commit -m "Test webhook"
   git push
   ```

2. **Check Jenkins**:
   - A new build should automatically start
   - You'll see it in the build history

3. **Check Webhook Delivery**:
   - GitHub: Settings → Webhooks → Click your webhook
   - View "Recent Deliveries" to see webhook activity

## Step 6: Understanding Jenkinsfile Location

The Jenkinsfile can be in different locations:

### Option 1: Root of Repository
```
repository/
└── Jenkinsfile
```
**Script Path**: `Jenkinsfile`

### Option 2: In a Subdirectory (Our Case)
```
repository/
└── 04-Jenkins/
    └── scripts/
        └── Jenkinsfile
```
**Script Path**: `04-Jenkins/scripts/Jenkinsfile`

### Option 3: Multiple Jenkinsfiles
You can have different Jenkinsfiles for different branches or purposes:
- `Jenkinsfile` - Main pipeline
- `Jenkinsfile.staging` - Staging pipeline
- `Jenkinsfile.production` - Production pipeline

## Step 7: Practice Exercise

### Exercise: Create a Simple Pipeline from GitHub

1. **Create a new file** in your repository: `test-pipeline.groovy`

2. **Add this content**:
```groovy
pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Code checked out from GitHub!'
                sh 'git log -1 --oneline'
            }
        }
        
        stage('List Files') {
            steps {
                sh 'ls -la'
            }
        }
    }
}
```

3. **Create a new Jenkins job** that uses this file:
   - Script Path: `test-pipeline.groovy`

4. **Run the job** and verify it works

## Troubleshooting

### Authentication Failed

**Problem**: "Authentication failed" when checking out code

**Solutions**:
- Verify Personal Access Token is correct
- Check token hasn't expired
- Ensure token has `repo` scope
- Try regenerating the token

### Repository Not Found

**Problem**: "Repository not found" error

**Solutions**:
- Verify repository URL is correct
- Check repository is public or token has access
- Verify credentials are selected in job configuration

### Webhook Not Triggering

**Problem**: Webhook doesn't trigger builds

**Solutions**:
1. **Check webhook delivery**:
   - GitHub: Settings → Webhooks → Recent Deliveries
   - Look for errors

2. **Check Jenkins job configuration**:
   - "GitHub hook trigger" must be checked
   - Job must be saved

3. **Check network**:
   - Jenkins server must be accessible from internet
   - Security group must allow port 8080
   - Firewall must allow connections

4. **Test webhook manually**:
   ```bash
   curl -X POST http://<JENKINS_IP>:8080/github-webhook/ \
     -H "Content-Type: application/json" \
     -d '{"ref":"refs/heads/main"}'
   ```

### Jenkinsfile Not Found

**Problem**: "Jenkinsfile not found"

**Solutions**:
- Check Script Path is correct
- Verify file exists in repository
- Check branch name is correct
- Ensure file is committed and pushed

## Key Takeaways

✅ **Personal Access Tokens**: Secure way to authenticate with GitHub  
✅ **Credentials Management**: Store secrets in Jenkins securely  
✅ **Webhooks**: Enable automatic builds on code push  
✅ **Jenkinsfile Location**: Can be anywhere in repository  
✅ **Version Control**: Pipelines as code in your repository  

## Next Steps

Excellent! Jenkins is now connected to GitHub.

**In the next lesson**, you'll learn how to build Docker images in Jenkins pipelines.

**Before moving on**, make sure:
- ✅ GitHub credentials configured
- ✅ Jenkins job can checkout code from GitHub
- ✅ Webhook triggers builds automatically (optional but recommended)
- ✅ You understand Jenkinsfile location

---

**Ready for the next lesson?** Move to [04-docker-build.md](./04-docker-build.md) to build Docker images in Jenkins!

