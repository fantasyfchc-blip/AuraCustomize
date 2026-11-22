import SwiftUI
import UIKit
import WidgetKit
struct PresetsView:View {
    @AppStorage(AuraStorage.themeKey,store:AuraStorage.defaults) private var themeName=AuraTheme.oled.rawValue
    var body:some View {
        NavigationStack {
            ScrollView {
                VStack(alignment:.leading,spacing:18) {
                    Text("Готовые пресеты").font(.largeTitle.bold())
                    Text("Примените единую цветовую тему одним нажатием.")
                    ForEach(AuraPreset.all) { p in
                        Button {
                            UIImpactFeedbackGenerator(style:.medium).impactOccurred()
                            themeName=p.theme.rawValue
                            AuraStorage.saveTheme(p.theme)
                            WidgetCenter.shared.reloadAllTimelines()
                        } label: {
                            HStack(spacing:16) {
                                ZStack { RoundedRectangle(cornerRadius:16).fill(p.theme.background); Image(systemName:p.symbol).font(.title).foregroundStyle(p.theme.accent) }.frame(width:64,height:64)
                                VStack(alignment:.leading,spacing:5) { Text(p.name).font(.headline); Text(p.subtitle).font(.caption).foregroundStyle(.secondary) }
                                Spacer()
                                if themeName==p.theme.rawValue { Image(systemName:"checkmark.circle.fill").foregroundStyle(.green) }
                            }.padding().background(.ultraThinMaterial,in:RoundedRectangle(cornerRadius:20))
                        }.buttonStyle(.plain)
                    }
                }.padding()
            }.navigationBarHidden(true)
        }
    }
}
