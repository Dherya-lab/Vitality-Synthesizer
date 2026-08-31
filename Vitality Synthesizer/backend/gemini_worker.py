"""
Asynchronous Background AI Agent Synthesis Worker for Vitality Synthesizer.
Uses Google's GenAI SDK (Gemini API) to analyze rolling telemetry batches and
deliver autonomous health recommendations.
"""
import json
import logging
import threading
import warnings
from datetime import datetime
from typing import Dict, Any, List, Optional
from PySide6.QtCore import QObject, Signal, Slot

# Suppress harmless SDK automatic function calling notice
warnings.filterwarnings("ignore", category=UserWarning)

from backend.config import (
    get_gemini_api_key,
    is_api_key_configured,
    GEMINI_MODEL
)

logger = logging.getLogger(__name__)


# ==============================================================================
# 🧠 GEMINI HEALTH ANALYST PROMPT DEFINITION
# ==============================================================================
SYSTEM_PROMPT = """You are the 'Vitality Synthesizer' Autonomous Health & Performance Intelligence Agent.
You continuously ingest real-time biometric telemetry batches (Steps, Sleep, Heart Rate, HRV, SpO2, Caloric Intake & Burn) and synthesize actionable clinical/lifestyle directives.

Your task:
1. Examine the recent telemetry data points and summary statistics.
2. Identify notable physiological anomalies, recovery state, sleep debt, cardiovascular exertion, or metabolic balances.
3. Formulate a short, punchy, high-impact headline insight (e.g., 'Sleep dropped by 2.1h; shifting tomorrow's workout to light aerobic recovery').
4. Provide a structured, highly actionable recommendation plan.

You MUST respond strictly with valid JSON conforming to the following JSON schema:
{
  "headline": "Short, actionable primary insight sentence",
  "status": "OPTIMAL" | "MODERATE" | "ATTENTION_NEEDED",
  "vitality_score": integer between 0 and 100,
  "analysis": "2-3 concise sentences detailing biomechanical and recovery correlations.",
  "action_plan": [
    {
      "category": "WORKOUT" | "NUTRITION" | "RECOVERY" | "HYDRATION",
      "title": "Short directive title",
      "urgency": "HIGH" | "MEDIUM" | "LOW",
      "description": "Tactical, specific recommendation"
    }
  ]
}
"""


class SynthesisSignals(QObject):
    """Qt Signals for thread-safe cross-thread event dispatching."""
    analysis_started = Signal()
    analysis_completed = Signal(dict)
    analysis_error = Signal(str)
    status_log = Signal(str)


