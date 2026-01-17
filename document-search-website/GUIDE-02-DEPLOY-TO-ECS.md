# Guide 02: Deploy to Amazon ECS using AWS Console

This guide walks you through deploying the License Renewal Document Processor to Amazon ECS using the AWS Management Console (UI).

## Prerequisites

- AWS account with appropriate permissions
- Docker image pushed to ECR (see GUIDE-01-BUILD-AND-PUSH-TO-ECR.md)
- VPC and subnets configured (or use default VPC)
- Security group configured for port 8501
- Application Load Balancer (we'll create one if needed)

## Step 1: Prepare Environment Variables

Ensure your `.env` file has all required variables. You'll need these values during ECS setup:

```env
AWS_ACCESS_KEY_ID=your_aws_access_key_id
AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key
AWS_REGION=us-east-1
BEDROCK_MODEL_ID=anthropic.claude-3-sonnet-20240229-v1:0
S3_BUCKET_NAME=your-s3-bucket-name
ECR_REPOSITORY_NAME=license-renewal-processor
```

## Step 2: Create ECS Cluster

1. **Navigate to ECS Console**
   - Go to [AWS Console](https://console.aws.amazon.com)
   - Search for "ECS" in the services search bar
   - Click on "Elastic Container Service"

2. **Create Cluster**
   - Click "Clusters" in the left sidebar
   - Click "Create cluster" button

3. **Configure Cluster**
   - **Cluster name**: `license-renewal-cluster`
   - **Infrastructure**: Select "AWS Fargate (serverless)"
   - Click "Create" button

4. **Wait for cluster creation** (takes 1-2 minutes)

## Step 3: Create Task Definition

1. **Navigate to Task Definitions**
   - In ECS Console, click "Task definitions" in the left sidebar
   - Click "Create new task definition"

2. **Select Launch Type**
   - Choose "Fargate"
   - Click "Next step"

3. **Configure Task Definition**
   
   **Task definition family**: `license-renewal-processor`
   
   **Container details**:
   - **Container name**: `license-renewal-app`
   - **Image URI**: 
     ```
     <YOUR_ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/license-renewal-processor:latest
     ```
     Replace `<YOUR_ACCOUNT_ID>` with your AWS account ID and `<REGION>` with your region (e.g., `us-east-1`)
   
   **Container port mappings**:
   - **Container port**: `8501`
   - **Protocol**: `TCP`
   - **App protocol**: `http`
   
   **Environment variables**: Click "Add environment variable" and add:
   ```
   AWS_ACCESS_KEY_ID = <your-access-key>
   AWS_SECRET_ACCESS_KEY = <your-secret-key>
   AWS_REGION = us-east-1
   BEDROCK_MODEL_ID = anthropic.claude-3-sonnet-20240229-v1:0
   S3_BUCKET_NAME = <your-bucket-name>
   ```
   
   **Note**: For production, use AWS Secrets Manager or Parameter Store instead of plain environment variables.

4. **Configure Task Size**
   - **Task CPU**: `0.5 vCPU` (512)
   - **Task memory**: `1 GB` (1024)
   
   **Note**: Adjust based on your needs. Minimum for Fargate is 0.25 vCPU and 0.5 GB.

5. **Configure Networking**
   - **Operating system/Architecture**: `Linux/X86_64`

6. **Review and Create**
   - Review all settings
   - Click "Create" button

## Step 4: Create Security Group

1. **Navigate to EC2 Console**
   - Go to EC2 service
   - Click "Security Groups" in the left sidebar
   - Click "Create security group"

2. **Configure Security Group**
   - **Name**: `license-renewal-sg`
   - **Description**: `Security group for License Renewal Processor`
   - **VPC**: Select your VPC (default VPC is fine)

3. **Add Inbound Rules**
   - Click "Add rule"
   - **Type**: `Custom TCP`
   - **Port range**: `8501`
   - **Source**: `0.0.0.0/0` (or restrict to your IP/ALB)
   - **Description**: `Streamlit app port`
   
   **For ALB access** (if using Load Balancer):
   - Add another rule:
   - **Type**: `Custom TCP`
   - **Port range**: `8501`
   - **Source**: Select your ALB security group

4. **Add Outbound Rules**
   - Default "All traffic" is fine (allows ECS to pull images and access AWS services)

5. **Click "Create security group"**

## Step 5: Create Application Load Balancer (Optional but Recommended)

1. **Navigate to EC2 Console**
   - Go to EC2 service
   - Click "Load Balancers" in the left sidebar
   - Click "Create load balancer"

2. **Select Load Balancer Type**
   - Choose "Application Load Balancer"
   - Click "Create"

3. **Configure Load Balancer**
   - **Name**: `license-renewal-alb`
   - **Scheme**: `Internet-facing`
   - **IP address type**: `IPv4`

4. **Network Mapping**
   - **VPC**: Select your VPC
   - **Availability Zones**: Select at least 2 subnets in different AZs
   - **Mappings**: Enable subnets in multiple AZs

5. **Security Groups**
   - Select the security group created in Step 4 (or create a new one for ALB)
   - ALB security group should allow:
     - Inbound: HTTP (80) and HTTPS (443) from `0.0.0.0/0`
     - Outbound: All traffic

6. **Listeners and Routing**
   - **Protocol**: `HTTP`
   - **Port**: `80`
   - **Default action**: Create new target group (we'll configure this later)

7. **Click "Create load balancer"**

## Step 6: Create Target Group (If Using ALB)

1. **Navigate to Target Groups**
   - In EC2 Console, click "Target Groups" in the left sidebar
   - Click "Create target group"

2. **Configure Target Group**
   - **Target type**: `IP addresses`
   - **Target group name**: `license-renewal-tg`
   - **Protocol**: `HTTP`
   - **Port**: `8501`
   - **VPC**: Select your VPC
   - **Health check protocol**: `HTTP`
   - **Health check path**: `/_stcore/health`
   - **Advanced health check settings**:
     - **Healthy threshold**: `2`
     - **Unhealthy threshold**: `3`
     - **Timeout**: `5 seconds`
     - **Interval**: `30 seconds`
     - **Success codes**: `200`

3. **Click "Next"** and then **"Create target group"**

## Step 7: Create ECS Service

1. **Navigate to ECS Cluster**
   - Go back to ECS Console
   - Click on your cluster: `license-renewal-cluster`

2. **Create Service**
   - Click "Services" tab
   - Click "Create" button

3. **Configure Service**
   
   **Compute configuration**:
   - **Launch type**: `Fargate`
   - **Platform version**: `LATEST`
   - **Operating system/Architecture**: `Linux/X86_64`
   
   **Deployment configuration**:
   - **Task definition family**: `license-renewal-processor`
   - **Revision**: `latest` (or select specific revision)
   - **Service name**: `license-renewal-service`
   
   **Desired tasks**:
   - **Desired number of tasks**: `1` (increase for high availability)
   
   **Networking**:
   - **VPC**: Select your VPC
   - **Subnets**: Select at least 2 subnets in different Availability Zones
   - **Security groups**: Select `license-renewal-sg` (created in Step 4)
   - **Auto-assign public IP**: `ENABLED` (required for Fargate to pull images)
   
   **Load balancing** (if using ALB):
   - **Load balancer type**: `Application Load Balancer`
   - **Load balancer name**: Select `license-renewal-alb`
   - **Container to load balance**: 
     - Click "Add to load balancer"
     - **Target group name**: Select `license-renewal-tg`
     - **Container name**: `license-renewal-app:8501`
     - **Production listener port**: `80:HTTP`
     - **Health check grace period**: `60` seconds

4. **Service Auto Scaling** (Optional)
   - You can configure auto-scaling based on CPU/memory metrics
   - For now, leave it disabled or configure later

5. **Review and Create**
   - Review all settings
   - Click "Create" button

6. **Wait for service deployment** (takes 2-5 minutes)

## Step 8: Verify Deployment

1. **Check Service Status**
   - In ECS Console, go to your cluster
   - Click on the service `license-renewal-service`
   - Check "Tasks" tab - should show "Running" status

2. **Check Task Logs**
   - Click on a running task
   - Go to "Logs" tab to view CloudWatch Logs
   - Verify application started successfully

3. **Access Application**

   **If using Load Balancer**:
   - Go to EC2 Console → Load Balancers
   - Copy the DNS name of your ALB
   - Access: `http://<ALB-DNS-NAME>`

   **If not using Load Balancer**:
   - Go to ECS Console → Tasks
   - Click on your running task
   - Copy the "Public IP"
   - Access: `http://<PUBLIC-IP>:8501`

4. **Test Application**
   - Upload a sample PDF
   - Process the document
   - Verify Bedrock extraction works
   - Test S3 upload functionality

## Step 9: Configure CloudWatch Logs (Already Configured)

The application automatically logs to CloudWatch. To view logs:

1. Go to CloudWatch Console
2. Click "Log groups"
3. Find log group: `/ecs/license-renewal-processor`
4. Click on log stream to view application logs

## Step 10: Update Service (For Future Deployments)

When you push a new image to ECR:

1. **Update Task Definition**
   - Go to ECS → Task Definitions
   - Select `license-renewal-processor`
   - Click "Create new revision"
   - Update image tag if needed
   - Click "Create"

2. **Update Service**
   - Go to your service
   - Click "Update"
   - Select new task definition revision
   - Click "Update"
   - Service will perform rolling update

## Troubleshooting

### Issue: Tasks Failing to Start
- Check CloudWatch Logs for errors
- Verify environment variables are correct
- Check security group allows outbound traffic
- Verify ECR image exists and is accessible

### Issue: Cannot Access Application
- Check security group allows inbound traffic on port 8501
- Verify task is running (not stopped)
- Check ALB target group health checks
- Verify public IP assignment (if not using ALB)

### Issue: Bedrock/S3 Access Denied
- Verify IAM task role has necessary permissions
- Check environment variables are set correctly
- Verify AWS credentials in task definition

### Issue: High Memory/CPU Usage
- Increase task CPU/memory in task definition
- Check application logs for memory leaks
- Consider enabling auto-scaling

## Security Best Practices

1. **Use IAM Roles for Tasks** (Recommended)
   - Create IAM role for ECS tasks
   - Attach policies for Bedrock and S3 access
   - Remove AWS credentials from environment variables
   - Attach role to task definition

2. **Use Secrets Manager**
   - Store sensitive data in AWS Secrets Manager
   - Reference secrets in task definition
   - Avoid hardcoding credentials

3. **Enable HTTPS**
   - Configure SSL certificate in ALB
   - Use HTTPS listener (port 443)
   - Redirect HTTP to HTTPS

4. **Restrict Security Groups**
   - Limit inbound access to specific IPs
   - Use ALB instead of direct public access
   - Enable VPC Flow Logs

## Cost Optimization

- **Right-size tasks**: Start with minimum resources, scale up as needed
- **Use Spot instances**: For non-production workloads
- **Enable auto-scaling**: Scale down during low traffic
- **Reserve capacity**: For predictable workloads

## Next Steps

- Set up CloudWatch alarms for monitoring
- Configure auto-scaling policies
- Set up CI/CD pipeline for automated deployments
- Configure custom domain with Route 53
- Enable HTTPS with ACM certificate

## Additional Resources

- [Amazon ECS Documentation](https://docs.aws.amazon.com/ecs/)
- [AWS Fargate Documentation](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html)
- [Application Load Balancer Guide](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/)
- [ECS Best Practices](https://docs.aws.amazon.com/AmazonECS/latest/bestpracticesguide/intro.html)
