"""
Vitality Synthesizer - Main Application Entrypoint
A desktop application pairing real-time biometric telemetry streaming with
autonomous background Google Gemini AI health synthesis.
"""
import sys
import os
from pathlib import Path
from PySide6.QtGui import QGuiApplication, QIcon
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QCoreApplication

# Add project root to sys.path
PROJECT_ROOT = Path(__file__).resolve().parent
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from backend.vitality_bridge import VitalityBridge


def main():
    # Set application metadata
    QCoreApplication.setApplicationName("VitalitySynthesizer")
    QCoreApplication.setOrganizationName("VitalityLabs")
    QCoreApplication.setApplicationVersion("1.0.0")

    # Initialize Qt GUI Application
    app = QGuiApplication(sys.argv)

    # Initialize QML Application Engine
    engine = QQmlApplicationEngine()

    # Instantiate Vitality Bridge
    vitality_bridge = VitalityBridge()

    # Expose the bridge instance to QML context
    engine.rootContext().setContextProperty("vitalityBridge", vitality_bridge)

    # Resolve path to main.qml
    qml_file = PROJECT_ROOT / "qml" / "main.qml"
    if not qml_file.exists():
        print(f"Error: QML entrypoint not found at {qml_file}")
        sys.exit(1)

    # Load QML
    engine.load(str(qml_file))

    # Verify QML root object loaded
    if not engine.rootObjects():
        print("Error: Failed to load QML root object. Exiting.")
        sys.exit(1)

    # Start background telemetry streaming and autonomous AI synthesis timer
    vitality_bridge.start_services()
    app.aboutToQuit.connect(vitality_bridge.stop_services)

    print("===================================================================")
    print("⚡ Vitality Synthesizer desktop app started successfully.")
    print("• Telemetry stream: active (2s ticks)")
    print("• Gemini AI agent synthesis: active (10s rolling batch window)")
    print(f"• Agent mode: {vitality_bridge.agentMode}")
    print("===================================================================")

    # Execute Qt event loop
    sys.exit(app.exec())


if __name__ == "__main__":
    main()