class GeminiAgentController(QObject):
    """
    Manages background synthesis orchestration using daemon worker threads.
    Coordinates 10-second batch analysis with the UI bridge.
    """
    insight_ready = Signal(dict)
    analysis_in_progress = Signal(bool)
    status_log = Signal(str)

    def __init__(self, parent=None):
        super().__init__(parent)
        self.signals = SynthesisSignals()
        self.signals.analysis_started.connect(lambda: self.analysis_in_progress.emit(True))
        self.signals.analysis_completed.connect(self._on_completed)
        self.signals.analysis_error.connect(self._on_error)
        self.signals.status_log.connect(self.status_log.emit)
        self._is_running = False

    def dispatch_synthesis(self, batch: List[Dict[str, Any]]):
        """Spawns an asynchronous daemon thread for synthesis if not currently active."""
        if self._is_running:
            return  # Already synthesizing

        self._is_running = True
        worker_thread = threading.Thread(
            target=self._execute_synthesis,
            args=(batch,),
            daemon=True
        )
        worker_thread.start()

    def _execute_synthesis(self, telemetry_batch: List[Dict[str, Any]]):
        """Worker thread entry point."""
        try:
            self._safe_emit(self.signals.analysis_started)
            now_str = datetime.now().strftime("%H:%M:%S")
            self._safe_emit(
                self.signals.status_log,
                f"[{now_str}] Synthesis cycle initiated. Processing {len(telemetry_batch)} telemetry records..."
            )

            # 1. Format payload
            batch_payload = self._format_batch_payload(telemetry_batch)

            # 2. Check if API key is configured
            if is_api_key_configured():
                result = self._call_gemini_api(batch_payload)
            else:
                self._safe_emit(
                    self.signals.status_log,
                    f"[{now_str}] Notice: Running in Autonomous Simulation Mode (Add GEMINI_API_KEY in .env for live Gemini)."
                )
                result = self._generate_simulated_insight(batch_payload)

            # 3. Emit results
            self._safe_emit(self.signals.analysis_completed, result)
            self._safe_emit(
                self.signals.status_log,
                f"[{datetime.now().strftime('%H:%M:%S')}] Synthesis complete. Health directives updated."
            )

        except Exception as exc:
            err_msg = f"Synthesis worker error: {str(exc)}"
            logger.error(err_msg, exc_info=True)
            self._safe_emit(self.signals.analysis_error, err_msg)
            # Fallback to simulated insight so UI stays operational
            try:
                fallback = self._generate_simulated_insight(self._format_batch_payload(telemetry_batch))
                fallback["headline"] = f"[Autonomous Assessment] {fallback['headline']}"
                self._safe_emit(self.signals.analysis_completed, fallback)
            except Exception:
                pass
        finally:
            self._is_running = False

    def _safe_emit(self, signal, *args):
        """Safely emits a Qt signal."""
        try:
            signal.emit(*args)
        except (RuntimeError, Exception):
            pass

    def _on_completed(self, data: dict):
        self._is_running = False
        self.analysis_in_progress.emit(False)
        self.insight_ready.emit(data)

    def _on_error(self, err: str):
        self._is_running = False
        self.analysis_in_progress.emit(False)
        self.status_log.emit(f"[{datetime.now().strftime('%H:%M:%S')}] ⚠️ {err}")

    def stop(self):
        """Cleanly flags shutdown."""
        self._is_running = False

    def _format_batch_payload(self, batch: List[Dict[str, Any]]) -> Dict[str, Any]:
        """Formats telemetry data into an aggregated diagnostic payload."""
        if not batch:
            return {"error": "No telemetry in batch"}

        latest = batch[-1]
        hr_values = [b.get("heart_rate", 70) for b in batch]
        steps_total = latest.get("steps", 0)
        sleep_hrs = latest.get("sleep_hours", 7.0)
        cal_intake = latest.get("caloric_intake", 2000)
        cal_burned = latest.get("caloric_burned", 2000)
        hrv_values = [b.get("hrv", 50) for b in batch]
        spo2_values = [b.get("spo2", 98) for b in batch]

        return {
            "batch_timestamp": datetime.now().isoformat(),
            "batch_window_seconds": 10,
            "sample_count": len(batch),
            "current_metrics": latest,
            "aggregate_statistics": {
                "heart_rate_avg": round(sum(hr_values) / len(hr_values), 1),
                "heart_rate_max": max(hr_values),
                "heart_rate_min": min(hr_values),
                "steps_cumulative": steps_total,
                "sleep_duration_hours": sleep_hrs,
                "sleep_quality_score": latest.get("sleep_quality", 80),
                "net_caloric_balance": cal_intake - cal_burned,
                "hrv_average_ms": round(sum(hrv_values) / len(hrv_values), 1),
                "spo2_average_pct": round(sum(spo2_values) / len(spo2_values), 1),
                "activity_mode": latest.get("activity_mode", "active")
            },
            "recent_samples": batch[-5:]
        }

    def _call_gemini_api(self, batch_payload: Dict[str, Any]) -> Dict[str, Any]:
        """Queries Google Gemini API using the official google-genai SDK."""
        from google import genai
        from google.genai import types

        api_key = get_gemini_api_key()
        client = genai.Client(api_key=api_key)

        prompt_text = f"""
Telemetry Data Batch for Analysis:
```json
{json.dumps(batch_payload, indent=2)}
```

Analyze this telemetry batch and generate your autonomous health assessment following the requested JSON schema.
"""

        response = client.models.generate_content(
            model=GEMINI_MODEL,
            contents=prompt_text,
            config=types.GenerateContentConfig(
                system_instruction=SYSTEM_PROMPT,
                response_mime_type="application/json",
                temperature=0.3
            )
        )

        response_text = response.text.strip()
        data = json.loads(response_text)
        data["source"] = f"Gemini {GEMINI_MODEL} (Live)"
        data["timestamp"] = datetime.now().strftime("%H:%M:%S")
        return data

    def _generate_simulated_insight(self, batch_payload: Dict[str, Any]) -> Dict[str, Any]:
        """
        Generates realistic dynamic clinical insights based on actual telemetry
        patterns when Gemini API key is not yet supplied.
        """
        stats = batch_payload.get("aggregate_statistics", {})
        hr_avg = stats.get("heart_rate_avg", 75)
        hr_max = stats.get("heart_rate_max", 85)
        sleep_hrs = stats.get("sleep_duration_hours", 7.0)
        net_cal = stats.get("net_caloric_balance", 0)
        hrv = stats.get("hrv_average_ms", 55)
        steps = stats.get("steps_cumulative", 7000)

        if sleep_hrs < 6.0:
            headline = f"Sleep dropped to {sleep_hrs}h ({round(7.5 - sleep_hrs, 1)}h deficit); shifting training to restorative zone."
            status = "ATTENTION_NEEDED"
            vitality_score = max(58, int(72 - (7.5 - sleep_hrs) * 8))
            analysis = (
                f"Sleep duration of {sleep_hrs} hours with depressed HRV ({hrv}ms) indicates sympathetic nervous system strain. "
                f"Elevated baseline heart rate ({hr_avg} bpm) suggests metabolic fatigue and compromised neuromuscular recovery."
            )
            action_plan = [
                {
                    "category": "WORKOUT",
                    "title": "Low-Intensity Aerobic Flush",
                    "urgency": "HIGH",
                    "description": "Swap high-intensity intervals for a 25-minute zone 2 walk or gentle stationary cycling."
                },
                {
                    "category": "RECOVERY",
                    "title": "Circadian Reset Protocol",
                    "urgency": "HIGH",
                    "description": "Initiate screen blackout 60 min before bed; target 22:30 sleep window for melatonin surge."
                },
                {
                    "category": "NUTRITION",
                    "title": "Magnesium & Glycine Supplementation",
                    "urgency": "MEDIUM",
                    "description": "Incorporate 300mg magnesium bisglycinate with evening meal to assist nervous system down-regulation."
                }
            ]
        elif hr_max > 135:
            headline = f"Cardiovascular exertion spike ({hr_max} BPM) detected; optimizing post-effort glycogen replenishment."
            status = "OPTIMAL" if hrv > 50 else "MODERATE"
            vitality_score = 88 if hrv > 50 else 76
            analysis = (
                f"High-intensity cardiovascular demand sustained across recent telemetry window (Peak HR: {hr_max} bpm). "
                f"Active caloric burn exceeds baseline by {abs(net_cal)} kcal. System response remains resilient with SpO2 at {stats.get('spo2_average_pct', 98)}%."
            )
            action_plan = [
                {
                    "category": "HYDRATION",
                    "title": "Electrolyte & Fluid Replacement",
                    "urgency": "HIGH",
                    "description": "Consume 750ml water enriched with 400mg sodium and potassium within 30 minutes."
                },
                {
                    "category": "NUTRITION",
                    "title": "Post-Workout Carbohydrate Window",
                    "urgency": "MEDIUM",
                    "description": "Target 45g complex carbs + 25g fast-digesting protein to replenish muscle glycogen stores."
                },
                {
                    "category": "RECOVERY",
                    "title": "Active Heart Rate Cool-down",
                    "urgency": "MEDIUM",
                    "description": "Complete 5 minutes of box breathing (4s in, 4s hold, 4s out, 4s hold) to accelerate parasympathetic transition."
                }
            ]
        else:
            headline = f"Biometric homeostasis stable (Steps: {steps:,}, HR: {hr_avg} BPM); steady metabolic vitality maintained."
            status = "OPTIMAL"
            vitality_score = min(96, int(82 + (steps / 2000)))
            analysis = (
                f"All vital telemetry parameters remain within target reference ranges. "
                f"Autonomic tone (HRV {hrv}ms) and oxygen saturation are well balanced with positive physical pacing."
            )
            action_plan = [
                {
                    "category": "WORKOUT",
                    "title": "Maintain Daily Step Cadence",
                    "urgency": "LOW",
                    "description": f"Current pace is {steps:,} steps. Continue active movement breaks every 45 minutes."
                },
                {
                    "category": "HYDRATION",
                    "title": "Sustained Hydration Pacing",
                    "urgency": "LOW",
                    "description": "Drink 250ml water every 90 minutes to maintain intracellular volume."
                },
                {
                    "category": "RECOVERY",
                    "title": "Micro-Mobility Stretch",
                    "urgency": "LOW",
                    "description": "Perform 3 minutes of thoracic spine openers and hip flexor stretches."
                }
            ]

        return {
            "headline": headline,
            "status": status,
            "vitality_score": vitality_score,
            "analysis": analysis,
            "action_plan": action_plan,
            "source": "Autonomous Simulation Mode (Add GEMINI_API_KEY for Live Gemini)",
            "timestamp": datetime.now().strftime("%H:%M:%S")
        }
