"""
Biometric Telemetry Stream Generator for Vitality Synthesizer.
Simulates a live continuous stream of human physiological metrics.
"""
import random
import time
from datetime import datetime
from collections import deque
from typing import Dict, Any, List
from PySide6.QtCore import QObject, Signal, QTimer


class TelemetrySimulator(QObject):
    """
    Simulates real-time biometric sensors and telemetry data streams.
    Generates realistic variations in Heart Rate, Steps, Sleep, Calories, HRV, and SpO2.
    """
    # Signal emitted on every tick with the latest telemetry snapshot
    telemetry_updated = Signal(dict)
    log_event_generated = Signal(str)

    def __init__(self, interval_ms: int = 2000, parent=None):
        super().__init__(parent)
        self.interval_ms = interval_ms

        # Baseline metrics
        self._steps = 6840
        self._heart_rate = 74
        self._target_hr = 74
        self._sleep_hours = 5.8
        self._sleep_quality = 73
        self._deep_sleep_hours = 1.1
        self._rem_sleep_hours = 1.4
        self._caloric_intake = 1920
        self._caloric_burned = 2180
        self._hrv = 52  # Heart Rate Variability in ms
        self._spo2 = 98  # Blood Oxygen %
        self._stress_level = "Normal"

        # Activity mode simulation (e.g. resting, brisk_walk, cardio_burst, recovery)
        self._activity_modes = ["resting", "brisk_walk", "cardio_burst", "recovery", "desk_work"]
        self._current_mode = "brisk_walk"
        self._mode_ticks_remaining = 8

        # Rolling history buffer for trends and batch payloads (stores last 50 snapshots)
        self._history_buffer: deque = deque(maxlen=50)

        # Batch accumulator for the 10-second Gemini synthesis cycles
        self._batch_since_last_synthesis: List[Dict[str, Any]] = []

        # Internal timer for live stream
        self._timer = QTimer(self)
        self._timer.setInterval(self.interval_ms)
        self._timer.timeout.connect(self._tick)

    def start(self):
        """Starts the continuous telemetry stream."""
        # Record initial baseline
        self._record_snapshot()
        self._timer.start()
        self.log_event_generated.emit(f"[{datetime.now().strftime('%H:%M:%S')}] Biometric stream initiated. Telemetry feed active.")

    def stop(self):
        """Stops the continuous telemetry stream."""
        self._timer.stop()
        self.log_event_generated.emit(f"[{datetime.now().strftime('%H:%M:%S')}] Biometric stream paused.")

    def is_running(self) -> bool:
        return self._timer.isActive()

    def get_latest_snapshot(self) -> Dict[str, Any]:
        """Returns the most recent biometric telemetry snapshot."""
        return {
            "timestamp": datetime.now().isoformat(),
            "time_label": datetime.now().strftime("%H:%M:%S"),
            "steps": int(self._steps),
            "heart_rate": int(self._heart_rate),
            "sleep_hours": round(self._sleep_hours, 1),
            "sleep_quality": int(self._sleep_quality),
            "deep_sleep_hours": round(self._deep_sleep_hours, 1),
            "rem_sleep_hours": round(self._rem_sleep_hours, 1),
            "caloric_intake": int(self._caloric_intake),
            "caloric_burned": int(self._caloric_burned),
            "hrv": int(self._hrv),
            "spo2": int(self._spo2),
            "stress_level": self._stress_level,
            "activity_mode": self._current_mode
        }

    def get_heart_rate_history(self) -> List[int]:
        """Returns the last 20 heart rate values for sparklines."""
        if not self._history_buffer:
            return [int(self._heart_rate)] * 10
        return [item["heart_rate"] for item in list(self._history_buffer)[-20:]]

    def consume_synthesis_batch(self) -> List[Dict[str, Any]]:
        """
        Retrieves the telemetry snapshots accumulated since the last synthesis,
        then resets the batch buffer.
        """
        if not self._batch_since_last_synthesis:
            # Fallback to current snapshot
            return [self.get_latest_snapshot()]
        batch = list(self._batch_since_last_synthesis)
        self._batch_since_last_synthesis.clear()
        return batch

    def _tick(self):
        """Executes a single simulation tick and emits updated telemetry."""
        # 1. Update activity mode cycle
        self._mode_ticks_remaining -= 1
        if self._mode_ticks_remaining <= 0:
            self._current_mode = random.choice(self._activity_modes)
            self._mode_ticks_remaining = random.randint(5, 12)
            self.log_event_generated.emit(
                f"[{datetime.now().strftime('%H:%M:%S')}] Activity transition -> {self._current_mode.replace('_', ' ').title()}"
            )

        # 2. Simulate physiological metrics based on activity mode
        if self._current_mode == "resting":
            self._target_hr = random.randint(60, 68)
            step_delta = random.randint(0, 4)
            burn_delta = random.randint(1, 3)
            self._stress_level = "Low"
            self._hrv = min(85, max(55, self._hrv + random.randint(-2, 3)))
        elif self._current_mode == "desk_work":
            self._target_hr = random.randint(68, 78)
            step_delta = random.randint(2, 8)
            burn_delta = random.randint(2, 4)
            self._stress_level = "Normal"
            self._hrv = min(75, max(45, self._hrv + random.randint(-3, 2)))
        elif self._current_mode == "brisk_walk":
            self._target_hr = random.randint(95, 115)
            step_delta = random.randint(25, 45)
            burn_delta = random.randint(6, 12)
            self._stress_level = "Elevated"
            self._hrv = min(60, max(38, self._hrv + random.randint(-4, 1)))
        elif self._current_mode == "cardio_burst":
            self._target_hr = random.randint(130, 155)
            step_delta = random.randint(45, 80)
            burn_delta = random.randint(14, 25)
            self._stress_level = "High"
            self._hrv = min(50, max(30, self._hrv + random.randint(-5, 0)))
        elif self._current_mode == "recovery":
            self._target_hr = random.randint(65, 75)
            step_delta = random.randint(5, 12)
            burn_delta = random.randint(3, 5)
            self._stress_level = "Recovery"
            self._hrv = min(80, max(50, self._hrv + random.randint(-1, 4)))

        # Smooth heart rate movement toward target
        hr_diff = self._target_hr - self._heart_rate
        if hr_diff != 0:
            step = 1 if hr_diff > 0 else -1
            if abs(hr_diff) > 5:
                step *= random.randint(2, 4)
            self._heart_rate += step
        # Add slight natural jitter
        self._heart_rate += random.choice([-1, 0, 1])
        self._heart_rate = max(55, min(175, self._heart_rate))

        # Accumulate steps & calories
        self._steps += step_delta
        self._caloric_burned += burn_delta

        # SpO2 slight natural fluctuation (96% - 100%)
        if self._current_mode == "cardio_burst":
            self._spo2 = random.choice([96, 97, 98])
        else:
            self._spo2 = random.choice([98, 99, 99, 100])

        # Record and emit
        snapshot = self._record_snapshot()
        self.telemetry_updated.emit(snapshot)

    def _record_snapshot(self) -> Dict[str, Any]:
        """Saves snapshot to history buffer and batch queue."""
        snapshot = self.get_latest_snapshot()
        self._history_buffer.append(snapshot)
        self._batch_since_last_synthesis.append(snapshot)
        return snapshot
