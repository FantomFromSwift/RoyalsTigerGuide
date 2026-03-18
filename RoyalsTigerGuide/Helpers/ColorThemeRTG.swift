import SwiftUI

struct ColorThemeRTG {
    static var primaryOrange: Color {
        let themeId = UserDefaults.standard.string(forKey: "selectedThemeRTG") ?? "default"
        switch themeId {
        case "royalsTigerThemeOne": return Color(red: 0.0, green: 1.0, blue: 0.8)
        case "royalsTigerThemeTwo": return Color(red: 1.0, green: 0.4, blue: 0.4)
        default: return Color(red: 1.0, green: 0.42, blue: 0.0)
        }
    }
    
    static let secondaryGold = Color(red: 1.0, green: 0.84, blue: 0.0)
    static let darkJungle = Color(red: 0.04, green: 0.06, blue: 0.1)
    static let darkCard = Color(red: 0.11, green: 0.14, blue: 0.20)
    
    static var accentGlow: Color {
        let themeId = UserDefaults.standard.string(forKey: "selectedThemeRTG") ?? "default"
        switch themeId {
        case "royalsTigerThemeOne": return Color(red: 0.0, green: 0.5, blue: 1.0)
        case "royalsTigerThemeTwo": return Color(red: 1.0, green: 0.7, blue: 0.2)
        default: return Color(red: 1.0, green: 0.58, blue: 0.0)
        }
    }
    
    static let textSecondary = Color(red: 0.63, green: 0.66, blue: 0.72)
    static let deepBackground = Color(red: 0.06, green: 0.08, blue: 0.14)
    static let emeraldAccent = Color(red: 0.0, green: 0.78, blue: 0.55)
    static let dangerRed = Color(red: 0.95, green: 0.25, blue: 0.3)
    static let cardBorder = Color.white.opacity(0.08)

    static var primaryGradient: LinearGradient {
        let themeId = UserDefaults.standard.string(forKey: "selectedThemeRTG") ?? "default"
        switch themeId {
        case "royalsTigerThemeOne": return neonGradient
        case "royalsTigerThemeTwo": return sunriseGradient
        default:
            return LinearGradient(
                colors: [Color(red: 1.0, green: 0.42, blue: 0.0), Color(red: 1.0, green: 0.58, blue: 0.0)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    static let backgroundGradient = LinearGradient(
        colors: [darkJungle, deepBackground, Color(red: 0.08, green: 0.1, blue: 0.18)],
        startPoint: .top,
        endPoint: .bottom
    )

    static let goldGradient = LinearGradient(
        colors: [secondaryGold, primaryOrange],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let neonGradient = LinearGradient(
        colors: [Color(red: 0.0, green: 1.0, blue: 0.8), Color(red: 0.0, green: 0.5, blue: 1.0)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let sunriseGradient = LinearGradient(
        colors: [Color(red: 1.0, green: 0.4, blue: 0.4), Color(red: 1.0, green: 0.7, blue: 0.2)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
