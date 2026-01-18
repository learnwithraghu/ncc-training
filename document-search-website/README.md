# License Renewal Document Processor

A Streamlit-powered web application that processes government license renewal forms using AWS Bedrock AI to extract structured data and convert it to Excel format. The application supports document upload, AI-powered data extraction, Excel download, and automatic S3 storage with date-based organization.

## Features

- 📄 **Document Upload**: Upload PDF license renewal forms
- 🤖 **AI-Powered Extraction**: Uses AWS Bedrock (Claude) to intelligently extract structured data from forms
- 📝 **Advanced PDF Processing**: Uses pdfplumber and PyPDF2 for robust text extraction from various PDF formats
- 📊 **Excel Export**: Download extracted data as Excel files with all extracted fields
- ☁️ **S3 Integration**: Automatically upload processed files to S3 with date-based folder structure (DD/MM/YYYY)
- 🐳 **Dockerized**: Ready for containerized deployment
- 🎨 **Modern UI**: Minimalist, clean interface optimized for government use cases
- 🔍 **Flexible Field Extraction**: Automatically adapts to extract all fields found in the document

## Project Structure

```
document-search-website/
├── app/
│   └── app.py                 # Main Streamlit application
├── sample-documents/          # Sample license renewal forms
│   ├── License_Renewal_Form.pdf
│   ├── Government_License_Renewal_Form.pdf
│   └── Blank_License_Renewal_Form.pdf
├── Dockerfile                 # Docker configuration
├── requirements.txt           # Python dependencies
├── env.example               # Environment variables template
├── .dockerignore             # Docker ignore file
├── GUIDE-01-BUILD-AND-PUSH-TO-ECR.md  # ECR deployment guide
├── GUIDE-02-DEPLOY-TO-ECS.md          # ECS deployment guide
└── README.md                 # This file
```

## Prerequisites

- Python 3.11 or higher
- AWS Account with:
  - Bedrock access (Claude 3 Sonnet model)
  - S3 bucket for file storage
  - IAM credentials with appropriate permissions
- Docker (for containerized deployment)

## Local Setup and Testing

### 1. Clone and Navigate

```bash
cd document-search-website
```

### 2. Create Virtual Environment

```bash
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

### 3. Install Dependencies

```bash
pip install -r requirements.txt
```

### 4. Configure Environment Variables

Create a `.env` file in the root directory:

```bash
cp env.example .env
```

Edit `.env` with your AWS credentials:

```env
# AWS Credentials
AWS_ACCESS_KEY_ID=your_aws_access_key_id
AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key
AWS_REGION=us-east-1

# Bedrock Configuration
BEDROCK_MODEL_ID=anthropic.claude-3-sonnet-20240229-v1:0

# S3 Configuration
S3_BUCKET_NAME=your-s3-bucket-name
```

### 5. Run the Application

```bash
streamlit run app/app.py
```

The application will be available at `http://localhost:8501`

## Docker Setup

### Local Docker Testing

First, create and configure your `.env` file with your AWS credentials:

```bash
cp env.example .env
# Edit .env with your actual credentials
```

Then build and run the image:

```bash
# For local testing on Apple Silicon (M1/M2/M3 Macs)
# Option 1: Build for native platform (faster, recommended for local testing)
docker build --platform linux/arm64 -t license-renewal-processor .
docker run -p 8501:8501 license-renewal-processor

# Option 2: Build for linux/amd64 (slower, emulated via QEMU)
# File watching is automatically disabled to avoid inotify issues
docker build --platform linux/amd64 -t license-renewal-processor .
docker run -p 8501:8501 license-renewal-processor

# For ECS deployment (must use linux/amd64 platform)
docker build --platform linux/amd64 -t license-renewal-processor .
```

**Note**: The Dockerfile includes `STREAMLIT_SERVER_FILE_WATCHER_TYPE=none` to prevent file watching issues when running under QEMU emulation (linux/amd64 on ARM64 hosts).

The application will be available at `http://localhost:8501`

### Production Deployment Guides

For production deployment to AWS, see the comprehensive guides:

- **[GUIDE-01-BUILD-AND-PUSH-TO-ECR.md](GUIDE-01-BUILD-AND-PUSH-TO-ECR.md)** - Build Docker image and push to AWS ECR
- **[GUIDE-02-DEPLOY-TO-ECS.md](GUIDE-02-DEPLOY-TO-ECS.md)** - Deploy to Amazon ECS using AWS Console

## Usage

1. **Upload Document**: Click "Choose a PDF file" and select a license renewal form PDF
2. **Process**: Click "🔄 Process Document" to extract data using Bedrock AI
3. **Review**: View the extracted data in the table format
4. **Download**: Click "📥 Download as Excel" to save the file locally
5. **Upload to S3**: Click "☁️ Upload to S3" to store the file in your S3 bucket

