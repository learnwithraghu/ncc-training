"""
Daypack — a simple AI trip planner.

Enter a destination, days, pace, and interests. LangChain calls a
KodeKloud OpenAI-compatible API. Streamlit shows an itinerary, food
ideas, a packing list, and a short follow-up chat.
"""
from __future__ import annotations

import os
from pathlib import Path

import streamlit as st
from dotenv import load_dotenv
from langchain_core.messages import HumanMessage, SystemMessage
from langchain_openai import ChatOpenAI

# Load .env from the working directory (local) or baked into the image.
load_dotenv(Path(__file__).resolve().parent / ".env")
load_dotenv()

INTERESTS = [
    "Food",
    "Museums",
    "Nature",
    "Nightlife",
    "Shopping",
    "History",
    "Adventure",
    "Relaxation",
]

SYSTEM_PROMPT = """You are Daypack, a friendly travel planner.
Given destination, number of days, pace, and interests, write a clear
Markdown plan with these sections only:

## Overview
One short paragraph.

## Day-by-day itinerary
One subsection per day (### Day 1, ### Day 2, ...). 2–4 activities each.

## Food ideas
3–5 local dishes or restaurant styles.

## Packing list
8–12 practical items for this trip.

Keep language warm and practical. Do not invent real booking links.
Do not claim live weather or prices.
"""


def require_config() -> tuple[str, str, str]:
    """Read classroom env vars. Keys match the module .env file."""
    base_url = (os.getenv("ai-url") or "").strip()
    api_key = (os.getenv("ai-key") or "").strip()
    model = (os.getenv("model") or "").strip()
    missing = [
        name
        for name, value in (
            ("ai-url", base_url),
            ("ai-key", api_key),
            ("model", model),
        )
        if not value or value == "replace-me"
    ]
    if missing:
        st.error(
            "Missing or placeholder values in `.env`: "
            + ", ".join(missing)
            + ". Copy `.env_example` to `.env` and fill them in."
        )
        st.stop()
    return base_url, api_key, model


def make_llm() -> ChatOpenAI:
    base_url, api_key, model = require_config()
    return ChatOpenAI(
        base_url=base_url,
        api_key=api_key,
        model=model,
        temperature=0.7,
    )


def build_trip_prompt(
    destination: str,
    days: int,
    pace: str,
    interests: list[str],
) -> str:
    interest_text = ", ".join(interests) if interests else "general sightseeing"
    return (
        f"Plan a {days}-day trip to {destination}.\n"
        f"Pace: {pace}.\n"
        f"Interests: {interest_text}.\n"
        "Write the full Markdown plan now."
    )


def ask_llm(llm: ChatOpenAI, user_text: str, system: str = SYSTEM_PROMPT) -> str:
    messages = [SystemMessage(content=system), HumanMessage(content=user_text)]
    response = llm.invoke(messages)
    content = response.content
    if isinstance(content, list):
        parts = []
        for block in content:
            if isinstance(block, str):
                parts.append(block)
            elif isinstance(block, dict) and "text" in block:
                parts.append(str(block["text"]))
        return "\n".join(parts).strip()
    return str(content).strip()


def main() -> None:
    st.set_page_config(
        page_title="Daypack",
        page_icon="🎒",
        layout="centered",
        initial_sidebar_state="expanded",
    )

    st.markdown(
        """
        <style>
        #MainMenu {visibility: hidden;}
        footer {visibility: hidden;}
        h1 { font-weight: 650; }
        </style>
        """,
        unsafe_allow_html=True,
    )

    st.title("Daypack")
    st.caption("AI trip planner — destination in, itinerary out.")

    if "plan" not in st.session_state:
        st.session_state.plan = ""
    if "destination" not in st.session_state:
        st.session_state.destination = ""

    with st.form("trip_form"):
        destination = st.text_input(
            "Destination",
            placeholder="e.g. Lisbon, Portugal",
        )
        days = st.slider("Number of days", min_value=1, max_value=7, value=3)
        pace = st.selectbox(
            "Pace",
            options=["Relaxed", "Balanced", "Packed"],
            index=1,
        )
        interests = st.multiselect(
            "Interests",
            options=INTERESTS,
            default=["Food", "History"],
        )
        submitted = st.form_submit_button("Plan my trip", type="primary")

    if submitted:
        if not destination.strip():
            st.warning("Enter a destination first.")
        else:
            with st.spinner("Packing your plan..."):
                try:
                    llm = make_llm()
                    prompt = build_trip_prompt(
                        destination.strip(), days, pace, interests
                    )
                    plan = ask_llm(llm, prompt)
                    st.session_state.plan = plan
                    st.session_state.destination = destination.strip()
                except Exception as exc:  # noqa: BLE001 — show API errors in UI
                    st.error(f"Could not reach the AI API: {exc}")

    if st.session_state.plan:
        st.markdown(st.session_state.plan)

        st.divider()
        st.subheader("Ask a follow-up")
        follow_up = st.text_input(
            "Question about this trip",
            placeholder="e.g. Swap day 2 for a beach day?",
            key="follow_up_input",
        )
        if st.button("Ask Daypack"):
            if not follow_up.strip():
                st.warning("Type a follow-up question.")
            else:
                with st.spinner("Thinking..."):
                    try:
                        llm = make_llm()
                        context = (
                            f"Destination: {st.session_state.destination}\n\n"
                            f"Existing plan:\n{st.session_state.plan}\n\n"
                            f"Traveler question: {follow_up.strip()}\n\n"
                            "Answer in short Markdown. Stay practical."
                        )
                        answer = ask_llm(
                            llm,
                            context,
                            system=(
                                "You are Daypack. Answer follow-up questions "
                                "about the trip plan already shown. Be concise."
                            ),
                        )
                        st.markdown(answer)
                    except Exception as exc:  # noqa: BLE001
                        st.error(f"Could not reach the AI API: {exc}")
    else:
        st.info("Fill the form and click **Plan my trip** to get started.")

    with st.sidebar:
        st.markdown("### About")
        st.markdown(
            "Daypack is a classroom demo: LangChain + Streamlit in a "
            "Docker image, then a Kubernetes Deployment and Service."
        )
        st.markdown("Health check path: `/_stcore/health`")


if __name__ == "__main__":
    main()
