# Step 01: Application Overview

## Goal
Meet the License Renewal Document Processor, understand its files, and prepare your local secrets file.

## Time
Approximately **20 minutes**.

## What You Are Learning
Before Docker or AWS, start with the **application itself**. This app uploads a PDF, extracts text locally, calls your LLM HTTP endpoint, and lets you download Excel — with **no Bedrock** and **no S3**.

---

## Folder Contents

```text
11-Capstone-Document-Search/
├── .env_example                 ← one shared template for the whole module
├── .gitignore                   ← keeps real .env out of git
└── 01-application-overview/
    ├── guide.md                 ← you are here
    ├── requirements.txt
    ├── app/
    │   └── app.py               ← Streamlit License Renewal app
    └── sample-documents/        ← practice PDFs for upload testing
```

## Walkthrough: What the App Does

1. You upload a license renewal PDF in the browser.
2. The app extracts text with `pdfplumber` (or `PyPDF2`).
3. It sends the text to `LLM_API_ENDPOINT` (OpenAI-compatible chat completions).
4. It shows a structured table and offers an **Excel download**.

There is no cloud document store in this lab. Upload and download stay in the browser.

### Environment variables that matter for the app

| Variable | Purpose |
|----------|---------|
| `LLM_API_KEY` | Bearer token for the LLM API |
| `LLM_API_ENDPOINT` | Full chat-completions URL |
| `LLM_MODEL` | Model name sent in the JSON body |

AWS and ECR variables in `.env_example` are for **later local CLI steps** (push to ECR). The Streamlit app runtime only needs the `LLM_*` values.

---

## Hands-On: Prepare Your Secrets File

```bash
cd 11-Capstone-Document-Search/01-application-overview
cp ../.env_example .env
```

Edit `.env` and set real `LLM_API_KEY`, `LLM_API_ENDPOINT`, and `LLM_MODEL`.

## Optional: Run Without Docker

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
streamlit run app/app.py --server.address=0.0.0.0 --server.port=8501
```

Open `http://127.0.0.1:8501` (or `http://<your-host-ip>:8501`), upload a PDF from `sample-documents/`, and process it.

---

## Checkpoint

1. Which three env vars does the app need at runtime?
2. Where do processed Excel files go — S3 or your browser download?
3. Why are sample PDFs useful before you touch Docker?

## Next Step

Go to **[02-dockerize](../02-dockerize/)** — same application code, plus a Dockerfile that bakes `.env` into the image.
