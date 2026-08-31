# Vitality Synthesizer 🧬🤖

**Vitality Synthesizer** is a next-generation autonomous health agent built for the *All Things Agentic Hackathon*. It moves beyond static data tracking by acting as an always-on wellness analyst, continuously ingesting telemetry streams to dynamically adjust your daily routines.

## 🚀 The Agentic Workflow

Unlike traditional trackers that wait for user queries, Vitality Synthesizer runs asynchronously in the background:

*   **Ingestion:** Continuously monitors a live stream of wellness data (sleep duration, caloric intake, heart rate).
*   **Analysis:** Background Python workers batch this data and send it to the **Google Gemini API**.
*   **Synthesis:** Gemini acts as an autonomous agent, detecting anomalies (e.g., "High fatigue correlated with low protein intake") and generating actionable advice.
*   **Action:** The QML frontend is dynamically updated with new diet and exercise modifications without requiring manual user refreshes.

## 🛠️ Tech Stack

*   **Frontend:** PySide6, QML (Dark-themed, dynamic dashboard)
*   **Backend:** Python (Asynchronous background workers)
*   **AI/Agent Logic:** Google Gemini API
*   **Development Environment:** Google Antigravity IDE


  
