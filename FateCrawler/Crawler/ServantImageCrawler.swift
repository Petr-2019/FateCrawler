//
//  ServantImageCrawler.swift
//  FateCrawler
//
//  Created by Peter-Guan on 2020/6/19.
//  Copyright © 2020 FoxHound-Peter-Guan. All rights reserved.
//

import Foundation

class ServantImageCrawler {

    /// ids: [1~283], cardId: A~E
    func crawlAllServantImages(ids: [Int], cardId: String) {
        // http://fgo-cdn.vgtime.com/media/fgo/servant/card/002D.png
        // http://fgo-cdn.vgtime.com/media/fgo/servant/card/\(p).png

        // 001A~009A
        for id in ids {
            let sema = DispatchSemaphore( value: 0 )
            let p = tweakName(id: id) + cardId
            
            if let url = URL(string: "http://fgo-cdn.vgtime.com/media/fgo/servant/card/\(p).png") {
                print("Begin the request")
                let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                    guard let data = data else { return }

                    do {
                        let fileURL = try FileManager.default
                            .url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                            .appendingPathComponent("servant_\(id)_whole_status_\(cardId).png")

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
    }

    func tweakName(id: Int) -> String {
        if id >= 1 && id <= 9 {
            return "00\(id)"
        }
        else if id >= 10 && id <= 99 {
            return "0\(id)"
        }
        else {
            return "\(id)"
        }
    }

    func crawlMoonCellServant() {
        
    }
}
