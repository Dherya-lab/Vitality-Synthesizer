import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    color: "#0B101D"
    radius: 14
    border.color: vitalityBridge.isAnalyzing ? "#00F2FE" : "#1E293B"
    border.width: 1

    Behavior on border.color {
        ColorAnimation { duration: 300 }
    }

    // Helper functions for colors
    function getStatusColor(status) {
        if (!status) return "#10B981";
        var s = status.toUpperCase();
        if (s === "OPTIMAL") return "#10B981";
        if (s === "MODERATE") return "#F59E0B";
        if (s === "ATTENTION_NEEDED" || s === "ATTENTION") return "#FF3366";
        return "#00F2FE";
    }

    function getCategoryColor(cat) {
        if (!cat) return "#00F2FE";
        var c = cat.toUpperCase();
        if (c === "WORKOUT") return "#00F2FE";
        if (c === "NUTRITION") return "#F97316";
        if (c === "RECOVERY") return "#8B5CF6";
        if (c === "HYDRATION") return "#14B8A6";
        return "#10B981";
    }

    function getUrgencyColor(urgency) {
        if (!urgency) return "#94A3B8";
        var u = urgency.toUpperCase();
        if (u === "HIGH") return "#FF3366";
        if (u === "MEDIUM") return "#F59E0B";
        return "#10B981";
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 14

        // ---------------------------------------------------------------------
        // 1. Agent Status & Synthesis Cycle Header
        // ---------------------------------------------------------------------
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            // Glowing AI Neural Core Orb
            Rectangle {
                width: 32
                height: 32
                radius: 16
                color: vitalityBridge.isAnalyzing ? "#00F2FE" : "#8B5CF6"

                SequentialAnimation on opacity {
                    running: vitalityBridge.isAnalyzing
                    loops: Animation.Infinite
                    PropertyAnimation { to: 0.3; duration: 400; easing.type: Easing.InOutQuad }
                    PropertyAnimation { to: 1.0; duration: 400; easing.type: Easing.InOutQuad }
                }

                Text {
                    anchors.centerIn: parent
                    text: vitalityBridge.isAnalyzing ? "⚙️" : "✨"
                    font.pixelSize: 15
                }
            }

            ColumnLayout {
                spacing: 2
                Layout.fillWidth: true

                RowLayout {
                    spacing: 8
                    Text {
                        text: "AGENT INSIGHTS & ACTIONS"
                        font.pixelSize: 13
                        font.weight: Font.Bold
                        font.letterSpacing: 1.2
                        color: "#F8FAFC"
                    }

                    // Mode Tag
                    Rectangle {
                        height: 18
                        width: modeLabel.implicitWidth + 12
                        radius: 9
                        color: vitalityBridge.apiKeyConfigured ? Qt.rgba(0.06, 0.72, 0.51, 0.15) : Qt.rgba(0.55, 0.36, 0.96, 0.15)
                        border.color: vitalityBridge.apiKeyConfigured ? "#10B981" : "#8B5CF6"
                        border.width: 1

                        Text {
                            id: modeLabel
                            anchors.centerIn: parent
                            text: vitalityBridge.agentMode
                            font.pixelSize: 9
                            font.weight: Font.Bold
                            color: vitalityBridge.apiKeyConfigured ? "#10B981" : "#C084FC"
                        }
                    }
                }

                Text {
                    text: vitalityBridge.isAnalyzing ?
                          "Analyzing 10s telemetry batch with Gemini..." :
                          "Next autonomous batch synthesis in " + vitalityBridge.secondsUntilNextAnalysis + "s"
                    font.pixelSize: 11
                    color: vitalityBridge.isAnalyzing ? "#00F2FE" : "#94A3B8"
                }
            }

            // Quick "Synthesize Now" Trigger Button
            Button {
                id: synthesizeBtn
                enabled: !vitalityBridge.isAnalyzing
                text: "Synthesize Now"
                font.pixelSize: 11
                font.weight: Font.DemiBold

                contentItem: Text {
                    text: synthesizeBtn.text
                    font: synthesizeBtn.font
                    color: vitalityBridge.isAnalyzing ? "#64748B" : "#FFFFFF"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    implicitWidth: 110
                    implicitHeight: 28
                    radius: 6
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: synthesizeBtn.hovered ? "#00F2FE" : "#0284C7" }
                        GradientStop { position: 1.0; color: synthesizeBtn.hovered ? "#4FACFE" : "#0369A1" }
                    }
                    opacity: vitalityBridge.isAnalyzing ? 0.4 : 1.0
                }

                onClicked: {
                    vitalityBridge.triggerManualAnalysis();
                }
            }
        }

        // ---------------------------------------------------------------------
        // Synthesis Countdown Progress Bar
        // ---------------------------------------------------------------------
        Rectangle {
            Layout.fillWidth: true
            height: 3
            radius: 1.5
            color: "#1E293B"

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * (1.0 - (vitalityBridge.secondsUntilNextAnalysis / vitalityBridge.totalCountdownSeconds))
                radius: 1.5
                color: vitalityBridge.isAnalyzing ? "#00F2FE" : "#8B5CF6"

                Behavior on width {
                    NumberAnimation { duration: 900; easing.type: Easing.Linear }
                }
            }
        }

        // ---------------------------------------------------------------------
        // 2. Vitality Score & Primary Insight Headline Card
        // ---------------------------------------------------------------------
        Rectangle {
            Layout.fillWidth: true
            radius: 12
            color: "#111726"
            border.color: getStatusColor(vitalityBridge.vitalityStatus)
            border.width: 1
            implicitHeight: insightCol.implicitHeight + 28

            Behavior on border.color {
                ColorAnimation { duration: 400 }
            }

            ColumnLayout {
                id: insightCol
                anchors.fill: parent
                anchors.margins: 14
                spacing: 10

                // Top row: Vitality Score + Status Tag + Timestamp
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    // Vitality Score Ring
                    Rectangle {
                        width: 44
                        height: 44
                        radius: 22
                        color: Qt.rgba(0.0, 0.95, 1.0, 0.1)
                        border.color: getStatusColor(vitalityBridge.vitalityStatus)
                        border.width: 2

                        Column {
                            anchors.centerIn: parent
                            Text {
                                text: vitalityBridge.vitalityScore.toString()
                                font.pixelSize: 16
                                font.weight: Font.Bold
                                color: "#F8FAFC"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }

                    ColumnLayout {
                        spacing: 2
                        Layout.fillWidth: true

                        RowLayout {
                            spacing: 8
                            Text {
                                text: "VITALITY INDEX"
                                font.pixelSize: 10
                                font.weight: Font.Bold
                                font.letterSpacing: 0.8
                                color: "#94A3B8"
                            }

                            Rectangle {
                                height: 18
                                width: statusText.implicitWidth + 12
                                radius: 9
                                color: Qt.rgba(getStatusColor(vitalityBridge.vitalityStatus).r,
                                               getStatusColor(vitalityBridge.vitalityStatus).g,
                                               getStatusColor(vitalityBridge.vitalityStatus).b, 0.2)
                                border.color: getStatusColor(vitalityBridge.vitalityStatus)
                                border.width: 1

                                Text {
                                    id: statusText
                                    anchors.centerIn: parent
                                    text: vitalityBridge.vitalityStatus
                                    font.pixelSize: 9
                                    font.weight: Font.Bold
                                    color: getStatusColor(vitalityBridge.vitalityStatus)
                                }
                            }
                        }

                        Text {
                            text: "Autonomous synthesis as of " + vitalityBridge.lastUpdated
                            font.pixelSize: 10
                            color: "#64748B"
                        }
                    }
                }

                // Primary Actionable Headline
                Rectangle {
                    Layout.fillWidth: true
                    radius: 8
                    color: Qt.rgba(0.04, 0.08, 0.15, 0.8)
                    border.color: "#1E293B"
                    implicitHeight: headlineText.implicitHeight + 16

                    Text {
                        id: headlineText
                        anchors.fill: parent
                        anchors.margins: 10
                        text: vitalityBridge.insightHeadline
                        font.pixelSize: 13
                        font.weight: Font.DemiBold
                        font.family: "Segoe UI, sans-serif"
                        color: "#F8FAFC"
                        wrapMode: Text.Wrap
                    }
                }

                // Detailed Clinical/Physiological Analysis Narrative
                Text {
                    Layout.fillWidth: true
                    text: vitalityBridge.insightAnalysis
                    font.pixelSize: 12
                    font.family: "Segoe UI, sans-serif"
                    color: "#94A3B8"
                    wrapMode: Text.Wrap
                    lineHeight: 1.3
                }
            }
        }

        // ---------------------------------------------------------------------
        // 3. Recommended Action Plans Header
        // ---------------------------------------------------------------------
        RowLayout {
            Layout.fillWidth: true

            Text {
                text: "RECOMMENDED ACTION PLANS"
                font.pixelSize: 11
                font.weight: Font.Bold
                font.letterSpacing: 1.0
                color: "#94A3B8"
            }

            Item { Layout.fillWidth: true }

            Text {
                text: vitalityBridge.actionPlans.length + " DIRECTIVES"
                font.pixelSize: 10
                font.weight: Font.Bold
                color: "#00F2FE"
            }
        }

        // ---------------------------------------------------------------------
        // 4. Action Plans Scrollable List
        // ---------------------------------------------------------------------
        ListView {
            id: actionListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: vitalityBridge.actionPlans
            spacing: 10
            clip: true

            delegate: Rectangle {
                width: actionListView.width
                implicitHeight: cardContent.implicitHeight + 20
                radius: 10
                color: "#111726"
                border.color: "#1E293B"
                border.width: 1

                // Left category color bar
                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 3
                    radius: 1.5
                    color: getCategoryColor(modelData.category)
                }

                ColumnLayout {
                    id: cardContent
                    anchors.fill: parent
                    anchors.leftMargin: 14
                    anchors.rightMargin: 12
                    anchors.topMargin: 10
                    anchors.bottomMargin: 10
                    spacing: 6

                    // Top Row: Category Tag & Urgency Badge
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        // Category Tag
                        Rectangle {
                            height: 20
                            width: catText.implicitWidth + 14
                            radius: 4
                            color: Qt.rgba(getCategoryColor(modelData.category).r,
                                           getCategoryColor(modelData.category).g,
                                           getCategoryColor(modelData.category).b, 0.15)

                            Text {
                                id: catText
                                anchors.centerIn: parent
                                text: (modelData.category || "GENERAL").toUpperCase()
                                font.pixelSize: 9
                                font.weight: Font.Bold
                                font.letterSpacing: 0.6
                                color: getCategoryColor(modelData.category)
                            }
                        }

                        // Title
                        Text {
                            text: modelData.title || "Directive"
                            font.pixelSize: 12
                            font.weight: Font.Bold
                            color: "#F8FAFC"
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }

                        // Urgency Tag
                        Rectangle {
                            height: 18
                            width: urgText.implicitWidth + 10
                            radius: 9
                            color: Qt.rgba(getUrgencyColor(modelData.urgency).r,
                                           getUrgencyColor(modelData.urgency).g,
                                           getUrgencyColor(modelData.urgency).b, 0.15)
                            border.color: getUrgencyColor(modelData.urgency)
                            border.width: 1

                            Text {
                                id: urgText
                                anchors.centerIn: parent
                                text: (modelData.urgency || "NORMAL").toUpperCase()
                                font.pixelSize: 8
                                font.weight: Font.Bold
                                color: getUrgencyColor(modelData.urgency)
                            }
                        }
                    }

                    // Directive Description
                    Text {
                        Layout.fillWidth: true
                        text: modelData.description || ""
                        font.pixelSize: 11
                        font.family: "Segoe UI, sans-serif"
                        color: "#94A3B8"
                        wrapMode: Text.Wrap
                        lineHeight: 1.2
                    }
                }
            }
        }
    }
}
