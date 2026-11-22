import SwiftUI
struct ContentView: View {
    var body: some View {
        TabView {
            WidgetStudioView().tabItem { Label("Виджеты", systemImage:"square.grid.2x2") }
            IconEngineView().tabItem { Label("Иконки", systemImage:"app.dashed") }
            LockScreenStudioView().tabItem { Label("Обои и Экран", systemImage:"rectangle.portrait") }
            PresetsView().tabItem { Label("Пресеты", systemImage:"sparkles") }
        }
    }
}
