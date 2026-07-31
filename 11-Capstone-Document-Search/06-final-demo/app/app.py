"""
License Renewal Document Processor

Upload a PDF license renewal form, extract text locally, call an OpenAI-compatible
LLM HTTP endpoint, and download structured results as Excel.

No Bedrock. No S3.
"""
import json
import logging
import os
from datetime import datetime
from io import BytesIO
from typing import Dict, Optional

import pandas as pd
import PyPDF2
import requests
import streamlit as st
from dotenv import load_dotenv

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    handlers=[logging.StreamHandler()],
)
logger = logging.getLogger(__name__)

load_dotenv()

st.set_page_config(
    page_title="License Renewal Document Processor",
    page_icon="📄",
    layout="centered",
    initial_sidebar_state="collapsed",
)

st.markdown(
    """
    <style>
    .main { padding: 2rem 1rem; }
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
    h1 { color: #1f2937; font-weight: 600; }
    #MainMenu {visibility: hidden;}
    footer {visibility: hidden;}
    header {visibility: hidden;}
    </style>
    """,
    unsafe_allow_html=True,
)


def llm_config_ok():
    """Return True when LLM env vars are present."""
    key = os.getenv("LLM_API_KEY")
    endpoint = os.getenv("LLM_API_ENDPOINT")
    model = os.getenv("LLM_MODEL")
    missing = [
        name
        for name, value in (
            ("LLM_API_KEY", key),
            ("LLM_API_ENDPOINT", endpoint),
            ("LLM_MODEL", model),
        )
        if not value or value.startswith("your_")
    ]
    if missing:
        st.error(
            "Missing or placeholder LLM settings in `.env`: "
            + ", ".join(missing)
        )
        return False
    return True


def extract_text_from_pdf(pdf_file):
    """Extract text content from PDF using pdfplumber or PyPDF2."""
    try:
        logger.info("Starting text extraction from PDF: %s", pdf_file.name)
        try:
            import pdfplumber

            pdf_file.seek(0)
            with pdfplumber.open(pdf_file) as pdf:
                logger.info("PDF has %s pages", len(pdf.pages))
                text = ""
                for page in pdf.pages:
                    page_text = page.extract_text()
                    if page_text:
                        text += page_text + "\n"
                return text if text.strip() else None
        except ImportError:
            logger.info("pdfplumber not available, using PyPDF2")
            pdf_file.seek(0)
            pdf_reader = PyPDF2.PdfReader(pdf_file)
            text = ""
            for page in pdf_reader.pages:
                page_text = page.extract_text()
                if page_text:
                    text += page_text + "\n"
            return text if text.strip() else None
    except Exception as exc:
        logger.error("Error extracting text from PDF: %s", exc, exc_info=True)
        st.error(f"Error extracting text from PDF: {exc}")
        return None


def call_llm(prompt: str) -> Optional[str]:
    """Call OpenAI-compatible chat completions endpoint."""
    endpoint = os.getenv("LLM_API_ENDPOINT")
    api_key = os.getenv("LLM_API_KEY")
    model = os.getenv("LLM_MODEL")

    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json",
    }
    body = {
        "model": model,
        "messages": [{"role": "user", "content": prompt}],
        "temperature": 0.1,
    }

    logger.info("Calling LLM endpoint: %s model=%s", endpoint, model)
    response = requests.post(endpoint, headers=headers, json=body, timeout=120)
    response.raise_for_status()
    payload = response.json()

    choices = payload.get("choices") or []
    if not choices:
        logger.error("LLM response missing choices: %s", payload)
        st.error("Empty response from LLM endpoint")
        return None

    message = choices[0].get("message") or {}
    content = message.get("content")
    if not content:
        # Some providers return plain text under "text"
        content = choices[0].get("text")
    if not content:
        st.error("LLM response did not include message content")
        return None
    return content


