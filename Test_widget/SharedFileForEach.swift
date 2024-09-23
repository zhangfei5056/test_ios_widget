//
//  FileSharer.swift
//  Test_widget
//
//  Created by Yuan Cao on 2024/9/23.
//

import Foundation

public class FileSharer: NSObject {
    public static let appGroup = "group.com.test_mywidget"
    public static let shared = FileSharer()

    @objc dynamic var text: String {
        get {
            let sharedDefaults = UserDefaults(suiteName: FileSharer.appGroup)
            return sharedDefaults?.string(forKey: "widgetData") ?? "🟥"
        }
        set {
            // 自定义 setter 行为
            let sharedDefaults = UserDefaults(suiteName: FileSharer.appGroup)
            sharedDefaults?.set(newValue, forKey: "widgetData")
        }
    }

    func toggleText() {
        if "🟥" == FileSharer.shared.text {
            FileSharer.shared.text = "🟩"
        } else {
            FileSharer.shared.text = "🟥"
        }
    }

}
