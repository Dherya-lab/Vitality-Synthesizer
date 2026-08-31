pragma Singleton
import QtQuick

QtObject {
    // -------------------------------------------------------------------------
    // Background & Surface Colors (Modern Deep Cyber / Healthtech Dark Theme)
    // -------------------------------------------------------------------------
    readonly property color bgBase: "#090D16"         // Deep Obsidian
    readonly property color bgSurface: "#111726"      // Card Background
    readonly property color bgSurfaceElevated: "#182238" // Highlighted Card / Hover
    readonly property color bgSurfaceHeader: "#0E1422"
    readonly property color borderSubtle: "#1E293B"    // Slate Border
    readonly property color borderGlow: "#334155"      // Active Border
    readonly property color borderHighlight: "#38BDF8" // Cyan Accent Glow

    // -------------------------------------------------------------------------
    // Biometric & Accent Colors
    // -------------------------------------------------------------------------
    readonly property color accentCyan: "#00F2FE"      // Primary UI Accent & Steps
    readonly property color accentElectricBlue: "#38BDF8"
    readonly property color accentEmerald: "#10B981"   // Recovery / Optimal Status
    readonly property color accentHeart: "#FF3366"     // Heart Rate Neon Pink/Red
    readonly property color accentAmber: "#F59E0B"     // Moderate / Attention Warning
    readonly property color accentPurple: "#8B5CF6"    // Sleep / AI Neural Glow
    readonly property color accentCalorie: "#F97316"   // Caloric Intake / Metabolic
    readonly property color accentTeal: "#14B8A6"      // HRV / Autonomic Balance

    // -------------------------------------------------------------------------
    // Text Typography Colors
    // -------------------------------------------------------------------------
    readonly property color textPrimary: "#F8FAFC"
    readonly property color textSecondary: "#94A3B8"
    readonly property color textMuted: "#64748B"
    readonly property color textInverse: "#090D16"

    // -------------------------------------------------------------------------
    // Status Semantic Helpers
    // -------------------------------------------------------------------------
    function statusColor(status) {
        if (!status) return accentEmerald;
        var s = status.toUpperCase();
        if (s === "OPTIMAL") return accentEmerald;
        if (s === "MODERATE") return accentAmber;
        if (s === "ATTENTION_NEEDED" || s === "ATTENTION") return accentHeart;
        return accentCyan;
    }

    function categoryColor(cat) {
        if (!cat) return accentCyan;
        var c = cat.toUpperCase();
        if (c === "WORKOUT") return accentCyan;
        if (c === "NUTRITION") return accentCalorie;
        if (c === "RECOVERY") return accentPurple;
        if (c === "HYDRATION") return accentTeal;
        return accentEmerald;
    }

    // -------------------------------------------------------------------------
    // Fonts & Dimensions
    // -------------------------------------------------------------------------
    readonly property string fontFamily: "Segoe UI, -apple-system, Roboto, sans-serif"
    readonly property string monoFontFamily: "Consolas, 'Courier New', monospace"

    readonly property int radiusSmall: 6
    readonly property int radiusMedium: 10
    readonly property int radiusLarge: 16
    readonly property int radiusRound: 999
}
