//
//  MyWidget.swift
//  MyWidget
//
//  Created by Yuan Cao on 2024/9/23.
//

import WidgetKit
import SwiftUI
import AppIntents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct MyWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("info:\(GlobalText.shared.text)")
            Text("FileSharer:\(FileSharer.shared.text)")

            HStack {
                Button(intent: InteractiveWidgetGetVehicleInfoIntent()) {
                    Text("Get Vehicle Info")
                }

                Button(intent: SyncAppIntent()) {
                    Text("sync: \(FileSharer.shared.text)")
                }


            }
        }
    }
}



struct SyncAppIntent: AppIntent {
    static var title: LocalizedStringResource = "Sync App Info"
    func perform() async throws -> some IntentResult {
        print("👉\("sync app info...")👈")
        FileSharer.shared.toggleText()
        return .result()
    }
}



struct InteractiveWidgetGetVehicleInfoIntent: AppIntent {

    static var title: LocalizedStringResource = "Get Vehicle Info Event"

    init() {}

    func perform() async throws -> some IntentResult {
        print("👉\("get info")👈")
        getVehicleInfo()
        GlobalText.shared.text = "requesting ..."
        return .result()
    }

    func getVehicleInfo() {
        let urlString = "https://if9-icr.app.jaguarlandrover.cn/if9/jlr/vehicles/SALTS1CN24VDC0001/status?includeInactive=true"
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        request.setValue("application/vnd.ngtp.org.if9.healthstatus-v4+json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer 1d63fc37-5e54-40ad-8454-efc15857edad", forHTTPHeaderField: "Authorization")
        request.setValue("", forHTTPHeaderField: "X-App-Id")
        request.setValue("", forHTTPHeaderField: "X-App-Secret")
        request.setValue("zh-CN,zh-Hans;q=0.9", forHTTPHeaderField: "Accept-Language")
        request.setValue("gzip, deflate, br", forHTTPHeaderField: "Accept-Encoding")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("landroverprogram", forHTTPHeaderField: "x-telematicsprogramtype")
        request.setValue("CN-Landrover-InControl-Remote/1 CFNetwork/1568.100.1 Darwin/23.6.0", forHTTPHeaderField: "User-Agent")
        request.setValue("7CC7C838-0627-465C-880D-5A620FAB05C2", forHTTPHeaderField: "X-Device-Id")
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        request.setValue("TS01055984=0144ad2c2a235228ccaaac2b08b110dd6b9fc5de487aae76a6471dbefcf6cc9151c5da494bd743ceef14224b1f82ffc681db32b781", forHTTPHeaderField: "Cookie")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Status code: \(httpResponse.statusCode)")
            }

            if let data = data {
                let responseString = String(data: data, encoding:.utf8)
                print("Response: \(responseString ?? "no response")")
                GlobalText.shared.text = responseString ?? "no response"
                WidgetCenter.shared.reloadTimelines(ofKind: "MyWidget")
            }
        }

        task.resume()
    }
}


struct MyWidget: Widget {
    let kind: String = "MyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                MyWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                MyWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    MyWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}

struct GlobalText {
    static var shared = GlobalText()
    private init() {}
    var text: String = "init"
    var syncAppInfo: String = "🟩"
}
