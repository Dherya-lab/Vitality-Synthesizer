"""
VitalityBridge: PySide6 QObject orchestrator bridging Python telemetry & AI workers to QML.
"""
import json
import logging
from datetime import datetime
from typing import Dict, Any, List
from PySide6.QtCore import QObject, Signal, Slot, Property, QTimer

from backend.config import (
    TELEMETRY_INTERVAL_MS,
    SYNTHESIS_INTERVAL_SECONDS,
    is_api_key_configured,
    get_gemini_api_key,
    GEMINI_MODEL
)
from backend.telemetry_simulator import TelemetrySimulator
from backend.gemini_worker import GeminiAgentController

logger = logging.getLogger(__name__)


class VitalityBridge(QObject):
    """
    Main controller and interface for QML.
    Exposes reactive properties, signals, and interaction slots to QML dashboard.
    """

    # Signals for property change notifications
    telemetryChanged = Signal()
    insightChanged = Signal()
    analysisStateChanged = Signal()
    countdownChanged = Signal()
    eventLogsChanged = Signal()
    heartRateHistoryChanged = Signal()

    def __init__(self, parent=None):
        super().__init__(parent)

        # 1. Telemetry State
        self._steps: int = 6840
        self._heart_rate: int = 74
        self._sleep_hours: float = 5.8
        self._sleep_quality: int = 73
        self._caloric_intake: int = 1920
        self._caloric_burned: int = 2180
        self._hrv: int = 52
        self._spo2: int = 98
        self._stress_level: str = "Normal"
        self._activity_mode: str = "Brisk Walk"
        self._heart_rate_history: List[int] = [72, 73, 75, 74, 76, 75, 78, 82, 85, 80, 78, 76, 74, 75, 74]

        # 2. Agent Insights State
        self._is_analyzing: bool = False
        self._countdown_seconds: int = int(SYNTHESIS_INTERVAL_SECONDS)
        self._total_countdown_seconds: int = int(SYNTHESIS_INTERVAL_SECONDS)
        self._last_updated: str = datetime.now().strftime("%H:%M:%S")

        # Initial default insight values
        self._insight_headline: str = "Synthesizing baseline telemetry patterns..."
        self._insight_analysis: str = (
            "The autonomous health agent is monitoring your live telemetry streams. "
            "Every 10 seconds, rolling biometric batches are synthesized to deliver targeted recovery and performance directives."
        )
        self._vitality_score: int = 85
        self._vitality_status: str = "OPTIMAL"
        self._action_plans: List[Dict[str, Any]] = [
            {
                "category": "WORKOUT",
                "title": "Baseline Telemetry Synchronization",
                "urgency": "LOW",
                "description": "Continuous physiological tracking active across steps, sleep, heart rate, and metabolic burn."
            },
            {
                "category": "HYDRATION",
                "title": "Hydration Target",
                "urgency": "LOW",
                "description": "Maintain baseline fluid intake (approx 2.5L daily) to preserve cardiovascular efficiency."
            }
        ]

        # 3. Activity / Event log buffer (most recent 25 logs)
        self._event_logs: List[str] = [
            f"[{datetime.now().strftime('%H:%M:%S')}] Vitality Synthesizer initialized.",
            f"[{datetime.now().strftime('%H:%M:%S')}] Biometric stream linked to AI agent backend."
        ]

        # 4. Initialize Telemetry Simulator
        self._simulator = TelemetrySimulator(interval_ms=TELEMETRY_INTERVAL_MS, parent=self)
        self._simulator.telemetry_updated.connect(self._on_telemetry_tick)
        self._simulator.log_event_generated.connect(self._append_log)

        # 5. Initialize Gemini Agent Controller
        self._gemini_controller = GeminiAgentController(parent=self)
        self._gemini_controller.insight_ready.connect(self._on_insight_received)
        self._gemini_controller.analysis_in_progress.connect(self._on_analysis_state_changed)
        self._gemini_controller.status_log.connect(self._append_log)

        # 6. Countdown Timer for 10-second synthesis cycle
        self._countdown_timer = QTimer(self)
        self._countdown_timer.setInterval(1000)  # tick every 1 second
        self._countdown_timer.timeout.connect(self._on_countdown_tick)

    def start_services(self):
        """Starts simulator and analysis orchestration."""
        self._simulator.start()
        self._countdown_timer.start()
        # Trigger initial analysis immediately
        self.triggerManualAnalysis()

    def stop_services(self):
        """Stops simulator, countdown timer, and background workers cleanly."""
        self._simulator.stop()
        self._countdown_timer.stop()
        self._gemini_controller.stop()

    # --------------------------------------------------------------------------
    # Slot Callbacks
    # --------------------------------------------------------------------------
    def _on_telemetry_tick(self, data: Dict[str, Any]):
        """Triggered whenever the telemetry simulator produces a new sample."""
        self._steps = data.get("steps", self._steps)
        self._heart_rate = data.get("heart_rate", self._heart_rate)
        self._sleep_hours = data.get("sleep_hours", self._sleep_hours)
        self._sleep_quality = data.get("sleep_quality", self._sleep_quality)
        self._caloric_intake = data.get("caloric_intake", self._caloric_intake)
        self._caloric_burned = data.get("caloric_burned", self._caloric_burned)
        self._hrv = data.get("hrv", self._hrv)
        self._spo2 = data.get("spo2", self._spo2)
        self._stress_level = data.get("stress_level", self._stress_level)
        self._activity_mode = data.get("activity_mode", self._activity_mode).replace("_", " ").title()

        # Update heart rate history for sparklines
        self._heart_rate_history.append(self._heart_rate)
        if len(self._heart_rate_history) > 25:
            self._heart_rate_history.pop(0)

        self.telemetryChanged.emit()
        self.heartRateHistoryChanged.emit()

    def _on_countdown_tick(self):
        """Ticks down the 10-second countdown till the next synthesis batch."""
        if self._countdown_seconds > 1:
            self._countdown_seconds -= 1
            self.countdownChanged.emit()
        else:
            self._countdown_seconds = self._total_countdown_seconds
            self.countdownChanged.emit()
            # Dispatch automatic batch synthesis
            self._dispatch_batch_synthesis()

    def _dispatch_batch_synthesis(self):
        """Collects telemetry batch and sends to background worker."""
        if self._is_analyzing:
            return  # Previous task still executing

        batch = self._simulator.consume_synthesis_batch()
        self._gemini_controller.dispatch_synthesis(batch)

    def _on_insight_received(self, data: Dict[str, Any]):
        """Triggered when the background Gemini worker completes synthesis."""
        self._insight_headline = data.get("headline", self._insight_headline)
        self._insight_analysis = data.get("analysis", self._insight_analysis)
        self._vitality_score = data.get("vitality_score", self._vitality_score)
        self._vitality_status = data.get("status", self._vitality_status)
        self._action_plans = data.get("action_plan", self._action_plans)
        self._last_updated = data.get("timestamp", datetime.now().strftime("%H:%M:%S"))

        self.insightChanged.emit()

    def _on_analysis_state_changed(self, in_progress: bool):
        self._is_analyzing = in_progress
        self.analysisStateChanged.emit()

    def _append_log(self, text: str):
        self._event_logs.append(text)
        if len(self._event_logs) > 30:
            self._event_logs.pop(0)
        self.eventLogsChanged.emit()

    # --------------------------------------------------------------------------
    # QML Slots
    # --------------------------------------------------------------------------
    @Slot()
    def triggerManualAnalysis(self):
        """Forces an immediate synthesis cycle."""
        self._countdown_seconds = self._total_countdown_seconds
        self.countdownChanged.emit()
        self._append_log(f"[{datetime.now().strftime('%H:%M:%S')}] Manual AI synthesis triggered by user.")
        self._dispatch_batch_synthesis()

    @Slot(bool)
    def toggleSimulation(self, enabled: bool):
        """Pauses or resumes telemetry streaming."""
        if enabled:
            self._simulator.start()
            self._countdown_timer.start()
        else:
            self._simulator.stop()
            self._countdown_timer.stop()

    # --------------------------------------------------------------------------
    # QML Properties - Telemetry
    # --------------------------------------------------------------------------
    @Property(int, notify=telemetryChanged)
    def steps(self) -> int:
        return self._steps

    @Property(int, notify=telemetryChanged)
    def heartRate(self) -> int:
        return self._heart_rate

    @Property(float, notify=telemetryChanged)
    def sleepHours(self) -> float:
        return self._sleep_hours

    @Property(int, notify=telemetryChanged)
    def sleepQuality(self) -> int:
        return self._sleep_quality

    @Property(int, notify=telemetryChanged)
    def caloricIntake(self) -> int:
        return self._caloric_intake

    @Property(int, notify=telemetryChanged)
    def caloricBurned(self) -> int:
        return self._caloric_burned

    @Property(int, notify=telemetryChanged)
    def hrv(self) -> int:
        return self._hrv

    @Property(int, notify=telemetryChanged)
    def spo2(self) -> int:
        return self._spo2

    @Property(str, notify=telemetryChanged)
    def stressLevel(self) -> str:
        return self._stress_level

    @Property(str, notify=telemetryChanged)
    def activityMode(self) -> str:
        return self._activity_mode

    @Property(list, notify=heartRateHistoryChanged)
    def heartRateHistory(self) -> list:
        return self._heart_rate_history

    # --------------------------------------------------------------------------
    # QML Properties - Agent Insights
    # --------------------------------------------------------------------------
    @Property(bool, notify=analysisStateChanged)
    def isAnalyzing(self) -> bool:
        return self._is_analyzing

    @Property(int, notify=countdownChanged)
    def secondsUntilNextAnalysis(self) -> int:
        return self._countdown_seconds

    @Property(int, constant=True)
    def totalCountdownSeconds(self) -> int:
        return self._total_countdown_seconds

    @Property(str, notify=insightChanged)
    def lastUpdated(self) -> str:
        return self._last_updated

    @Property(str, notify=insightChanged)
    def insightHeadline(self) -> str:
        return self._insight_headline

    @Property(str, notify=insightChanged)
    def insightAnalysis(self) -> str:
        return self._insight_analysis

    @Property(int, notify=insightChanged)
    def vitalityScore(self) -> int:
        return self._vitality_score

    @Property(str, notify=insightChanged)
    def vitalityStatus(self) -> str:
        return self._vitality_status

    @Property(list, notify=insightChanged)
    def actionPlans(self) -> list:
        return self._action_plans

    @Property(list, notify=eventLogsChanged)
    def eventLogs(self) -> list:
        return self._event_logs

    @Property(str, constant=True)
    def agentMode(self) -> str:
        if is_api_key_configured():
            return f"Gemini ({GEMINI_MODEL}) Live"
        return "Autonomous Simulation Mode"

    @Property(bool, constant=True)
    def apiKeyConfigured(self) -> bool:
        return is_api_key_configured()
