//
//  main.swift
//  FateCrawler
//
//  Created by Peter-Guan on 2020/4/15.
//  Copyright © 2020 FoxHound-Peter-Guan. All rights reserved.
//

import Cocoa
import Foundation
import SwiftSoup

let crawler = MoonCellCrawler()

var links = [String]()
var imgNames = [String]()

for (index, link) in crawler.imageLinks.enumerated() {
    if (index%2 == 0) {
        links.append(link)
    }
    else {
        imgNames.append(link)
    }
}

for (index, link) in links.enumerated() {
    let sema = DispatchSemaphore( value: 0 )

    if let url = URL(string: link) {
        print("Begin the request")

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }

            do {
                let fileURL = try FileManager.default
                    .url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    .appendingPathComponent(imgNames[index])

                try data.write(to: fileURL)
            } catch {
                print(error)
            }

            sema.signal()
        }

        task.resume()
    }

    sema.wait()
}