### S3 Storage Structure

Files are organized by date in the following structure:
```
s3://your-bucket-name/
  └── DD/MM/YYYY/
      └── license_renewal_YYYYMMDD_HHMMSS.xlsx
```

Example:
```
s3://my-bucket/
  └── 15/11/2024/
      └── license_renewal_20241115_143022.xlsx
```

## Sample Documents

The `sample-documents/` folder contains:
- **License_Renewal_Form.pdf**: Sample filled license renewal form
- **Government_License_Renewal_Form.pdf**: Another sample filled government license renewal form
- **Blank_License_Renewal_Form.pdf**: Blank form template for testing

These PDF files can be used directly for testing the application.

## AWS Permissions Required

Your AWS IAM user/role needs the following permissions:

### For Application Runtime
- **Bedrock**: `bedrock:InvokeModel`, `bedrock:InvokeModelWithResponseStream`
- **S3**: `s3:PutObject`, `s3:GetObject` (for your S3 bucket)

### For Docker Image Push to ECR
To push Docker images to AWS ECR, you need the following permissions:
- **ECR**: `ecr:GetAuthorizationToken` (required for Docker login)
- **ECR**: `ecr:BatchCheckLayerAvailability`
- **ECR**: `ecr:GetDownloadUrlForLayer`
- **ECR**: `ecr:BatchGetImage`
- **ECR**: `ecr:PutImage`
- **ECR**: `ecr:InitiateLayerUpload`
- **ECR**: `ecr:UploadLayerPart`
- **ECR**: `ecr:CompleteLayerUpload`
- **ECR**: `ecr:CreateRepository` (if creating repository via CLI)
- **ECR**: `ecr:DescribeRepositories` (to verify repository exists)

### Quick Setup (Recommended for Development/Testing)

**Option 1: Use Admin Access (Simplest)**
- Attach `AdministratorAccess` policy to your IAM user/role
- This provides all necessary permissions including ECR, Bedrock, and S3

**Option 2: Use Managed Policies**
- Attach `AmazonEC2ContainerRegistryFullAccess` for ECR operations
- Attach `AmazonS3FullAccess` for S3 operations (or restrict to specific bucket)
- Attach custom policy for Bedrock access (see below)

### Minimal Custom Policy (If Not Using Admin Access)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "bedrock:InvokeModel",
        "bedrock:InvokeModelWithResponseStream"
      ],
      "Resource": "arn:aws:bedrock:*::foundation-model/anthropic.claude-3-sonnet-20240229-v1:0"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject"
      ],
      "Resource": "arn:aws:s3:::your-bucket-name/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:CreateRepository",
        "ecr:DescribeRepositories"
      ],
      "Resource": "*"
    }
  ]
}
```

**Note**: For production environments, use least-privilege access and restrict ECR permissions to specific repositories.

## Troubleshooting

### Bedrock Access Issues
- Ensure Bedrock is enabled in your AWS region
- Verify the model ID is correct for your region
- Check IAM permissions for Bedrock access

### S3 Upload Issues
- Verify the bucket name is correct
- Ensure the bucket exists and is accessible
- Check IAM permissions for S3 PutObject

### PDF Processing Issues
- Ensure uploaded files are valid PDFs
- Check that the PDF contains extractable text (not just images)
- If text extraction is minimal, the PDF might be image-based and require OCR preprocessing
- The application uses pdfplumber (primary) and PyPDF2 (fallback) for text extraction

### Docker Platform Issues
- **Error: `OSError: [Errno 38] Function not implemented`**: This occurs when running linux/amd64 images on ARM64 hosts (Apple Silicon). The Dockerfile now disables file watching automatically. If you still encounter issues:
  - For local testing: Build for your native platform: `docker build --platform linux/arm64 -t license-renewal-processor .`
  - For production: The linux/amd64 build should work with file watching disabled (already configured)
- **Platform mismatch warnings**: These are harmless when running linux/amd64 on ARM64, but performance will be slower due to emulation. For better local performance, use `--platform linux/arm64` when building.

## Development

### Project Structure
- `app/app.py`: Main Streamlit application with all business logic
- `requirements.txt`: Python package dependencies
- `Dockerfile`: Container configuration with .env baking

### Adding New Fields

To extract additional fields, modify the prompt in the `convert_to_table_with_bedrock()` function in `app/app.py`:

```python
{
    "applicant_name": "",
    "license_number": "",
    # Add your new field here
    "new_field": ""
}
```

## License

This project is part of the NCC Training repository.

## Support

For issues or questions, please refer to the main NCC Training repository documentation.
