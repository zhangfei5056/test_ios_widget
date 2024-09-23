//
//  ViewController.swift
//  Test_widget
//
//  Created by Yuan Cao on 2024/9/23.
//

import UIKit
import WidgetKit

class ViewController: UIViewController {

    let button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: NSNotification.Name("CustomNotification"), object: nil)

        button.frame = CGRect(x: 100, y: 300, width: 280, height: 100)
        button.backgroundColor = .lightGray

        button.setTitle("Sync: \(FileSharer.shared.text)", for: .normal)
        button.setTitleColor(.red, for: .normal)
        view.addSubview(button)
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)

    }

    @objc func handleNotification(_ notification: Notification) {
            print("Notification received!")
            button.setTitle("Sync: \(FileSharer.shared.text)", for: .normal)
            if let userInfo = notification.userInfo {
                print("User info: \(userInfo)")
            }
        }

    @objc
    func buttonTap() {
        print("👉\("button tapped")👈")

        FileSharer.shared.toggleText()
        button.setTitle("Sync: \(FileSharer.shared.text)", for: .normal)
        WidgetCenter.shared.reloadTimelines(ofKind: "MyWidget")
    }

    deinit {
            // 移除观察者
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name("CustomNotification"), object: nil)
        }

}

