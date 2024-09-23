//
//  MyWidgetBundle.swift
//  MyWidget
//
//  Created by Yuan Cao on 2024/9/23.
//

import WidgetKit
import SwiftUI

@main
struct MyWidgetBundle: WidgetBundle {
    var body: some Widget {
        MyWidget()
        MyWidgetControl()
    }
}
