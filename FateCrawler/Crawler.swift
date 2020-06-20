//
//  Crawler.swift
//  FateCrawler
//
//  Created by Peter-Guan on 2020/4/16.
//  Copyright © 2020 FoxHound-Peter-Guan. All rights reserved.
//

import Foundation

class Crawler {

    func crawl(names: [String: String]) {
        for (key, name) in names {
            let root = "https://fgo.wiki"
            let path = "/w/" + name
            var urlcomps = URLComponents(string: root)!
            urlcomps.path = path

            let sema = DispatchSemaphore( value: 0 )

            if let url = urlcomps.url {
                print("Begin the request")
                let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                    guard let data = data else { return }

                    let result = getDataString(input: String(data: data, encoding: .utf8)!)
                    writeToFile(result: result, ffName: "\(key)_HP_ATK")

                    sema.signal()
                }

                task.resume()
            }
            else {
                print("Fuck you!")
            }

            sema.wait()
        }

    }

}
