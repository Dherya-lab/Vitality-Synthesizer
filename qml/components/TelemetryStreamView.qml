import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    color: "#0B101D"
    radius: 14
    border.color: "#1E293B"
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 14

        // ---------------------------------------------------------------------
        // Section Header
        // ---------------------------------------------------------------------
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            // Live Pulse Beacon
            Rectangle {
                width: 10
                height: 10
                radius: 5
                color: "#10B981"

                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    PropertyAnimation { to: 0.2; duration: 800; easing.type: Easing.InOutQuad }
                    PropertyAnimation { to: 1.0; duration: 800; easing.type: Easing.InOutQuad }
                }
            }

            Text {
                text: "TELEMETRY STREAM"
                font.pixelSize: 13
                font.weight: Font.Bold
                font.letterSpacing: 1.2
                color: "#F8FAFC"
                Layout.fillWidth: true
            }

            // Current Activity Mode Badge
            Rectangle {
                height: 24
                width: activityText.implicitWidth + 18
                radius: 12
                color: Qt.rgba(0.22, 0.74, 0.97, 0.15)
                border.color: Qt.rgba(0.22, 0.74, 0.97, 0.4)
                border.width: 1

                Text {
                    id: activityText
                    anchors.centerIn: parent
                    text: vitalityBridge.activityMode.toUpperCase()
                    font.pixelSize: 10
                    font.weight: Font.Bold
                    font.letterSpacing: 0.8
                    color: "#38BDF8"
                }
            }

            // Stream Status Toggle
            Button {
                id: streamToggleBtn
                property bool isRunning: true
                text: isRunning ? "Pause Stream" : "Resume Stream"
                font.pixelSize: 11
                font.weight: Font.Medium

                contentItem: Text {
                    text: streamToggleBtn.text
                    font: streamToggleBtn.font
                    color: streamToggleBtn.hovered ? "#FFFFFF" : "#94A3B8"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    implicitWidth: 95
                    implicitHeight: 24
                    radius: 6
                    color: streamToggleBtn.hovered ? "#1E293B" : "#111726"
                    border.color: streamToggleBtn.hovered ? "#38BDF8" : "#334155"
                }

                onClicked: {
                    isRunning = !isRunning;
                    vitalityBridge.toggleSimulation(isRunning);
                }
            }
        }

        // ---------------------------------------------------------------------
        // Telemetry Metrics Grid (2 columns x 2 rows primary + 2 mini)
        // ---------------------------------------------------------------------
        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: 10
            columnSpacing: 10

            // 1. Heart Rate
            MetricCard {
                Layout.fillWidth: true
                Layout.preferredHeight: 112
                icon: "💓"
                title: "Heart Rate"
                value: vitalityBridge.heartRate.toString()
                unit: "BPM"
                accentColor: "#FF3366"
                isPulsing: true
                subtext: vitalityBridge.stressLevel + " Stress • Sinus Rhythm"
            }

            // 2. Steps
            MetricCard {
                Layout.fillWidth: true
                Layout.preferredHeight: 112
                icon: "👟"
                title: "Daily Steps"
                value: vitalityBridge.steps.toLocaleString()
                unit: "steps"
                accentColor: "#00F2FE"
                progress: Math.min(1.0, vitalityBridge.steps / 10000.0)
                subtext: Math.round((vitalityBridge.steps / 10000.0) * 100) + "% of 10k target"
            }

            // 3. Sleep Hours
            MetricCard {
                Layout.fillWidth: true
                Layout.preferredHeight: 112
                icon: "🌙"
                title: "Sleep Duration"
                value: vitalityBridge.sleepHours.toFixed(1)
                unit: "hrs"
                accentColor: "#8B5CF6"
                progress: Math.min(1.0, vitalityBridge.sleepHours / 8.0)
                subtext: "Quality: " + vitalityBridge.sleepQuality + "% (Target: 8.0h)"
            }

            // 4. Caloric Intake & Burn
            MetricCard {
                Layout.fillWidth: true
                Layout.preferredHeight: 112
                icon: "🔥"
                title: "Energy Balance"
                value: vitalityBridge.caloricIntake.toString()
                unit: "in / " + vitalityBridge.caloricBurned + " out"
                accentColor: "#F97316"
                subtext: "Net: " + (vitalityBridge.caloricIntake - vitalityBridge.caloricBurned > 0 ? "+" : "") +
                         (vitalityBridge.caloricIntake - vitalityBridge.caloricBurned) + " kcal"
            }
        }

        // Secondary metrics bar (SpO2 & HRV)
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Rectangle {
                Layout.fillWidth: true
                height: 48
                radius: 8
                color: "#111726"
                border.color: "#1E293B"

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 8

                    Text { text: "🫁"; font.pixelSize: 14 }
                    Text { text: "Blood Oxygen (SpO2):"; font.pixelSize: 11; color: "#94A3B8" }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: vitalityBridge.spo2 + "%"
                        font.pixelSize: 13
                        font.weight: Font.Bold
                        color: "#10B981"
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 48
                radius: 8
                color: "#111726"
                border.color: "#1E293B"

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 8

                    Text { text: "⚡"; font.pixelSize: 14 }
                    Text { text: "Autonomic HRV:"; font.pixelSize: 11; color: "#94A3B8" }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: vitalityBridge.hrv + " ms"
                        font.pixelSize: 13
                        font.weight: Font.Bold
                        color: "#14B8A6"
                    }
                }
            }
        }

        // ---------------------------------------------------------------------
        // Real-Time Heart Rate Sparkline Waveform
        // ---------------------------------------------------------------------
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 110
            radius: 10
            color: "#111726"
            border.color: "#1E293B"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 4

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "HEART RATE OSCILLATION (BPM)"
                        font.pixelSize: 10
                        font.weight: Font.Bold
                        font.letterSpacing: 0.8
                        color: "#94A3B8"
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: "LIVE STREAM"
                        font.pixelSize: 9
                        font.weight: Font.Bold
                        color: "#FF3366"
                    }
                }

                SparklineCanvas {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    dataPoints: vitalityBridge.heartRateHistory
                    lineColor: "#FF3366"
                    fillColor: Qt.rgba(1.0, 0.2, 0.4, 0.15)
                    lineWidth: 2.0
                }
            }
        }

        // ---------------------------------------------------------------------
        // Telemetry Activity Event Feed / Terminal
        // ---------------------------------------------------------------------
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 10
            color: "#080C14"
            border.color: "#1E293B"
            clip: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 6

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "TELEMETRY EVENT STREAM"
                        font.pixelSize: 10
                        font.weight: Font.Bold
                        font.letterSpacing: 0.8
                        color: "#64748B"
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: "TICK: 2s"
                        font.pixelSize: 9
                        font.family: "Consolas, monospace"
                        color: "#475569"
                    }
                }

                ListView {
                    id: logListView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: vitalityBridge.eventLogs
                    spacing: 4
                    clip: true

                    onCountChanged: {
                        Qt.callLater(function() {
                            logListView.positionViewAtEnd();
                        });
                    }

                    delegate: Text {
                        width: logListView.width
                        text: modelData
                        font.pixelSize: 11
                        font.family: "Consolas, monospace"
                        color: modelData.indexOf("⚠️") !== -1 ? "#F59E0B" :
                               modelData.indexOf("Directives") !== -1 ? "#00F2FE" :
                               modelData.indexOf("Activity") !== -1 ? "#38BDF8" : "#94A3B8"
                        wrapMode: Text.Wrap
                    }
                }
            }
        }
    }
}
