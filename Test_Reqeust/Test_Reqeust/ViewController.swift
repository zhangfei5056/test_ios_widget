//
//  ViewController.swift
//  Test_Reqeust
//
//  Created by Yuan Cao on 2024/9/10.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        requestSome()
    }

    func requestSome() {
        let urlString = "https://if9-icr.app.jaguarlandrover.cn/if9/jlr/vehicles/L2CJA2B79MG006213/status?includeInactive=true"
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        request.setValue("application/vnd.ngtp.org.if9.healthstatus-v4+json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer 38ead29f-94bc-4aaf-bdaf-dfe1f72abee1", forHTTPHeaderField: "Authorization")
        request.setValue("", forHTTPHeaderField: "X-App-Id")
        request.setValue("", forHTTPHeaderField: "X-App-Secret")
        request.setValue("zh-CN,zh-Hans;q=0.9", forHTTPHeaderField: "Accept-Language")
        request.setValue("gzip, deflate, br", forHTTPHeaderField: "Accept-Encoding")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("landroverprogram", forHTTPHeaderField: "x-telematicsprogramtype")
        request.setValue("CN-Landrover-InControl-Remote/1 CFNetwork/1568.100.1 Darwin/23.6.0", forHTTPHeaderField: "User-Agent")
        request.setValue("90AD8AF8-0B29-4A65-BF96-24792E1376BB", forHTTPHeaderField: "X-Device-Id")
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        request.setValue("TS01055984=01f3e3f480e2ce3c15a468245535a16fb723aa159824ff2f70c4d7efc15538c769586a576635766d72db6959f8448349b889d3d010", forHTTPHeaderField: "Cookie")

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
                print("Response: \(responseString ?? "")")
            }
        }

        task.resume()
    }

}

