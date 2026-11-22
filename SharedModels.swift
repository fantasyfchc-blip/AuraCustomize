import Foundation
import SwiftUI

enum AuraTheme: String, CaseIterable, Identifiable, Codable {
    case oled = "OLED Черный", glass = "Матовое стекло", cyberpunk = "Киберпанк Неон", minimal = "Минимал Белый", matcha = "Матча Эстетика"
    var id: String { rawValue }
    var background: Color {
        switch self {
        case .oled: return Color(red: 0.015, green: 0.015, blue: 0.025)
        case .glass: return Color(red: 0.18, green: 0.20, blue: 0.25)
        case .cyberpunk: return Color(red: 0.055, green: 0.025, blue: 0.13)
        case .minimal: return Color(red: 0.94, green: 0.94, blue: 0.91)
        case .matcha: return Color(red: 0.78, green: 0.84, blue: 0.70)
        }
    }
    var accent: Color {
        switch self {
        case .oled: return .cyan
        case .glass: return Color(red: 0.70, green: 0.82, blue: 0.96)
        case .cyberpunk: return Color(red: 0.96, green: 0.18, blue: 0.82)
        case .minimal: return Color(white: 0.2)
        case .matcha: return Color(red: 0.25, green: 0.39, blue: 0.24)
        }
    }
    var foreground: Color { self == .minimal || self == .matcha ? .black : .white }
}
struct AuraPreset: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let subtitle: String
    let theme: AuraTheme
    let symbol: String
    static let all: [AuraPreset] = [
        .init(id:"midnight",name:"Midnight OLED",subtitle:"Глубокий чёрный и холодный свет",theme:.oled,symbol:"moon.stars.fill"),
        .init(id:"frost",name:"Frosted Glass",subtitle:"Спокойное матовое стекло",theme:.glass,symbol:"drop.halffull"),
        .init(id:"neon",name:"Neon Pulse",subtitle:"Киберпанк и яркие акценты",theme:.cyberpunk,symbol:"bolt.fill"),
        .init(id:"paper",name:"Clean Paper",subtitle:"Чистый минимализм",theme:.minimal,symbol:"sun.max.fill"),
        .init(id:"matcha",name:"Matcha Day",subtitle:"Мягкая природная палитра",theme:.matcha,symbol:"leaf.fill")
    ]
}
enum AuraStorage {
    static let suiteName = "group.com.aura.customizer"
    static let themeKey = "selectedTheme", quoteKey = "widgetQuote", countdownKey = "countdownDate", habitKey = "habitCompleted"
    static var defaults: UserDefaults { UserDefaults(suiteName: suiteName) ?? .standard }
    static func saveTheme(_ theme: AuraTheme) { defaults.set(theme.rawValue, forKey: themeKey) }
}
struct AuraActivityAttributes: Codable, Hashable {
    var title: String
    struct ContentState: Codable, Hashable { var progress: Int; var detail: String }
}
