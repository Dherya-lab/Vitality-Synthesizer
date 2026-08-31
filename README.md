<div align="center">

# ⚡ VITALITY SYNTHESIZER

### Autonomous AI Health Intelligence Engine

**Real-Time Biometric Telemetry · Autonomous Gemini Analysis · Actionable Health Directives**

<br>

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:0f2027,50:203a43,100:2c5364&height=220&section=header&text=Vitality%20Synthesizer&fontSize=48&fontColor=ffffff&fontAlignY=40&desc=Autonomous%20AI%20Health%20Intelligence&descAlignY=62&descSize=18" width="100%"/>

<br>

![Python](https://img.shields.io/badge/PYTHON-3.10%2B-3776AB?style=for-the-badge&logo=python&logoColor=white)
![PySide6](https://img.shields.io/badge/PYSIDE6-QT%20FOR%20PYTHON-41CD52?style=for-the-badge&logo=qt&logoColor=white)
![QML](https://img.shields.io/badge/QML-QT%20QUICK-41CD52?style=for-the-badge&logo=qt&logoColor=white)
![Gemini](https://img.shields.io/badge/GEMINI-AI-8E75B2?style=for-the-badge&logo=google&logoColor=white)

![Telemetry](https://img.shields.io/badge/LIVE-TELEMETRY-00A896?style=for-the-badge)
![AI Agent](https://img.shields.io/badge/AUTONOMOUS-AI%20AGENT-FF6F61?style=for-the-badge)
![Async](https://img.shields.io/badge/BACKGROUND-ASYNC%20WORKERS-4361EE?style=for-the-badge)
![License](https://img.shields.io/badge/LICENSE-MIT-20C997?style=for-the-badge)

<br>

**⚡ OBSERVE &nbsp;•&nbsp; 🤖 SYNTHESIZE &nbsp;•&nbsp; 🎯 ACT**

</div>

---

# 🧬 About

**Vitality Synthesizer** is a modern dark-themed desktop health intelligence application built with **Python, PySide6, QML, and Google Gemini AI**.

It combines a continuously streaming physiological telemetry simulator with an autonomous AI health analyst that evaluates rolling biometric batches every **10 seconds**.

The system transforms raw telemetry into:

```text
                    RAW TELEMETRY
                          │
                          ▼
                ┌──────────────────┐
                │  Rolling Buffer   │
                └────────┬─────────┘
                         │
                         ▼
                ┌──────────────────┐
                │ 10-Second Batch   │
                └────────┬─────────┘
                         │
                         ▼
                ┌──────────────────┐
                │   Gemini Agent   │
                └────────┬─────────┘
                         │
                         ▼
              ┌──────────────────────┐
              │ VITALITY INTELLIGENCE│
              └──────────┬───────────┘
                         │
             ┌───────────┼───────────┐
             ▼           ▼           ▼
          SCORE       INSIGHT      ACTIONS
```

The result is a continuously evolving **Vitality Index**, physiological interpretation, and prioritized lifestyle directives.

> **Note:** This project uses simulated physiological telemetry and is intended for educational, experimental, and software demonstration purposes. It is not a medical diagnostic system.

---

# ✨ Key Features

<div align="center">

| 🫀 LIVE TELEMETRY | 🤖 AI INTELLIGENCE | 🎯 ACTION ENGINE |
|:---:|:---:|:---:|
| Real-time biometrics | Autonomous analysis | Workout directives |
| Dynamic heart rate | Gemini synthesis | Nutrition directives |
| Sleep architecture | Vitality scoring | Recovery directives |
| SpO₂ + HRV | Physiological analysis | Hydration directives |
| Caloric balance | Rolling 10s batches | Urgency classification |

</div>

---

# 🖥️ Application Interface

The application is divided into two major intelligence zones:

```text
┌─────────────────────────────────────────────────────────────────────┐
│                        VITALITY SYNTHESIZER                         │
├────────────────────────────────┬────────────────────────────────────┤
│                                │                                    │
│       LIVE TELEMETRY           │        AI AGENT INSIGHTS           │
│                                │                                    │
│  ┌──────────┐  ┌──────────┐   │   ┌────────────────────────────┐   │
│  │  STEPS   │  │   SLEEP  │   │   │      AGENT STATUS          │   │
│  └──────────┘  └──────────┘   │   └────────────────────────────┘   │
│                                │                                    │
│  ┌──────────┐  ┌──────────┐   │   ┌────────────────────────────┐   │
│  │ HEART    │  │ CALORIES │   │   │     VITALITY INDEX         │   │
│  │ RATE     │  │          │   │   │          82 / 100          │   │
│  └──────────┘  └──────────┘   │   └────────────────────────────┘   │
│                                │                                    │
│  ┌──────────┐  ┌──────────┐   │   ┌────────────────────────────┐   │
│  │  SpO₂    │  │   HRV    │   │   │    PRIMARY AI INSIGHT      │   │
│  └──────────┘  └──────────┘   │   └────────────────────────────┘   │
│                                │                                    │
│  LIVE HEART-RATE WAVEFORM      │   ┌────────────────────────────┐   │
│  ╱╲  ╱╲    ╱╲ ╱╲             │   │      ACTION PLAN            │   │
│ ╱  ╲╱  ╲╱╲╱  ╲  ╲            │   │ 🏋 Workout                 │   │
│                                │   │ 🥗 Nutrition               │   │
│  TELEMETRY EVENT STREAM        │   │ 😴 Recovery                │   │
│  [02:31:04] HR 72 BPM          │   │ 💧 Hydration               │   │
│  [02:31:05] SpO₂ 98%           │   └────────────────────────────┘   │
│                                │                                    │
└────────────────────────────────┴────────────────────────────────────┘
```

---

# 📡 Live Biometric Telemetry

The left side of the application provides a continuously updating physiological telemetry stream.

## 🚶 Daily Steps

- Live step accumulator
- Daily target progress
- Activity-dependent step generation
- Animated progress visualization

---

## 😴 Sleep Architecture

Tracks:

- Sleep duration
- Sleep efficiency
- Sleep debt
- Recovery context

---

## ❤️ Heart Rate

Provides:

- Live BPM
- Dynamic pulse indicator
- Sinus-style waveform
- Real-time QML Canvas sparkline

Example telemetry:

```text
HEART RATE

        ╭─╮       ╭─╮
────╮───╯ ╰───────╯ ╰────╮────
    ╰─────────────────────╯

        72 BPM
```

---

## 🔥 Caloric Balance

Tracks:

- Calories consumed
- Active calories burned
- Current caloric balance

---

## 🫁 SpO₂

Live simulated blood oxygen saturation monitoring.

```text
SpO₂
──────
98 %
```

---

## 🧠 Heart Rate Variability

HRV is displayed in milliseconds and used as one of the contextual signals available to the AI analysis layer.

```text
HRV
──────
54 ms
```

---

## 📜 Telemetry Event Log

A terminal-style event stream provides continuous visibility into the simulated sensor pipeline.

```text
[02:31:04] HR      72 BPM
[02:31:05] SpO2    98 %
[02:31:06] STEPS   +12
[02:31:07] HRV     54 ms
[02:31:08] MODE    BRISK WALK
[02:31:09] CAL     +8 kcal
[02:31:10] SYSTEM  TELEMETRY SYNC
```

---

# 🤖 Autonomous AI Health Analyst

The right side of the interface contains the autonomous intelligence layer.

The AI agent continuously evaluates the latest physiological telemetry and synthesizes it into actionable information.

---

## 🟢 Agent Status

The interface displays the current state of the AI worker:

```text
● IDLE
● COLLECTING
● ANALYZING
● SYNTHESIZING
● COMPLETE
```

During active analysis, the interface displays an animated AI/neural indicator.

---

# ⏱️ 10-Second Synthesis Engine

Every **10 seconds**, the latest telemetry window is aggregated and analyzed.

```text
TELEMETRY

00s ──────── 02s ──────── 04s ──────── 06s ──────── 08s ──────── 10s
 │             │             │             │             │            │
 └─────────────┴─────────────┴─────────────┴─────────────┴────────────┘
                              │
                              ▼
                        AI SYNTHESIS
```

The user can also trigger an immediate analysis cycle using:

```text
┌──────────────────────────┐
│     ⚡ SYNTHESIZE NOW    │
└──────────────────────────┘
```

This forces an out-of-band synthesis without waiting for the next scheduled cycle.

---

# 💠 Vitality Index

The AI produces a composite **Vitality Index** ranging from:

```text
0 ─────────────────────────────────────────────────────── 100
LOW                                                     HIGH
```

### Status Classification

| Status | Meaning |
|---|---|
| 🟢 `OPTIMAL` | Overall telemetry indicates a strong state |
| 🟡 `MODERATE` | Some metrics may require attention |
| 🔴 `ATTENTION_NEEDED` | Multiple signals indicate potential concern |

Example:

```text
                 VITALITY INDEX

                     ╭───────╮
                     │  82   │
                     │ /100  │
                     ╰───────╯

                    OPTIMAL
```

> The Vitality Index is a software-generated wellness metric based on simulated data and is not a clinical measurement.

---

# 🩺 AI Insight Engine

Each synthesis generates multiple layers of intelligence.

## 01 — Primary Actionable Insight

A concise executive-level summary.

Example:

```text
Elevated activity combined with reduced recovery
signals suggests prioritizing hydration and recovery
before the next high-intensity session.
```

---

## 02 — Physiological Analysis

The AI examines relationships between telemetry signals.

```text
          HEART RATE
               │
               ▼
        ┌──────────────┐
        │ Activity     │
        │ Intensity    │
        └──────┬───────┘
               │
       ┌───────┴────────┐
       ▼                ▼
     HRV              SpO₂
       │                │
       └───────┬────────┘
               ▼
       RECOVERY CONTEXT
               │
               ▼
        AI INTERPRETATION
```

---

## 03 — Action Plan Directives

Recommendations are divided into four categories:

| Category | Purpose |
|---|---|
| 🏋️ **Workout** | Training intensity and exercise guidance |
| 🥗 **Nutrition** | Caloric and nutritional guidance |
| 😴 **Recovery** | Rest and sleep recommendations |
| 💧 **Hydration** | Fluid intake guidance |

Each directive may include an urgency classification.

---

# 🧩 Backend Architecture

## `telemetry_simulator.py`

Responsible for generating realistic multi-metric biometric telemetry.

### Activity Modes

```text
┌──────────────┐
│   RESTING    │
└──────┬───────┘
       ▼
┌──────────────┐
│  DESK WORK   │
└──────┬───────┘
       ▼
┌──────────────┐
│  BRISK WALK  │
└──────┬───────┘
       ▼
┌──────────────┐
│ CARDIO BURST │
└──────┬───────┘
       ▼
┌──────────────┐
│   RECOVERY   │
└──────────────┘
```

The simulator maintains rolling historical buffers containing multiple physiological metrics.

---

# ⚙️ `gemini_worker.py`

The asynchronous AI processing engine.

Built using:

- `QRunnable`
- `QThreadPool`
- `google-genai`

### Workflow

```text
Telemetry Batch
      │
      ▼
JSON Serialization
      │
      ▼
Gemini Prompt
      │
      ▼
Google Gemini
      │
      ▼
Structured JSON
      │
      ▼
Parsed AI Result
```

The Gemini worker executes outside the main UI thread so AI requests do not block the QML rendering pipeline.

---

# 🔗 `vitality_bridge.py`

The communication layer between Python and QML.

Built using:

```python
QObject
Signal
Property
```

The bridge exposes backend state to the QML frontend reactively.

```text
PYTHON BACKEND
      │
      │ Signals / Properties
      ▼
VITALITY BRIDGE
      │
      ▼
QML FRONTEND
```

---

# 🎨 QML Frontend

The frontend is built with **Qt Quick / QML**.

The interface focuses on a futuristic health-tech dashboard aesthetic.

### UI capabilities

- Dark theme
- Animated metric cards
- Live telemetry
- Dynamic progress indicators
- Heart-rate waveform
- AI status indicator
- Vitality score visualization
- Action recommendation cards
- Terminal-style event stream
- Pause / Resume controls

---

# 📁 Project Structure

```text
Vitality Synthesizer/
│
├── main.py
├── requirements.txt
├── .env.example
├── .env
├── README.md
│
├── backend/
│   ├── __init__.py
│   ├── config.py
│   ├── telemetry_simulator.py
│   ├── gemini_worker.py
│   └── vitality_bridge.py
│
└── qml/
    ├── main.qml
    │
    └── components/
        ├── Theme.qml
        ├── MetricCard.qml
        ├── TelemetryStreamView.qml
        ├── AgentInsightsPanel.qml
        └── SparklineCanvas.qml
```

---

# 🗂️ Component Overview

| File | Responsibility |
|---|---|
| `main.py` | Application entry point and QML engine setup |
| `requirements.txt` | Python dependencies |
| `.env.example` | Environment configuration template |
| `.env` | Local Gemini configuration |
| `backend/config.py` | Configuration and API key loading |
| `backend/telemetry_simulator.py` | Biometric telemetry simulation |
| `backend/gemini_worker.py` | Background Gemini analysis |
| `backend/vitality_bridge.py` | Python ↔ QML bridge |
| `qml/main.qml` | Root application window |
| `Theme.qml` | Global UI theme |
| `MetricCard.qml` | Reusable biometric card |
| `TelemetryStreamView.qml` | Live telemetry interface |
| `AgentInsightsPanel.qml` | AI insights interface |
| `SparklineCanvas.qml` | Real-time waveform renderer |

---

# 🚀 Quick Start

## 1. Clone the Repository

```bash
git clone https://github.com/yourusername/vitality-synthesizer.git
cd vitality-synthesizer
```

> Replace the URL above with your actual GitHub repository URL.

---

## 2. Create a Virtual Environment

### Windows

```bash
python -m venv venv
venv\Scripts\activate
```

### macOS / Linux

```bash
python3 -m venv venv
source venv/bin/activate
```

---

## 3. Install Dependencies

```bash
pip install -r requirements.txt
```

If you are installing dependencies manually:

```bash
pip install PySide6 google-genai python-dotenv
```

---

# 🔑 Gemini API Configuration

Vitality Synthesizer supports two modes:

```text
                         GEMINI API KEY?
                              │
                ┌─────────────┴─────────────┐
                │                           │
               YES                         NO
                │                           │
                ▼                           ▼
        ┌───────────────┐          ┌──────────────────┐
        │  GEMINI MODE  │          │ SIMULATION MODE  │
        │               │          │                  │
        │ Live AI       │          │ Local simulated  │
        │ synthesis     │          │ AI insights      │
        └───────┬───────┘          └────────┬─────────┘
                │                           │
                └─────────────┬─────────────┘
                              ▼
                       QML DASHBOARD
```

---

# ⭐ Option A — `.env` File

**Recommended**

Create a file named:

```text
.env
```

in the root project directory.

Your structure should be:

```text
Vitality Synthesizer/
│
├── .env
├── main.py
├── requirements.txt
├── backend/
└── qml/
```

Add:

```env
GEMINI_API_KEY=your_actual_gemini_api_key_here
GEMINI_MODEL=gemini-3.5-flash
```

Get a Gemini API key from:

**Google AI Studio**

https://aistudio.google.com/app/apikey

---

# 🔐 Option B — `backend/config.py`

Alternatively, the API key can be configured directly inside:

```text
backend/config.py
```

For example:

```python
DEFAULT_API_KEY_PLACEHOLDER = "your_actual_gemini_api_key_here"
```

However, this method is **not recommended** for public repositories.

---

# 🛡️ Protect Your API Key

Never publish your Gemini API key to GitHub.

Add the following to `.gitignore`:

```gitignore
.env
venv/
__pycache__/
*.pyc
```

Your repository should contain:

```text
.env.example
```

but **not** your real:

```text
.env
```

If an API key is accidentally exposed publicly, revoke it and generate a new one.

---

# ▶️ Run the Application

With the virtual environment activated:

```bash
python main.py
```

The Vitality Synthesizer desktop application should launch.

---

# 🧪 Autonomous Simulation Mode

A Gemini API key is **not required** to test the application.

When no API key is available, the application can operate in **Autonomous Simulation Mode**.

This allows you to test:

```text
✓ Live telemetry
✓ Steps
✓ Heart rate
✓ Sleep metrics
✓ Calories
✓ SpO₂
✓ HRV
✓ Heart-rate waveform
✓ Telemetry event stream
✓ Vitality Index
✓ AI status indicator
✓ 10-second countdown
✓ Action-plan interface
✓ Pause / Resume
✓ Manual synthesis
```

This makes the application usable even when the Gemini API is unavailable.

---

# 🔄 End-to-End Data Flow

```text
                         ┌─────────────────────┐
                         │  TELEMETRY ENGINE   │
                         └──────────┬──────────┘
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │  MULTI-METRIC DATA  │
                         └──────────┬──────────┘
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │  ROLLING BUFFER    │
                         └──────────┬──────────┘
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │ 10 SECOND ANALYSIS  │
                         └──────────┬──────────┘
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │   GEMINI WORKER     │
                         └──────────┬──────────┘
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │    GEMINI AI        │
                         └──────────┬──────────┘
                                    │
                                    ▼
                    ┌──────────────────────────────┐
                    │     VITALITY INTELLIGENCE    │
                    │                              │
                    │  • Vitality Score            │
                    │  • Status                    │
                    │  • Primary Insight           │
                    │  • Physiological Analysis    │
                    │  • Action Plan               │
                    └──────────────┬───────────────┘
                                   │
                                   ▼
                         ┌─────────────────────┐
                         │   VITALITY BRIDGE   │
                         └──────────┬──────────┘
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │    QML DASHBOARD    │
                         └─────────────────────┘
```

---

# 🧠 Intelligence Model

The application follows a simple three-stage philosophy:

<div align="center">

### 👁️ OBSERVE

Continuously collect physiological telemetry.

↓

### 🤖 SYNTHESIZE

Use AI to interpret relationships between metrics.

↓

### 🎯 ACT

Convert insights into prioritized recommendations.

</div>

```text
┌────────────┐       ┌──────────────┐       ┌────────────┐
│  OBSERVE   │ ───▶  │  SYNTHESIZE  │ ───▶  │    ACT     │
└────────────┘       └──────────────┘       └─────┬──────┘
       ▲                                           │
       └───────────────────────────────────────────┘
```

---

# 📊 Example AI Response

A conceptual structured Gemini response may look like:

```json
{
  "vitality_index": 82,
  "status": "OPTIMAL",
  "primary_insight": "Recovery indicators remain strong despite elevated activity.",
  "analysis": "Heart rate, HRV and activity patterns indicate a stable physiological state.",
  "actions": {
    "workout": "Maintain moderate training intensity.",
    "nutrition": "Prioritize balanced post-workout nutrition.",
    "recovery": "Maintain consistent sleep duration.",
    "hydration": "Increase fluid intake following activity."
  }
}
```

---

# ⚙️ Technology Stack

<div align="center">

| Technology | Role |
|:---:|---|
| 🐍 **Python** | Backend application logic |
| 🟢 **PySide6** | Qt bindings for Python |
| 🎨 **QML / Qt Quick** | Modern desktop interface |
| 🤖 **Google Gemini** | AI health analysis |
| 📦 **google-genai** | Gemini API integration |
| ⚙️ **QRunnable** | Background execution |
| 🧵 **QThreadPool** | Asynchronous workers |
| 🔗 **Qt Signals** | Reactive communication |
| 📈 **QML Canvas** | Waveform rendering |

</div>

---

# 🏗️ Architecture Principles

### ⚡ Non-Blocking UI

Gemini API operations execute in background workers instead of blocking the QML rendering thread.

### 📡 Reactive Telemetry

Backend signals continuously update QML properties and visualizations.

### 🧠 Structured AI Output

Telemetry is serialized into structured JSON and processed through a controlled AI analysis pipeline.

### 🔄 Rolling Intelligence

The AI does not rely on a single telemetry point. It evaluates a rolling batch of recent measurements.

### 🧩 Modular QML

Reusable QML components keep the interface maintainable and scalable.

---

# 🧯 Troubleshooting

## `ModuleNotFoundError: No module named 'PySide6'`

Install PySide6:

```bash
pip install PySide6
```

---

## `ModuleNotFoundError: No module named 'google.genai'`

Install the Gemini SDK:

```bash
pip install google-genai
```

---

## `.env` is not detected

Make sure `.env` is located next to `main.py`:

```text
Vitality Synthesizer/
├── main.py
├── .env
└── backend/
```

---

## QML fails to load

Verify the QML directory:

```text
qml/
├── main.qml
└── components/
    ├── Theme.qml
    ├── MetricCard.qml
    ├── TelemetryStreamView.qml
    ├── AgentInsightsPanel.qml
    └── SparklineCanvas.qml
```

---

# 🗺️ Roadmap

Future development possibilities:

- [ ] Real wearable-device integration
- [ ] Persistent biometric history
- [ ] Advanced trend analytics
- [ ] User profiles
- [ ] Exportable health reports
- [ ] Real-time notifications
- [ ] Additional AI models
- [ ] Voice-based health assistant
- [ ] Hardware sensor integration
- [ ] Cloud telemetry synchronization
- [ ] Mobile companion application
- [ ] Personalized AI health models

---

# 🔒 Disclaimer

**Vitality Synthesizer is an educational and experimental software project.**

All physiological telemetry generated by the application is simulated.

The Vitality Index and AI-generated insights should **not** be interpreted as medical measurements, diagnoses, treatment plans, or professional healthcare advice.

Do not use this software for emergency decisions or medical diagnosis.

For medical concerns, consult a qualified healthcare professional.

---

# 🤝 Contributing

Contributions and improvements are welcome.

```text
             FORK
              │
              ▼
        CREATE BRANCH
              │
              ▼
        MAKE CHANGES
              │
              ▼
           COMMIT
              │
              ▼
            PUSH
              │
              ▼
       PULL REQUEST
```

---

# 📜 License

This project is licensed under the **MIT License**.

See the `LICENSE` file for complete license information.

---

<div align="center">

## ⚡ VITALITY SYNTHESIZER

### `OBSERVE  •  SYNTHESIZE  •  ACT`

**Continuous Telemetry. Autonomous Intelligence. Actionable Insights.**

<br>

![Made with Python](https://img.shields.io/badge/Made%20with-Python-3776AB?style=flat-square&logo=python&logoColor=white)
![Powered by Gemini](https://img.shields.io/badge/Powered%20by-Gemini-8E75B2?style=flat-square&logo=google&logoColor=white)
![Built with Qt](https://img.shields.io/badge/Built%20with-Qt-41CD52?style=flat-square&logo=qt&logoColor=white)
![MIT](https://img.shields.io/badge/License-MIT-20C997?style=flat-square)

<br>

**⚡ Built for real-time health intelligence**

</div>
