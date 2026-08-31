import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "components"

ApplicationWindow {
    id: window
    width: 1240
    height: 820
    minimumWidth: 1000
    minimumHeight: 680
    visible: true
    title: "Vitality Synthesizer - Autonomous Biometric Intelligence"
    color: "#080C14"

    // -------------------------------------------------------------------------
    // Top Navigation & System Status Header
    // -------------------------------------------------------------------------
    header: Rectangle {
        height: 64
        color: "#0B101D"
        border.color: "#1E293B"
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            spacing: 16

            // App Brand Logo & Name
            RowLayout {
                spacing: 10

                Rectangle {
                    width: 34
                    height: 34
                    radius: 8
                    gradient: Gradient {
                        orientation: Gradient.TopToBottom
                        GradientStop { position: 0.0; color: "#00F2FE" }
                        GradientStop { position: 1.0; color: "#4FACFE" }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "⚡"
                        font.pixelSize: 18
                    }
                }

                ColumnLayout {
                    spacing: 0
                    Text {
                        text: "VITALITY SYNTHESIZER"
                        font.pixelSize: 15
                        font.weight: Font.Bold
                        font.letterSpacing: 1.2
                        font.family: "Segoe UI, sans-serif"
                        color: "#F8FAFC"
                    }
                    Text {
                        text: "Autonomous Biometric Telemetry & AI Health Intelligence"
                        font.pixelSize: 10
                        font.family: "Segoe UI, sans-serif"
                        color: "#64748B"
                    }
                }
            }

            Item { Layout.fillWidth: true }

            // Live Pulse Status Pill
            Rectangle {
                height: 28
                width: livePillRow.implicitWidth + 20
                radius: 14
                color: "#111726"
                border.color: "#1E293B"

                RowLayout {
                    id: livePillRow
                    anchors.centerIn: parent
                    spacing: 8

                    Rectangle {
                        width: 8
                        height: 8
                        radius: 4
                        color: "#10B981"
                        SequentialAnimation on opacity {
                            loops: Animation.Infinite
                            PropertyAnimation { to: 0.2; duration: 600; easing.type: Easing.InOutQuad }
                            PropertyAnimation { to: 1.0; duration: 600; easing.type: Easing.InOutQuad }
                        }
                    }

                    Text {
                        text: "TELEMETRY LIVE (2s)"
                        font.pixelSize: 10
                        font.weight: Font.Bold
                        font.letterSpacing: 0.8
                        color: "#10B981"
                    }
                }
            }

            // AI Agent Status Pill
            Rectangle {
                height: 28
                width: agentPillRow.implicitWidth + 20
                radius: 14
                color: "#111726"
                border.color: vitalityBridge.apiKeyConfigured ? "#10B981" : "#8B5CF6"

                RowLayout {
                    id: agentPillRow
                    anchors.centerIn: parent
                    spacing: 8

                    Text {
                        text: vitalityBridge.isAnalyzing ? "⚙️" : "✨"
                        font.pixelSize: 12
                    }

                    Text {
                        text: vitalityBridge.agentMode.toUpperCase()
                        font.pixelSize: 10
                        font.weight: Font.Bold
                        font.letterSpacing: 0.8
                        color: vitalityBridge.apiKeyConfigured ? "#10B981" : "#C084FC"
                    }
                }
            }
        }
    }

    // -------------------------------------------------------------------------
    // Main Dual-Section Dashboard Body
    // -------------------------------------------------------------------------
    RowLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        // Left Section: Telemetry Stream (Steps, Sleep, HR, Calories, SpO2, HRV, Logs)
        TelemetryStreamView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 50
        }

        // Right Section: Agent Insights & Action Plans Panel
        AgentInsightsPanel {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 50
        }
    }

    // -------------------------------------------------------------------------
    // Footer Status Bar
    // -------------------------------------------------------------------------
    footer: Rectangle {
        height: 28
        color: "#0B101D"
        border.color: "#1E293B"
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16

            Text {
                text: "• Telemetry Pipeline: Active (Steps, Sleep, HR, Caloric Burn, HRV, SpO2)"
                font.pixelSize: 10
                font.family: "Consolas, monospace"
                color: "#64748B"
            }

            Item { Layout.fillWidth: true }

            Text {
                text: vitalityBridge.apiKeyConfigured ?
                      "Connected to Google Gemini API" :
                      "ℹ️ Paste Gemini API key in .env for Live Gemini AI inference"
                font.pixelSize: 10
                font.family: "Segoe UI, sans-serif"
                color: vitalityBridge.apiKeyConfigured ? "#10B981" : "#F59E0B"
            }
        }
    }
}
