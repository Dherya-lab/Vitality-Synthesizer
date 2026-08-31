# ⚡ Vitality Synthesizer

A modern, dark-themed desktop application built with **Python**, **PySide6 (Qt for Python)**, **QML**, and **Google Gemini AI**. 

Vitality Synthesizer pairs continuous physiological telemetry streaming with an autonomous background AI health analyst agent that evaluates rolling telemetry batches every 10 seconds and synthesizes real-time clinical and lifestyle directives.

---

## 🌟 Key Architecture & Features

### 1. Frontend (QML)
- **Left Section — Live Biometric Telemetry Stream**:
  - **Daily Steps**: Live step accumulator and progress towards target.
  - **Sleep Duration & Architecture**: Sleep hours, efficiency, and sleep debt metrics.
  - **Heart Rate & Sinus Waveform**: Live heart rate (BPM) with dynamic pulse indicator and real-time sparkline graph drawn via QML Canvas.
  - **Caloric Balance**: Live tracking of caloric intake vs active metabolic burn.
  - **SpO2 & Autonomic HRV**: Oxygen saturation and Heart Rate Variability in milliseconds.
  - **Telemetry Event Log**: Terminal-style timestamped feed of continuous sensor updates.
  - **Pause / Resume Controls**: Interactive toggle to freeze or resume simulated streaming.

- **Right Section — Agent Insights & Actions Panel**:
  - **Autonomous Agent Status**: Displays live model status and glowing AI neural indicator during analysis.
  - **10-Second Batch Countdown**: Live progress bar and timer tracking the rolling synthesis window.
  - **Vitality Index**: Dynamic composite vitality score (0-100) with color-coded status badge (`OPTIMAL`, `MODERATE`, `ATTENTION_NEEDED`).
  - **Primary Actionable Diagnosis**: Punchy executive summary generated directly by Gemini.
  - **Clinical / Physiological Analysis**: In-depth explanation of physiological correlations.
  - **Action Plan Directives**: Prioritized tactical recommendations categorized by **Workout**, **Nutrition**, **Recovery**, and **Hydration** with urgency tags.
  - **"Synthesize Now" Trigger**: Button to immediately force an out-of-band synthesis cycle.

### 2. Backend (Python & PySide6)
- **`backend/telemetry_simulator.py`**: Simulates realistic multi-metric biometric streams with activity modes (Resting, Desk Work, Brisk Walk, Cardio Burst, Recovery) and rolling historical buffers.
- **`backend/gemini_worker.py`**: Asynchronous background worker (`QRunnable` & `QThreadPool`) that aggregates telemetry batches, serializes into structured JSON, and prompts Google's Gemini API (`google-genai` SDK) using structured JSON output.
- **`backend/vitality_bridge.py`**: Subclasses `QObject`, binding Python signals and properties reactively to the QML UI without blocking the rendering thread.

---

## 🚀 Quick Start

### Prerequisites
- Python 3.10+ (tested on Python 3.14 / 3.12 / 3.11 / 3.10)
- `PySide6` and `google-genai`

### 1. Install Dependencies
```bash
pip install -r requirements.txt
```

### 2. Configure Gemini API Key
Open `.env` (or copy from `.env.example`) and paste your API key from [Google AI Studio](https://aistudio.google.com/app/apikey):

```env
# In .env:
GEMINI_API_KEY=your_actual_gemini_api_key_here
GEMINI_MODEL=gemini-2.5-flash
```

> **Note**: If you don't supply an API key right away, Vitality Synthesizer will automatically run in **Autonomous Simulation Mode** with realistic clinical insights so you can test all UI elements and streaming pipelines immediately without errors!

### 3. Run the Application
```bash
python main.py
```

---

## 📁 Project Structure

```
Vitality Synthesizer/
├── main.py                     # Application entry point & Qt QML engine setup
├── requirements.txt            # Python dependencies
├── .env.example                # Configuration template
├── .env                        # Local configuration & API key placeholder
├── README.md                   # Documentation
├── backend/
│   ├── __init__.py
│   ├── config.py               # Configuration & API key loader
│   ├── telemetry_simulator.py  # Realistic multi-metric biometric sensor simulator
│   ├── gemini_worker.py        # Asynchronous background Gemini API worker
│   └── vitality_bridge.py      # PySide6 QObject connecting backend signals to QML
└── qml/
    ├── main.qml                # Root ApplicationWindow layout
    └── components/
        ├── Theme.qml           # Global color palette & typography
        ├── MetricCard.qml      # Reusable biometric telemetry card with animated gauge
        ├── TelemetryStreamView.qml # Left panel: Live telemetry stream & event feed
        ├── AgentInsightsPanel.qml  # Right panel: Autonomous AI agent insights & actions
        └── SparklineCanvas.qml # QML Canvas sparkline wave renderer
```

---

## 🔑 Where to add your Gemini API Key

You have two simple options:

1. **Option A (Recommended)**: In the `.env` file in the root folder:
   ```env
   GEMINI_API_KEY=AIzaSy...
   ```
2. **Option B**: Directly inside `backend/config.py`:
   ```python
   DEFAULT_API_KEY_PLACEHOLDER = "your_key_here"
   ```
