import WidgetKit
import SwiftUI
import AppIntents

struct AuraEntry: TimelineEntry {
    let date: Date
    let quote: String
    let days: Int
    let habitDone: Bool
}
struct AuraProvider: TimelineProvider {
    func placeholder(in context:Context)->AuraEntry { makeEntry() }
    func getSnapshot(in context:Context,completion:@escaping(AuraEntry)->Void) { completion(makeEntry()) }
    func getTimeline(in context:Context,completion:@escaping(Timeline<AuraEntry>)->Void) {
        completion(Timeline(entries:[makeEntry()],policy:.after(.now.addingTimeInterval(900))))
    }
    private func makeEntry()->AuraEntry {
        let d=AuraStorage.defaults
        let target=Date(timeIntervalSince1970:d.double(forKey:AuraStorage.countdownKey))
        let actual=d.double(forKey:AuraStorage.countdownKey)>0 ? target : Date.now.addingTimeInterval(7*86400)
        return AuraEntry(date:.now,quote:d.string(forKey:AuraStorage.quoteKey) ?? "Создавай своё пространство",days:max(0,Calendar.current.dateComponents([.day],from:.now,to:actual).day ?? 0),habitDone:d.bool(forKey:AuraStorage.habitKey))
    }
}
struct AuraQuoteWidget: Widget {
    var body:some WidgetConfiguration {
        StaticConfiguration(kind:"AuraQuoteWidget",provider:AuraProvider()) { e in
            AuraCard { VStack(alignment:.leading,spacing:8) { Text("ФОКУС").font(.caption2.bold()).foregroundStyle(.cyan); Text("“\(e.quote)”").font(.headline).lineLimit(4) } }
        }.configurationDisplayName("Фокус-цитата").description("Ваша цитата на экране Домой.").supportedFamilies([.systemSmall,.systemMedium])
    }
}
struct AuraCountdownWidget: Widget {
    var body:some WidgetConfiguration {
        StaticConfiguration(kind:"AuraCountdownWidget",provider:AuraProvider()) { e in
            AuraCard { VStack(alignment:.leading) { Text("ОСТАЛОСЬ").font(.caption2.bold()).foregroundStyle(.cyan); Text("\(e.days)").font(.system(size:38,weight:.bold,design:.rounded)); Text("дней до цели").font(.caption) } }
        }.configurationDisplayName("Обратный отсчёт").description("Дни до вашей даты.").supportedFamilies([.systemSmall,.systemMedium])
    }
}
struct AuraHabitWidget: Widget {
    var body:some WidgetConfiguration {
        StaticConfiguration(kind:"AuraHabitWidget",provider:AuraProvider()) { e in
            AuraCard { VStack(alignment:.leading,spacing:10) { Text("ПРИВЫЧКА ДНЯ").font(.caption2.bold()).foregroundStyle(.cyan); Button(intent:ToggleAuraHabitIntent()) { Label(e.habitDone ? "Выполнено":"Отметить привычку",systemImage:e.habitDone ? "checkmark.circle.fill":"circle") }.buttonStyle(.plain) } }
        }.configurationDisplayName("Привычка дня").description("Отмечайте привычку прямо в виджете.").supportedFamilies([.systemSmall,.systemMedium])
    }
}
struct AuraCard<C:View>:View {
    @ViewBuilder var content:C
    var body:some View { content.frame(maxWidth:.infinity,maxHeight:.infinity,alignment:.leading).padding().containerBackground(for:.widget) { LinearGradient(colors:[.black,Color(red:0.1,green:0.12,blue:0.22)],startPoint:.topLeading,endPoint:.bottomTrailing) }.foregroundStyle(.white) }
}
struct ToggleAuraHabitIntent:AppIntent {
    static var title:LocalizedStringResource="Переключить привычку"
    func perform() async throws -> some IntentResult {
        let d=AuraStorage.defaults
        d.set(!d.bool(forKey:AuraStorage.habitKey),forKey:AuraStorage.habitKey)
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
@main struct AuraWidgetBundle:WidgetBundle {
    var body:some Widget { AuraQuoteWidget(); AuraCountdownWidget(); AuraHabitWidget() }
}
