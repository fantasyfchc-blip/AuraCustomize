import SwiftUI
import PhotosUI
import UIKit

struct AppChoice:Identifiable,Hashable {
    let id:String; let name:String; let scheme:String; let symbol:String
    static let all:[AppChoice] = [
        .init(id:"telegram",name:"Telegram",scheme:"tg://",symbol:"paperplane.fill"),
        .init(id:"youtube",name:"YouTube",scheme:"youtube://",symbol:"play.rectangle.fill"),
        .init(id:"instagram",name:"Instagram",scheme:"instagram://",symbol:"camera.fill"),
        .init(id:"spotify",name:"Spotify",scheme:"spotify://",symbol:"music.note"),
        .init(id:"discord",name:"Discord",scheme:"discord://",symbol:"gamecontroller.fill"),
        .init(id:"tiktok",name:"TikTok",scheme:"tiktok://",symbol:"music.quarternote.3"),
        .init(id:"whatsapp",name:"WhatsApp",scheme:"whatsapp://",symbol:"message.fill"),
        .init(id:"vk",name:"VK",scheme:"vk://",symbol:"person.2.fill")
    ]
}
struct IconEngineView:View {
    @State private var app=AppChoice.all[0]
    @State private var symbol="paperplane.fill"
    @State private var photo:PhotosPickerItem?
    @State private var image:UIImage?
    @State private var error:String?
    private let symbols=["sparkles","heart.fill","star.fill","moon.stars.fill","bolt.fill","leaf.fill","flame.fill","cloud.fill","gamecontroller.fill","camera.fill","music.note","paperplane.fill"]
    var body:some View {
        NavigationStack {
            ScrollView {
                VStack(alignment:.leading,spacing:18) {
                    Text("Icon Engine").font(.largeTitle.bold())
                    Text("Создайте профиль Web Clip с собственной иконкой.")
                    Picker("Приложение",selection:$app) { ForEach(AppChoice.all) { Text($0.name).tag($0) } }.pickerStyle(.menu)
                    HStack(spacing:16) { icon.frame(width:76,height:76).clipShape(RoundedRectangle(cornerRadius:18)); VStack(alignment:.leading) { Text(app.name).font(.headline); Text("Предпросмотр ярлыка").font(.caption).foregroundStyle(.secondary) } }
                    Text("SF Symbols").font(.headline)
                    LazyVGrid(columns:[GridItem(.adaptive(minimum:58))]) {
                        ForEach(symbols,id:\.self) { s in
                            Button { symbol=s; image=nil } label: { Image(systemName:s).font(.title2).frame(width:58,height:58).background(symbol == s && image == nil ? Color.purple.opacity(0.25):Color.secondary.opacity(0.12),in:RoundedRectangle(cornerRadius:14)) }.buttonStyle(.plain)
                        }
                    }
                    PhotosPicker(selection:$photo,matching:.images) { Label("Выбрать иконку из Фото",systemImage:"photo") }
                        .onChange(of:photo) { _,item in Task { if let data=try? await item?.loadTransferable(type:Data.self),let ui=UIImage(data:data) { image=ui } } }
                    Button {
                        do { let url=try ProfileGenerator.createProfile(for:app,symbol:symbol,image:image); ShareSheet.present(url:url) }
                        catch { self.error=error.localizedDescription }
                    } label: { Label("Создать и экспортировать .mobileconfig",systemImage:"square.and.arrow.up").frame(maxWidth:.infinity) }.buttonStyle(.borderedProminent)
                    Text("Web Clip добавляет ярлык, но не меняет иконку установленного приложения. iOS может запросить подтверждение установки профиля; запуск без баннеров не гарантируется и зависит от URL-схемы приложения.")
                        .font(.footnote).foregroundStyle(.secondary)
                    if let error { Text(error).foregroundStyle(.red) }
                }.padding()
            }.navigationBarHidden(true)
        }
    }
    private var icon:some View {
        Group {
            if let image { Image(uiImage:image).resizable().scaledToFill() }
            else { ZStack { LinearGradient(colors:[.purple,.blue,.cyan],startPoint:.topLeading,endPoint:.bottomTrailing); Image(systemName:symbol).font(.system(size:34,weight:.semibold)).foregroundStyle(.white) } }
        }
    }
}
enum ShareSheet {
    static func present(url:URL) {
        guard let scene=UIApplication.shared.connectedScenes.compactMap({$0 as? UIWindowScene}).first,
              let root=scene.windows.first(where:\.isKeyWindow)?.rootViewController else { return }
        let vc=UIActivityViewController(activityItems:[url],applicationActivities:nil)
        if let pop=vc.popoverPresentationController { pop.sourceView=root.view; pop.sourceRect=CGRect(x:root.view.bounds.midX,y:root.view.bounds.midY,width:0,height:0) }
        root.present(vc,animated:true)
    }
}
