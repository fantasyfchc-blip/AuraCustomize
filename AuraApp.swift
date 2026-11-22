import SwiftUI
@main struct AuraApp: App {
    @AppStorage(AuraStorage.themeKey, store: AuraStorage.defaults) private var themeName = AuraTheme.oled.rawValue
    var body: some Scene {
        WindowGroup {
            ContentView().preferredColorScheme(themeName == AuraTheme.minimal.rawValue || themeName == AuraTheme.matcha.rawValue ? .light : .dark)
        }
    }
}