def convert_to_table_with_llm(text_content: str) -> Optional[Dict]:
    """Use the configured LLM endpoint to extract structured fields."""
    try:
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

        text_response = call_llm(prompt)
        if not text_response:
            return None

        json_start = text_response.find("{")
        json_end = text_response.rfind("}") + 1
        if json_start != -1 and json_end > json_start:
            parsed_data = json.loads(text_response[json_start:json_end])
        else:
            parsed_data = json.loads(text_response)

        logger.info("Successfully extracted %s fields", len(parsed_data))
        return parsed_data
    except requests.HTTPError as exc:
        logger.error("LLM HTTP error: %s", exc, exc_info=True)
        st.error(f"LLM HTTP error: {exc}")
        if exc.response is not None:
            st.error(exc.response.text[:500])
        return None
    except json.JSONDecodeError as exc:
        logger.error("Failed to parse JSON from LLM: %s", exc)
        st.error("Failed to parse JSON response from LLM")
        return None
    except Exception as exc:
        logger.error("Error calling LLM: %s", exc, exc_info=True)
        st.error(f"Error calling LLM: {exc}")
        return None


def create_excel_file(data_dict):
    """Convert dictionary to Excel bytes."""
    try:
        df = pd.DataFrame([data_dict])
        output = BytesIO()
        with pd.ExcelWriter(output, engine="openpyxl") as writer:
            df.to_excel(writer, index=False, sheet_name="License Renewal Data")
        output.seek(0)
        return output.getvalue()
    except Exception as exc:
        logger.error("Error creating Excel file: %s", exc, exc_info=True)
        st.error(f"Error creating Excel file: {exc}")
        return None


def main():
    st.title("📄 License Renewal Document Processor")
    st.markdown("---")
    st.markdown(
        "Upload a license renewal form PDF. The app extracts text locally, "
        "calls your configured LLM endpoint, and lets you download Excel results."
    )

    if "excel_data" not in st.session_state:
        st.session_state.excel_data = None
    if "table_data" not in st.session_state:
        st.session_state.table_data = None
    if "processed_filename" not in st.session_state:
        st.session_state.processed_filename = None

    if not llm_config_ok():
        st.info(
            "Copy `../.env_example` to `.env` in this folder (or the module root), "
            "set `LLM_API_KEY`, `LLM_API_ENDPOINT`, and `LLM_MODEL`, then restart."
        )
        return

    st.caption(
        f"Model: `{os.getenv('LLM_MODEL')}` · Endpoint configured from `.env`"
    )

    uploaded_file = st.file_uploader(
        "Choose a PDF file",
        type=["pdf"],
        help="Upload a license renewal form in PDF format",
    )

    if uploaded_file is not None:
        st.info(f"📎 File uploaded: {uploaded_file.name} ({uploaded_file.size} bytes)")

        if st.button("🔄 Process Document", type="primary"):
            with st.spinner("Processing document..."):
                st.info("📄 Extracting text from PDF...")
                text_content = extract_text_from_pdf(uploaded_file)

                if text_content:
                    if len(text_content.strip()) < 50:
                        st.warning(
                            "⚠️ Very little text extracted. The PDF may be scanned; "
                            "OCR may be required for better results."
                        )

                    with st.expander("📋 View Extracted Text (Preview)", expanded=False):
                        preview = text_content[:1000]
                        st.text(preview + ("..." if len(text_content) > 1000 else ""))

                    st.info("🤖 Extracting structured data using your LLM endpoint...")
                    table_data = convert_to_table_with_llm(text_content)

                    if table_data:
                        st.success("✅ Document processed successfully!")
                        st.session_state.table_data = table_data

                        st.subheader("Extracted Data")
                        st.dataframe(pd.DataFrame([table_data]), use_container_width=True)

                        st.info("📊 Creating Excel file...")
                        excel_data = create_excel_file(table_data)
                        if excel_data:
                            st.session_state.excel_data = excel_data
                            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
                            st.session_state.processed_filename = (
                                f"license_renewal_{timestamp}.xlsx"
                            )
                            st.download_button(
                                label="📥 Download as Excel",
                                data=excel_data,
                                file_name=st.session_state.processed_filename,
                                mime=(
                                    "application/vnd.openxmlformats-officedocument"
                                    ".spreadsheetml.sheet"
                                ),
                            )
                else:
                    st.error("Could not extract text from the PDF.")

    elif st.session_state.table_data is not None:
        st.subheader("Last Extracted Data")
        st.dataframe(
            pd.DataFrame([st.session_state.table_data]), use_container_width=True
        )
        if st.session_state.excel_data and st.session_state.processed_filename:
            st.download_button(
                label="📥 Download as Excel",
                data=st.session_state.excel_data,
                file_name=st.session_state.processed_filename,
                mime=(
                    "application/vnd.openxmlformats-officedocument"
                    ".spreadsheetml.sheet"
                ),
            )


if __name__ == "__main__":
    main()
