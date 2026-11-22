import SwiftUI
import WidgetKit
struct WidgetStudioView: View {
    @AppStorage(AuraStorage.quoteKey, store: AuraStorage.defaults) private var quote = "Создавай пространство, которое вдохновляет."
    @AppStorage(AuraStorage.countdownKey, store: AuraStorage.defaults) private var stamp = Date.now.addingTimeInterval(7*86400).timeIntervalSince1970
    @AppStorage(AuraStorage.habitKey, store: AuraStorage.defaults) private var done = false
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment:.leading,spacing:18) {
                    Text("Widget Studio").font(.largeTitle.bold())
                    Text("Изменения сохраняются локально и обновляют виджеты.")
                        .foregroundStyle(.secondary)
                    GroupBox("Фокус-цитата") {
                        TextField("Ваша цитата",text:$quote,axis:.vertical).onChange(of:quote) { _,_ in reload() }
                        preview { Text("“\(quote)”").font(.headline).lineLimit(3) }
                    }
                    GroupBox("Обратный отсчёт") {
                        DatePicker("Целевая дата",selection:Binding(get:{Date(timeIntervalSince1970:stamp)},set:{stamp=$0.timeIntervalSince1970;reload()}),in:Date.now...,displayedComponents:.date)
                        preview { Text("\(max(0,Calendar.current.dateComponents([.day],from:.now,to:Date(timeIntervalSince1970:stamp)).day ?? 0)) дней").font(.largeTitle.bold()) }
                    }
                    GroupBox("Привычка дня") {
                        Toggle("Выполнено",isOn:$done).onChange(of:done) { _,_ in reload() }
                        preview { Label(done ? "Привычка выполнена" : "Время для привычки",systemImage:done ? "checkmark.circle.fill" : "circle") }
                    }
                    Text("Добавьте виджет через удержание экрана Домой → «+» → AuraCustomize.")
                        .font(.footnote).foregroundStyle(.secondary)
                }.padding()
            }.navigationBarHidden(true)
        }
    }
    private func reload() { WidgetCenter.shared.reloadAllTimelines() }
    private func preview<C:View>(@ViewBuilder _ content:()->C)->some View {
        content().frame(maxWidth:.infinity,minHeight:76,alignment:.leading).padding().background(.ultraThinMaterial,in:RoundedRectangle(cornerRadius:16))
    }
}
