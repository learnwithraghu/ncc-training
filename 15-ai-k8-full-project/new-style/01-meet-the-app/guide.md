# Topic 1: Meet the App

**Time:** ~20 minutes

## What You'll Learn

1. What Daypack does (destination in → itinerary out).
2. How `.env` feeds LangChain (`ai-url`, `ai-key`, `model`).
3. Run Streamlit locally on port 8501.

## Goal

See Daypack in the browser before you Dockerize it.

## Commands

```bash
cp ../../.env .env          # or fill from ../../.env_example
pip install -r requirements.txt
streamlit run app.py
```

- `.env` — KodeKloud OpenAI-compatible API settings (never commit a real key).
- `app.py` — Streamlit UI + LangChain `ChatOpenAI`.
- Streamlit listens on **8501**. Health path: `/_stcore/health`.

## Guided Steps

1. `cd` into this folder and bring secrets:

```bash
cd ~/ncc-training/15-ai-k8-full-project/new-style/01-meet-the-app
cp ../../.env .env
# If you have no root .env yet:
# cp ../../.env_example .env
# then edit ai-key
```

2. Install and run:

```bash
pip install -r requirements.txt
streamlit run app.py
```

3. Open `http://localhost:8501`. Enter a destination (for example
   **Lisbon**), pick days and interests, click **Plan my trip**.
4. Ask one follow-up in the form under the plan.

## Task

You get a Markdown itinerary with Overview, Day-by-day, Food ideas, and
Packing list — and a follow-up answer without restarting the app.

## Checkpoint

Which three `.env` keys does the app read? What happens if `ai-key` is
still `replace-me`?

## What's Next?

Next we write a Dockerfile and bake `.env` into the image.
**Topic 2: Dockerize.**
