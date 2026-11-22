import SwiftUI
import UIKit
import ActivityKit

struct LockScreenStudioView:View {
    @AppStorage(AuraStorage.themeKey,store:AuraStorage.defaults) private var themeName=AuraTheme.oled.rawValue
    @State private var glow=0.8
    @State private var dock=0.65
    @State private var message=""
    private var theme:AuraTheme { AuraTheme(rawValue:themeName) ?? .oled }
    var body:some View {
        NavigationStack {
            ScrollView {
                VStack(alignment:.leading,spacing:18) {
                    Text("Lock Screen Studio").font(.largeTitle.bold())
                    Text("Холст iPhone 11 Pro: 1125 × 2436 px, с вырезом TrueDepth.")
                    WallpaperPreview(theme:theme,glow:glow,dock:dock).aspectRatio(1125/2436,contentMode:.fit)
                    VStack { HStack { Text("Обводка"); Spacer(); Text("\(Int(glow*100))%") }; Slider(value:$glow,in:0.1...1); HStack { Text("Подложка дока"); Spacer(); Text("\(Int(dock*100))%") }; Slider(value:$dock,in:0...1) }.padding().background(.ultraThinMaterial,in:RoundedRectangle(cornerRadius:18))
                    Button { UIImageWriteToSavedPhotosAlbum(WallpaperRenderer.render(theme:theme,glow:glow,dockShade:dock),nil,nil,nil); message="Обои отправлены в Фото." } label: { Label("Сохранить обои в Фото",systemImage:"square.and.arrow.down").frame(maxWidth:.infinity) }.buttonStyle(.borderedProminent)
                    Button(action:startActivity) { Label("Запустить Live Activity",systemImage:"livephoto").frame(maxWidth:.infinity) }.buttonStyle(.bordered)
                    Button(role:.destructive,action:endActivities) { Label("Завершить Live Activity",systemImage:"stop.circle").frame(maxWidth:.infinity) }.buttonStyle(.bordered)
                    Text(message).font(.footnote).foregroundStyle(.secondary)
                    Text("На iPhone 11 Pro нет Dynamic Island. Live Activity отображается на экране блокировки при разрешении функции в iOS.")
                        .font(.footnote).foregroundStyle(.secondary)
                }.padding()
            }.navigationBarHidden(true)
        }
    }
    private func startActivity() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { message="Live Activities отключены в настройках iOS."; return }
        do {
            let a=AuraActivityAttributes(title:"Aura focus")
            let s=AuraActivityAttributes.ContentState(progress:1,detail:"Ваш экран — ваше пространство")
            _=try Activity.request(attributes:a,content:ActivityContent(state:s,staleDate:nil),pushType:nil)
            message="Live Activity запущена."
        } catch { message="Ошибка запуска: \(error.localizedDescription)" }
    }
    private func endActivities() {
        Task { for a in Activity<AuraActivityAttributes>.activities { await a.end(nil,dismissalPolicy:.immediate) }; message="Live Activity завершена." }
    }
}
struct WallpaperPreview:View {
    let theme:AuraTheme; let glow:Double; let dock:Double
    var body:some View {
        ZStack {
            RoundedRectangle(cornerRadius:40).fill(theme.background)
            Circle().fill(theme.accent.opacity(0.3)).frame(width:170).blur(radius:50).offset(x:50,y:-170)
            RoundedRectangle(cornerRadius:38).stroke(theme.accent.opacity(glow),lineWidth:4).padding(8).shadow(color:theme.accent.opacity(glow),radius:12)
            VStack { Capsule().fill(.white).frame(width:82,height:8).padding(.top,5); Spacer(); Text("9:41").font(.system(size:40,weight:.light)); Text(Date.now.formatted(date:.complete,time:.omitted)).font(.caption); Spacer(); RoundedRectangle(cornerRadius:20).fill(.black.opacity(dock)).frame(height:42).padding(.horizontal,18).padding(.bottom,12) }.foregroundStyle(theme.foreground)
        }.clipShape(RoundedRectangle(cornerRadius:40))
        .overlay(alignment:.top) { UnevenRoundedRectangle(bottomLeadingRadius:18,bottomTrailingRadius:18).fill(.black).frame(width:150,height:30) }
    }
}
