import SwiftUI

// MARK: - Color Theme (Lavender Theme B)

struct AppColors {
    // Light mode
    static let lightBackground = Color(hex: "#ECE9F7")
    static let lightSecondary = Color(hex: "#A58BD6")
    static let lightAccent = Color(hex: "#4ED2B8")

    // Dark mode (slightly deeper variants for contrast)
    static let darkBackground = Color(hex: "#181625")
    static let darkSecondary = Color(hex: "#6F5AA8")
    static let darkAccent = Color(hex: "#36A792")
}

extension Color {
    /// Initialize Color from a hex string like "#RRGGBB" or "RRGGBB".
    init(hex: String, alpha: Double = 1.0) {
        var cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cleaned.hasPrefix("#") {
            cleaned.removeFirst()
        }

        var rgb: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&rgb)

        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0

        self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}
