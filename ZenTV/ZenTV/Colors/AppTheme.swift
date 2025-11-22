import SwiftUI

// MARK: - Scene Model

enum MeditationScene: String, CaseIterable, Identifiable {
    case lavender
    case sunset
    case ocean
    case forest

    var id: String { rawValue }

    var title: String {
        switch self {
        case .lavender: return "Lavender Calm"
        case .sunset: return "Sunset Peace"
        case .ocean: return "Ocean Blue"
        case .forest: return "Forest Breeze"
        }
    }

    var description: String {
        switch self {
        case .lavender: return "Soft lavender glow for quiet focus"
        case .sunset: return "Warm evening sky to unwind your day"
        case .ocean: return "Calm rolling waves and distant sea air"
        case .forest: return "Gentle forest breeze and stillness"
        }
    }

    var gradient: LinearGradient {
        switch self {
        case .lavender:
            return LinearGradient(
                colors: [AppColors.lightSecondary, AppColors.lightBackground],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .sunset:
            return LinearGradient(
                colors: [Color(hex: "#FF9A8B"), Color(hex: "#FF6A88"), Color(hex: "#FF99AC")],
                startPoint: .top,
                endPoint: .bottom
            )
        case .ocean:
            return LinearGradient(
                colors: [Color(hex: "#1A2980"), Color(hex: "#26D0CE")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .forest:
            return LinearGradient(
                colors: [Color(hex: "#134E5E"), Color(hex: "#71B280")],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}

// MARK: - Theme helpers

struct AppTheme {
    static func background(for scheme: ColorScheme) -> Color {
        scheme == .dark ? AppColors.darkBackground : AppColors.lightBackground
    }

    static func secondary(for scheme: ColorScheme) -> Color {
        scheme == .dark ? AppColors.darkSecondary : AppColors.lightSecondary
    }

    static func accent(for scheme: ColorScheme) -> Color {
        scheme == .dark ? AppColors.darkAccent : AppColors.lightAccent
    }

    static func softBackgroundGradient(for scheme: ColorScheme) -> LinearGradient {
        let base = background(for: scheme)
        let accent = secondary(for: scheme).opacity(0.6)
        return LinearGradient(
            colors: [base, accent, base],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
