import streamlit as st
import boto3
import json
import os
from datetime import datetime
import pandas as pd
from io import BytesIO
import PyPDF2
from dotenv import load_dotenv
import logging

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('app.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

# Load environment variables
load_dotenv()

# Configure page
st.set_page_config(
    page_title="License Renewal Document Processor",
    page_icon="📄",
    layout="centered",
    initial_sidebar_state="collapsed"
)

# Custom CSS for minimalist modern design
st.markdown("""
    <style>
    .main {
        padding: 2rem 1rem;
    }
    .stButton>button {
        width: 100%;
        border-radius: 8px;
        padding: 0.5rem 1rem;
        font-weight: 500;
    }
    .stFileUploader {
        border: 2px dashed #e0e0e0;
        border-radius: 8px;
        padding: 2rem;
    }
    h1 {
        color: #1f2937;
        font-weight: 600;
    }
    .success-box {
        padding: 1rem;
        background-color: #f0fdf4;
        border-left: 4px solid #22c55e;
        border-radius: 4px;
        margin: 1rem 0;
    }
    /* Hide Streamlit default footer */
    footer {visibility: hidden;}
    footer:after {
        content: 'Made by kodekloud';
        visibility: visible;
        display: block;
        position: relative;
        padding: 5px;
        top: 2px;
        text-align: center;
        color: #808080;
        font-size: 0.875rem;
    }
    /* Alternative method to hide and replace footer */
    #MainMenu {visibility: hidden;}
    header {visibility: hidden;}
    </style>
""", unsafe_allow_html=True)

# Initialize AWS clients
@st.cache_resource
def init_aws_clients():
    """Initialize AWS clients for Bedrock and S3"""
    try:
        logger.info("Initializing AWS clients...")
        region = os.getenv('AWS_REGION', 'us-east-1')
        logger.info(f"Using AWS region: {region}")
        
        bedrock = boto3.client(
            'bedrock-runtime',
            aws_access_key_id=os.getenv('AWS_ACCESS_KEY_ID'),
            aws_secret_access_key=os.getenv('AWS_SECRET_ACCESS_KEY'),
            region_name=region
        )
        s3 = boto3.client(
            's3',
            aws_access_key_id=os.getenv('AWS_ACCESS_KEY_ID'),
            aws_secret_access_key=os.getenv('AWS_SECRET_ACCESS_KEY'),
            region_name=region
        )
        logger.info("AWS clients initialized successfully")
        return bedrock, s3
    except Exception as e:
        logger.error(f"Error initializing AWS clients: {str(e)}", exc_info=True)
        st.error(f"Error initializing AWS clients: {str(e)}")
        return None, None

def extract_text_from_pdf(pdf_file):
    """Extract text content from PDF file using PyPDF2 or pdfplumber"""
    try:
        logger.info(f"Starting text extraction from PDF: {pdf_file.name}")
        # Try pdfplumber first (better extraction)
        try:
            import pdfplumber
            pdf_file.seek(0)  # Reset file pointer
            with pdfplumber.open(pdf_file) as pdf:
                logger.info(f"PDF has {len(pdf.pages)} pages")
                text = ""
                for i, page in enumerate(pdf.pages):
                    page_text = page.extract_text()
                    if page_text:
                        text += page_text + "\n"
                        logger.debug(f"Extracted {len(page_text)} characters from page {i+1}")
                extracted_length = len(text.strip())
                logger.info(f"Extracted {extracted_length} characters total from PDF")
                return text if text.strip() else None
        except ImportError:
            logger.info("pdfplumber not available, using PyPDF2")
            # Fallback to PyPDF2
            pdf_file.seek(0)  # Reset file pointer
            pdf_reader = PyPDF2.PdfReader(pdf_file)
            logger.info(f"PDF has {len(pdf_reader.pages)} pages")
            text = ""
            for i, page in enumerate(pdf_reader.pages):
                page_text = page.extract_text()
                if page_text:
                    text += page_text + "\n"
            extracted_length = len(text.strip())
            logger.info(f"Extracted {extracted_length} characters total from PDF")
            return text if text.strip() else None
    except Exception as e:
        logger.error(f"Error extracting text from PDF: {str(e)}", exc_info=True)
        st.error(f"Error extracting text from PDF: {str(e)}")
        return None

def convert_to_table_with_bedrock(bedrock_client, text_content, model_id=None):
    """Use Bedrock to convert document text to structured table format"""
    try:
        # Get model ID from environment or use default
        if model_id is None:
            model_id = os.getenv('BEDROCK_MODEL_ID', 'anthropic.claude-3-sonnet-20240229-v1:0')
        logger.info(f"Calling Bedrock API with model: {model_id}")
        logger.info(f"Input text length: {len(text_content)} characters")
        
        prompt = f"""You are a document processing assistant specialized in extracting structured data from government license renewal forms.

Extract ALL information from the following license renewal form document. The document content is:

{text_content}

Analyze the document and extract all fields and their corresponding values. Return the data as a JSON object with the following structure. Map the fields from the document to these standard fields:

{{
    "applicant_name": "Full name of the applicant/license holder",
    "license_number": "License number or ID",
    "license_type": "Type of license (e.g., Driver's License, Professional License, etc.)",
    "expiry_date": "Current expiration date of the license",
    "renewal_date": "Date of renewal application or renewal date",
    "address": "Complete address (street, city, state, zip)",
    "contact_number": "Phone number or contact number",
    "email": "Email address",
    "payment_status": "Payment status (Paid, Pending, etc.)",
    "payment_amount": "Amount paid (if mentioned)",
    "transaction_id": "Transaction or payment reference number (if mentioned)",
    "date_of_birth": "Date of birth (if mentioned)",
    "previous_violations": "Any violations or disciplinary actions (if mentioned)",
    "additional_notes": "Any additional information, notes, or remarks"
}}

Important instructions:
1. Extract values exactly as they appear in the document
2. If a field is not present in the document, set it to "N/A"
3. For dates, preserve the format as shown in the document
4. Include ALL fields you find, even if they don't match the standard fields above - add them as additional fields
5. Return ONLY valid JSON, no markdown formatting, no code blocks, no additional text before or after the JSON
6. Ensure all string values are properly quoted and escaped if needed"""

        # Check if using Claude 3 (new API) or older models
        if "claude-3" in model_id:
            body = json.dumps({
                "anthropic_version": "bedrock-2023-05-31",
                "max_tokens": 2000,  # Increased for better extraction
                "messages": [
                    {
                        "role": "user",
                        "content": prompt
                    }
                ]
            })
        else:
            # For older Claude models
            body = json.dumps({
                "prompt": prompt,
                "max_tokens_to_sample": 2000  # Increased for better extraction
            })

        logger.info("Sending request to Bedrock...")
        response = bedrock_client.invoke_model(
            modelId=model_id,
            body=body
        )
        logger.info("Received response from Bedrock")

        response_body = json.loads(response['body'].read())
        
        # Handle Claude 3 response format
        if "claude-3" in model_id:
            content = response_body.get('content', [])
            if content and len(content) > 0:
                text_response = content[0].get('text', '')
            else:
                st.error("Empty response from Bedrock")
                return None
        else:
            # Handle older Claude models
            text_response = response_body.get('completion', '')
        
        # Extract JSON from response
        try:
            logger.info("Parsing JSON response from Bedrock")
            # Try to find JSON in the response
            json_start = text_response.find('{')
            json_end = text_response.rfind('}') + 1
            if json_start != -1 and json_end > json_start:
                json_str = text_response[json_start:json_end]
                parsed_data = json.loads(json_str)
                logger.info(f"Successfully extracted {len(parsed_data)} fields from document")
                return parsed_data
            else:
                parsed_data = json.loads(text_response)
                logger.info(f"Successfully extracted {len(parsed_data)} fields from document")
                return parsed_data
        except json.JSONDecodeError as e:
            logger.error(f"Failed to parse JSON response from Bedrock: {str(e)}")
            logger.error(f"Response preview: {text_response[:200]}")
            st.error("Failed to parse JSON response from Bedrock")
            st.error(f"Response was: {text_response[:200]}")
            return None
            
    except Exception as e:
        logger.error(f"Error calling Bedrock: {str(e)}", exc_info=True)
        st.error(f"Error calling Bedrock: {str(e)}")
        return None

def create_excel_file(data_dict):
    """Convert dictionary to Excel file"""
    try:
        logger.info("Creating Excel file from extracted data")
        # Create DataFrame
        df = pd.DataFrame([data_dict])
        logger.info(f"Excel file will contain {len(df.columns)} columns")
        
        # Create Excel file in memory
        output = BytesIO()
        with pd.ExcelWriter(output, engine='openpyxl') as writer:
            df.to_excel(writer, index=False, sheet_name='License Renewal Data')
        
        output.seek(0)
        file_size = len(output.getvalue())
        logger.info(f"Excel file created successfully ({file_size} bytes)")
        return output.getvalue()
    except Exception as e:
        logger.error(f"Error creating Excel file: {str(e)}", exc_info=True)
        st.error(f"Error creating Excel file: {str(e)}")
        return None

def upload_to_s3(s3_client, file_data, filename, bucket_name):
    """Upload file to S3 with date-based folder structure"""
    try:
        # Validate inputs
        if not file_data:
            logger.error("No file data provided for S3 upload")
            st.error("No file data to upload")
            return None
        
        if not bucket_name:
            logger.error("S3 bucket name not provided")
            st.error("S3 bucket name not configured")
            return None
        
        # Get current date in YYYY/MM/DD format
        current_date = datetime.now().strftime("%Y/%m/%d")
        
        # Create S3 key with date folder structure (processed data)
        s3_key = f"processed-data/{current_date}/{filename}"
        file_size = len(file_data)
        
        logger.info(f"Uploading processed Excel file to S3: s3://{bucket_name}/{s3_key} ({file_size} bytes)")
        
        # Verify bucket exists and is accessible
        try:
            s3_client.head_bucket(Bucket=bucket_name)
            logger.info(f"Bucket {bucket_name} is accessible")
        except Exception as e:
            logger.error(f"Bucket {bucket_name} is not accessible: {str(e)}")
            st.error(f"Cannot access S3 bucket: {bucket_name}. Please check permissions and bucket name.")
            return None
        
        # Upload file
        response = s3_client.put_object(
            Bucket=bucket_name,
            Key=s3_key,
            Body=file_data,
            ContentType='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            ServerSideEncryption='AES256'  # Enable encryption
        )
        
        # Verify upload was successful
        if response.get('ResponseMetadata', {}).get('HTTPStatusCode') == 200:
            logger.info(f"File successfully uploaded to S3: {s3_key}")
            logger.info(f"ETag: {response.get('ETag', 'N/A')}")
            return s3_key
        else:
            logger.error(f"Unexpected response from S3: {response}")
            st.error("Upload completed but received unexpected response from S3")
            return None
            
    except Exception as e:
        # Check for specific S3 errors
        error_str = str(e)
        if 'NoSuchBucket' in error_str or '404' in error_str:
            error_msg = f"S3 bucket '{bucket_name}' does not exist"
            logger.error(error_msg)
            st.error(error_msg)
            return None
        elif hasattr(e, 'response'):
            # Boto3 ClientError
            error_code = e.response.get('Error', {}).get('Code', 'Unknown')
            error_msg = e.response.get('Error', {}).get('Message', str(e))
            logger.error(f"S3 ClientError [{error_code}]: {error_msg}", exc_info=True)
            st.error(f"S3 Error [{error_code}]: {error_msg}")
            return None
        else:
            logger.error(f"Error uploading to S3: {str(e)}", exc_info=True)
            st.error(f"Error uploading to S3: {str(e)}")
            return None

def main():
    st.title("📄 License Renewal Document Processor")
    st.markdown("---")
    st.markdown("Upload a license renewal form to convert it into a structured table format.")
    
    # Initialize session state
    if 'excel_data' not in st.session_state:
        st.session_state.excel_data = None
    if 'table_data' not in st.session_state:
        st.session_state.table_data = None
    if 'processed_filename' not in st.session_state:
        st.session_state.processed_filename = None
    
    # Initialize AWS clients
    bedrock, s3 = init_aws_clients()
    
    if bedrock is None or s3 is None:
        st.error("Failed to initialize AWS clients. Please check your AWS credentials in the .env file.")
        return
    
    # File upload
    uploaded_file = st.file_uploader(
        "Choose a PDF file",
        type=['pdf'],
        help="Upload a license renewal form in PDF format"
    )
    
    if uploaded_file is not None:
        # Display file info
        logger.info(f"File uploaded: {uploaded_file.name} ({uploaded_file.size} bytes)")
        st.info(f"📎 File uploaded: {uploaded_file.name} ({uploaded_file.size} bytes)")
        
        # Process button
        if st.button("🔄 Process Document", type="primary"):
            logger.info("Processing document started")
            with st.spinner("Processing document..."):
                # Extract text from PDF
                st.info("📄 Extracting text from PDF...")
                text_content = extract_text_from_pdf(uploaded_file)
                
                if text_content:
                    # Check if text extraction was successful
                    if len(text_content.strip()) < 50:
                        logger.warning("Very little text extracted from PDF - possible image-based document")
                        st.warning("⚠️ Very little text extracted from PDF. The document might be image-based or scanned. OCR may be required for better results.")
                    
                    # Show extracted text preview
                    with st.expander("📋 View Extracted Text (Preview)", expanded=False):
                        st.text(text_content[:1000] + ("..." if len(text_content) > 1000 else ""))
                    
                    # Convert to table using Bedrock
                    st.info("🤖 Extracting structured data using Bedrock AI...")
                    table_data = convert_to_table_with_bedrock(bedrock, text_content)
                    
                    if table_data:
                        logger.info("Document processing completed successfully")
                        st.success("✅ Document processed successfully!")
                        
                        # Store in session state
                        st.session_state.table_data = table_data
                        
                        # Display the extracted data
                        st.subheader("Extracted Data")
                        df = pd.DataFrame([table_data])
                        st.dataframe(df, use_container_width=True)
                        
                        # Create Excel file
                        st.info("📊 Creating Excel file...")
                        excel_data = create_excel_file(table_data)
                        
                        if excel_data:
                            # Store in session state for later use
                            st.session_state.excel_data = excel_data
                            timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
                            st.session_state.processed_filename = f"license_renewal_{timestamp}.xlsx"
                            
                            # Download button
                            st.download_button(
                                label="📥 Download as Excel",
                                data=excel_data,
                                file_name=st.session_state.processed_filename,
                                mime="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                            )
                            
    # Show S3 upload section if data was processed
    if st.session_state.excel_data and st.session_state.table_data:
        st.markdown("---")
        st.subheader("Upload Processed Data to S3")
        
        bucket_name = os.getenv('S3_BUCKET_NAME')
        if bucket_name:
            st.info(f"📦 Bucket: `{bucket_name}`")
            
            if st.button("☁️ Upload Excel to S3", type="primary", key="upload_s3_persistent"):
                logger.info("S3 upload initiated (persistent)")
                try:
                    with st.spinner("Uploading processed Excel file to S3..."):
                        s3_key = upload_to_s3(s3, st.session_state.excel_data, st.session_state.processed_filename, bucket_name)
                        
                        if s3_key:
                            st.success(f"✅ Processed Excel file uploaded successfully to S3!")
                            st.info(f"📍 S3 Location: `s3://{bucket_name}/{s3_key}`")
                            logger.info(f"S3 upload completed: {s3_key}")
                        else:
                            st.error("❌ Failed to upload file to S3. Check logs for details.")
                except Exception as e:
                    logger.error(f"S3 upload error: {str(e)}", exc_info=True)
                    st.error(f"❌ Error uploading to S3: {str(e)}")
        else:
            st.warning("⚠️ S3_BUCKET_NAME not configured in .env file")

if __name__ == "__main__":
    main()
