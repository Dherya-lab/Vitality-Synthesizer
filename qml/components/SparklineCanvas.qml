import QtQuick

Canvas {
    id: root

    property var dataPoints: []
    property color lineColor: "#FF3366"
    property color fillColor: Qt.rgba(lineColor.r, lineColor.g, lineColor.b, 0.15)
    property real lineWidth: 2.0
    property bool drawFill: true
    property real minY: 0
    property real maxY: 0

    antialiasing: true
    renderTarget: Canvas.FramebufferObject

    onDataPointsChanged: {
        requestPaint();
    }

    onPaint: {
        var ctx = getContext("2d");
        ctx.reset();

        var w = width;
        var h = height;

        if (!dataPoints || dataPoints.length < 2) {
            return;
        }

        // Calculate min/max bounds
        var minVal = minY;
        var maxVal = maxY;

        if (minVal === 0 && maxVal === 0) {
            minVal = dataPoints[0];
            maxVal = dataPoints[0];
            for (var i = 1; i < dataPoints.length; i++) {
                if (dataPoints[i] < minVal) minVal = dataPoints[i];
                if (dataPoints[i] > maxVal) maxVal = dataPoints[i];
            }
            // Add padding
            var range = maxVal - minVal;
            if (range < 5) range = 5;
            minVal -= range * 0.15;
            maxVal += range * 0.15;
        }

        var padding = 4;
        var drawH = h - (padding * 2);
        var stepX = (w - (padding * 2)) / (dataPoints.length - 1);

        // Build path coordinates
        var points = [];
        for (var idx = 0; idx < dataPoints.length; idx++) {
            var val = dataPoints[idx];
            var normY = (val - minVal) / (maxVal - minVal);
            normY = Math.max(0, Math.min(1, normY));
            var px = padding + (idx * stepX);
            var py = padding + (drawH * (1.0 - normY));
            points.push({ x: px, y: py });
        }

        // Draw fill gradient under curve
        if (drawFill) {
            var grad = ctx.createLinearGradient(0, 0, 0, h);
            grad.addColorStop(0, fillColor);
            grad.addColorStop(1, Qt.rgba(lineColor.r, lineColor.g, lineColor.b, 0.0));

            ctx.beginPath();
            ctx.moveTo(points[0].x, h);
            ctx.lineTo(points[0].x, points[0].y);

            for (var k = 1; k < points.length; k++) {
                var prev = points[k - 1];
                var curr = points[k];
                var cpx = (prev.x + curr.x) / 2;
                ctx.quadraticCurveTo(prev.x, prev.y, cpx, (prev.y + curr.y) / 2);
            }
            ctx.lineTo(points[points.length - 1].x, points[points.length - 1].y);
            ctx.lineTo(points[points.length - 1].x, h);
            ctx.closePath();

            ctx.fillStyle = grad;
            ctx.fill();
        }

        // Draw stroke line
        ctx.beginPath();
        ctx.moveTo(points[0].x, points[0].y);
        for (var j = 1; j < points.length; j++) {
            var p0 = points[j - 1];
            var p1 = points[j];
            var midX = (p0.x + p1.x) / 2;
            ctx.quadraticCurveTo(p0.x, p0.y, midX, (p0.y + p1.y) / 2);
        }
        ctx.lineTo(points[points.length - 1].x, points[points.length - 1].y);

        ctx.strokeStyle = lineColor;
        ctx.lineWidth = lineWidth;
        ctx.lineCap = "round";
        ctx.lineJoin = "round";
        ctx.stroke();

        // Draw active pulse dot at the last point
        var lastPt = points[points.length - 1];
        ctx.beginPath();
        ctx.arc(lastPt.x, lastPt.y, 3.5, 0, 2 * Math.PI, false);
        ctx.fillStyle = lineColor;
        ctx.fill();
        ctx.strokeStyle = "#FFFFFF";
        ctx.lineWidth = 1.5;
        ctx.stroke();
    }
}
