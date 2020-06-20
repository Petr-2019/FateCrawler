//
//  MoonCellCrawler.swift
//  FateCrawler
//
//  Created by Peter-Guan on 2020/6/20.
//  Copyright © 2020 FoxHound-Peter-Guan. All rights reserved.
//

import Foundation
import SwiftSoup

class MoonCellCrawler {

    func toRawHTMLString(url: URL) {
        let sema = DispatchSemaphore( value: 0 )
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }

            if let result = String(data: data, encoding: .utf8) {
                self.getImageDownloadURLs(rawHTML: result)
            }

            sema.signal()
        }

        task.resume()
        sema.wait()
    }

    func getImageDownloadURLs(rawHTML: String) {
        do {
        // http://fgo.vgtime.com/servant/95158
            let doc: Document = try SwiftSoup.parse(rawHTML)
            // graphpicker-graph-0
            let div = try doc.select(".graphpicker-graph-0")
            print(div)
        }
        catch {
            print("Bad things happend!")
        }
    }

}

