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

//let url = URL(string: "http://fgo.vgtime.com/servant/95158")
// let sema = DispatchSemaphore( value: 0 )

// 95157 95256 95355

//var beginIndex = 95408
//while beginIndex <= 95415 {
//
//    if let url = URL(string: "http://fgo.vgtime.com/servant/\(beginIndex)") {
//        print("Begin the request")
//        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
//            guard let data = data else { return }
//
//            let result = String(data: data, encoding: .utf8)!
//            let materialModel = Analyzer.shared.analyze(rawHTML: result)
//            writeToFile(materialModel: materialModel)
//
//            sema.signal()
//        }
//
//        task.resume()
//    }
//    else {
//        print("Fuck you!")
//    }
//
//    sema.wait()
//
//    beginIndex += 1
//}

//let materialModel = Analyzer.shared.analyze(rawHTML: rawHTML)

//let imgCompressor = ImageCompressor()
//
//let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
//let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
//let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
//if let dirPath          = paths.first
//{
//
//   let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("fgo_resource/servant_image/1024x1448/A/servant_1_whole_status_1.png")
//    if let image    = UIImage(contentsOfFile: imageURL.path) {
//        let resized = imgCompressor.resize(image: image, w: 512, h: 724)
//        imgCompressor.write(id: "1", cardId: "A", image: resized)
//    }
//    else {
//        print("WTF")
//    }
//   // Do whatever you want with the image
//}

//let crawler = ServantImageCrawler()
//crawler.crawlAllServantImages(ids: [1], cardId: "A")



let c = MoonCellCrawler()
if let url = URL(string: "https://fgo.wiki/w/%E9%98%BF%E5%B0%94%E6%89%98%E8%8E%89%E9%9B%85%C2%B7%E6%BD%98%E5%BE%B7%E6%8B%89%E8%B4%A1%E3%80%94Lily%E3%80%95") {
    c.toRawHTMLString(url: url)
}

