import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property string icon: "⚡"
    property string title: "METRIC"
    property string value: "--"
    property string unit: ""
    property string subtext: ""
    property color accentColor: "#00F2FE"
    property real progress: -1.0 // 0.0 to 1.0 (if >= 0, draws a progress bar)
    property bool isPulsing: false

    color: "#111726"
    radius: 12
    border.color: mouseArea.containsMouse ? accentColor : "#1E293B"
    border.width: 1

    Behavior on border.color {
        ColorAnimation { duration: 200 }
    }

    // Top accent border stripe
    Rectangle {
        id: topAccent
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 2
        radius: 2
        color: root.accentColor
        opacity: mouseArea.containsMouse ? 1.0 : 0.6
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 6

        // Top Row: Icon, Title & Live Pulse Dot
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            // Icon Badge
            Rectangle {
                width: 28
                height: 28
                radius: 6
                color: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.15)

                Text {
                    anchors.centerIn: parent
                    text: root.icon
                    font.pixelSize: 14
                }
            }

            // Title
            Text {
                text: root.title.toUpperCase()
                font.pixelSize: 11
                font.weight: Font.Bold
                font.letterSpacing: 1.1
                font.family: "Segoe UI, sans-serif"
                color: "#94A3B8"
                Layout.fillWidth: true
                elide: Text.ElideRight
            }

            // Live Indicator Pulse
            Rectangle {
                width: 8
                height: 8
                radius: 4
                color: root.accentColor
                visible: root.isPulsing

                SequentialAnimation on opacity {
                    running: root.isPulsing
                    loops: Animation.Infinite
                    PropertyAnimation { to: 0.2; duration: 600; easing.type: Easing.InOutQuad }
                    PropertyAnimation { to: 1.0; duration: 600; easing.type: Easing.InOutQuad }
                }
            }
        }

        Item { Layout.fillHeight: true }

        // Value & Unit Row
        RowLayout {
            spacing: 6
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

            Text {
                text: root.value
                font.pixelSize: 26
                font.weight: Font.DemiBold
                font.family: "Segoe UI, sans-serif"
                color: "#F8FAFC"
            }

            Text {
                text: root.unit
                font.pixelSize: 13
                font.weight: Font.Medium
                font.family: "Segoe UI, sans-serif"
                color: root.accentColor
                Layout.alignment: Qt.AlignBaseline
            }
        }

        // Optional Progress Bar
        Rectangle {
            Layout.fillWidth: true
            height: 4
            radius: 2
            color: "#1E293B"
            visible: root.progress >= 0.0

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: Math.min(parent.width, parent.width * Math.max(0.0, Math.min(1.0, root.progress)))
                radius: 2
                color: root.accentColor

                Behavior on width {
                    NumberAnimation { duration: 400; easing.type: Easing.OutCubic }
                }
            }
        }

        // Subtext / Secondary status
        Text {
            text: root.subtext
            font.pixelSize: 11
            font.family: "Segoe UI, sans-serif"
            color: "#64748B"
            Layout.fillWidth: true
            elide: Text.ElideRight
            visible: root.subtext.length > 0
        }
    }
}
