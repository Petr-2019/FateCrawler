//
//  VGTimeCrawler.swift
//  FateCrawler
//
//  Created by Peter-Guan on 2020/6/21.
//  Copyright © 2020 FoxHound-Peter-Guan. All rights reserved.
//

import Foundation
import SwiftSoup

class VGTimeCrawler {

    private let filterLists = ["No.240", "No.168", "No.152", "No.151", "No.149", "No.83"]

    func crawlServantBasicMode() {
        // 95156~95599
        var start = 95158
        while start <= 95599 {
            let link = "http://fgo.vgtime.com/servant/\(start)"

            let sema = DispatchSemaphore( value: 0 )
            if let url = URL(string: link) {
                print("Begin the request for \(start)")

                let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                    guard let data = data else { return }

                    if let result = String(data: data, encoding: .utf8) {
                        if let model = self.parse(rawHTML: result) {

                            func writeToFile(model: ServantBasicModel) {
                                do {
                                    let fileURL = try FileManager.default
                                        .url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                                        .appendingPathComponent("servant-basicInfo-\(model.id).json")

                                    try JSONEncoder().encode(model).write(to: fileURL)
                                } catch {
                                    print(error)
                                }
                            }

                            writeToFile(model: model)
                        }
                        else {
                            print("This failed, index: \(start)")
                        }
                    }

                    sema.signal()
                }

                task.resume()
            }
            sema.wait()

            start += 1
        }

    }

    func parse(rawHTML: String) -> ServantBasicModel? {
        do {
            let doc: Document = try SwiftSoup.parse(rawHTML)

            let spans = try doc.select(".uk-text-bold")
            if let span = spans.first() {
                let servantId = try span.text()

                if filterLists.contains(servantId) {
                    return nil
                }

                let ukTables = try doc.select("table")
                if let table1 = ukTables.first() {
                    let childrens = table1.children()[0].children()
                    if childrens.count == 8 {
                        let tr2 = childrens[1]
                        let tr2Childrens = tr2.children()
                        if tr2Childrens.count >= 5 {
                            // 性别
                            let gender = try tr2Childrens[0].text()
                            // 身高
                            let height = try tr2Childrens[1].text()
                            // 重量
                            let weight = try tr2Childrens[2].text()
                            // 阵营
                            let camp = try tr2Childrens[3].text()
                            // 地域
                            let region = try tr2Childrens[4].text()

                            let tr3 = childrens[2]
                            let tr3Childrens = tr3.children()
                            if tr3Childrens.count >= 2 {
                                let tr3Td = tr3Childrens[0]
                                // 配卡
                                var cards = [String]()

                                for img in tr3Td.children() {
                                    let src = try img.attr("src")
                                    cards.append(reduceCard(link: src))
                                }

                                let tr4 = childrens[3]
                                let tr4Childrens = tr4.children()

                                if !tr4Childrens.isEmpty() {
                                    // 出处
                                    let lore = try tr4Childrens[0].text()

                                    let tr5 = childrens[5]
                                    let tr5Childrens = tr5.children()
                                    if tr5Childrens.count >= 3 {
                                        // 属性
                                        let shuxing = try tr5Childrens[0].text()
                                        // 特性
                                        let texing = try tr5Childrens[1].text()
                                        // 昵称
                                        let nickNames = try tr5Childrens[2].text()

                                        let tr7 = childrens[7]
                                        let tr7Childrens = tr7.children()

                                        if tr7Childrens.count >= 3 {
                                            // 绘师
                                            let huishi = try tr7Childrens[0].text()
                                            // CV
                                            let voiceCast = try tr7Childrens[1].text()
                                            // 入手方式
                                            let access = try tr7Childrens[2].text()

                                            return ServantBasicModel(
                                                id: toServantId(idString: servantId),
                                                gender: gender,
                                                height: height,
                                                weight: weight,
                                                camp: camp,
                                                region: region,
                                                cards: cards,
                                                source: lore,
                                                attribute: shuxing,
                                                tokusei: splitTokusei(tokusei: texing),
                                                nickNames: splitNickNames(nickNames: nickNames),
                                                illustrator: huishi,
                                                castVoice: voiceCast,
                                                access: access
                                            )
                                        }
                                    }
                                }
                            }
                        }
                    }
                }


            }
        }
        catch {
            print("Bad things happend!")
        }

        return nil
    }

    private func splitNickNames(nickNames: String) -> [String] {
        return nickNames.components(separatedBy: " ")
    }

    private func splitTokusei(tokusei: String) -> [String] {
        return tokusei.components(separatedBy: ",")
    }

    private func reduceCard(link: String) -> String {
        if link == "http://fgo-misc.vgtime.com/themes/fgo/v3/images/pic/pattern_01.png" {
            return "1"
        }
        else if link == "http://fgo-misc.vgtime.com/themes/fgo/v3/images/pic/pattern_02.png" {
            return "2"
        }
        else {
            return "3"
        }
    }

    // No.3
    private func toServantId(idString: String) -> String {
        let tokens = idString.components(separatedBy: ".")
        return tokens[1]
    }
}
