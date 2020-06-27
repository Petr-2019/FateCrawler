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

    private func parseStory(rawHTML: String) -> ServantStoryModel? {
        do {
            let doc: Document = try SwiftSoup.parse(rawHTML)

            let spans = try doc.select(".uk-text-bold")
            if let span = spans.first() {
                let servantId = try span.text()

                if filterLists.contains(servantId) {
                    return nil
                }

                let ths = try doc.select(".uk-text-left")
                var firstTR: Element? = nil
                for th in ths {
                    let text = try th.text()
                    if text == "角色详细" {
                        firstTR = th.parent()
                        break
                    }
                }

                if let tr = firstTR {
                    let siblings = tr.siblingElements()

                    if siblings.count >= 13 {
                        let detail = try siblings[0].child(0).text()
                        let story1 = try siblings[2].child(0).text()
                        let story2 = try siblings[4].child(0).text()
                        let story3 = try siblings[6].child(0).text()
                        let story4 = try siblings[8].child(0).text()
                        let story5 = try siblings[10].child(0).text()
                        let story6 = try siblings[12].child(0).text()

                        return ServantStoryModel(
                            id: toServantId(idString: servantId),
                            detail: detail,
                            story1: story1,
                            story2: story2,
                            story3: story3,
                            story4: story4,
                            story5: story5,
                            story6: story6
                        )
                    }
                }
            }
        }
        catch {
            print("Bad things happend!")
        }

        return nil
    }

    func crawlServantStoryMode() {
        // 95156~95599
        var start = 95156
        while start <= 95599 {
            let link = "http://fgo.vgtime.com/servant/\(start)"

            let sema = DispatchSemaphore( value: 0 )
            if let url = URL(string: link) {
                print("Begin the request for \(start)")

                let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                    guard let data = data else { return }

                    if let result = String(data: data, encoding: .utf8) {
                        if let model = self.parseStory(rawHTML: result) {

                            func writeToFile(model: ServantStoryModel) {
                                do {
                                    let fileURL = try FileManager.default
                                        .url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                                        .appendingPathComponent("servant-story-\(model.id).json")

                                    try JSONEncoder().encode(model).write(to: fileURL)
                                } catch {
                                    print(error)
                                }
                            }

                            //print(model)
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

    func crawlServantSkillMode() {
        // 95156~95599
        var start = 95156
        while start <= 95156 {
            let link = "http://fgo.vgtime.com/servant/\(start)"

            let sema = DispatchSemaphore( value: 0 )
            if let url = URL(string: link) {
                print("Begin the request for \(start)")

                let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                    guard let data = data else { return }

                    if let result = String(data: data, encoding: .utf8) {
                        if let model = self.parseSkillAndNoble(rawHTML: result) {

                            func writeToFile(model: ServantSkillAndNoble) {
                                do {
                                    let fileURL = try FileManager.default
                                        .url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                                        .appendingPathComponent("servant-skillAndPhantasm-\(model.servantId).json")

                                    try JSONEncoder().encode(model).write(to: fileURL)
                                } catch {
                                    print(error)
                                }
                            }

                            //print(model)
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

    private func parseSkillAndNoble(rawHTML: String) -> ServantSkillAndNoble? {
        do {
            let doc: Document = try SwiftSoup.parse(rawHTML)

            let spans = try doc.select(".uk-text-bold")
            if let span = spans.first() {
                let servantId = try span.text()

                if filterLists.contains(servantId) {
                    return nil
                }

                let divs = try doc.select(".content-slide")
                if let div = divs.first() {
                    let tables = try div.select("table")
                    if tables.count >= 5 {
                        let servantNoblePhantasm = parseNoblePhantasm(table: tables[0])!
                        let updatedServantNoblePhantasm = parseNoblePhantasm(table: tables[1])

                        // 宝具
                        //**********************************

                        var skills = [ServantSkillModel]()
                        var updatedSkills = [ServantSkillModel?]()

                        var i = 1
                        if updatedServantNoblePhantasm != nil {
                            i = 2
                        }

                        while i < tables.count - 1 {
                            let skill = parseSkill(table: tables[i])
                            if let previousDiv = try tables[i].previousElementSibling(), try previousDiv.text() == "↓技能强化后↓" {
                                updatedSkills.append(skill)
                            }
                            else if let nextDiv = try tables[i].nextElementSibling(), try nextDiv.text() == "↓技能强化后↓" {
                                skills.append(skill!)
                            }
                            else {
                                skills.append(skill!)
                                updatedSkills.append(nil)
                            }

                            i += 1
                        }

                        // 主动技能
                        //**********************************

                        let classSkills = parseClassSkill(table: tables[tables.count - 1])

                        // 职阶技能
                        //**********************************

                        return ServantSkillAndNoble(servantId: servantId, noblePhantasm: servantNoblePhantasm, updatedNoblePhantasm: updatedServantNoblePhantasm, skills: skills, updatedSkills: updatedSkills, classSkills: classSkills)
                    }
                }
            }
        }
        catch {
            print("Bad things happend!")
        }

        return nil
    }

    private func parseNoblePhantasm(table: Element) -> ServantNoblePhantasm? {
        do {
            let trs = try table.select("tr")

            var card = ""
            var name = ""
            var hit = ""
            var level = ""
            var type = ""
            var requirement = ""

            var levelEffects = [LevelEffect]()
            var stableEffects = [StableEffect]()
            var chargeEffects = [LevelEffect]()

            for tr in trs {
                if tr.children().count == 7 {
                    let first = tr.children()[0]
                    let text = try first.text()
                    if text == "等级效果" {
                        let desc = try tr.child(1).text()
                        let e1 = try tr.child(2).text()
                        let e2 = try tr.child(3).text()
                        let e3 = try tr.child(4).text()
                        let e4 = try tr.child(5).text()
                        let e5 = try tr.child(6).text()

                        levelEffects.append(LevelEffect(effect: desc, values: [e1, e2, e3, e4, e5]))
                    }
                    else if text == "蓄力效果" {
                        let desc = try tr.child(1).text()
                        let e1 = try tr.child(2).text()
                        let e2 = try tr.child(3).text()
                        let e3 = try tr.child(4).text()
                        let e4 = try tr.child(5).text()
                        let e5 = try tr.child(6).text()

                        chargeEffects.append(LevelEffect(effect: desc, values: [e1, e2, e3, e4, e5]))
                    }
                    else if text == "固定效果" {
                        let desc = try tr.child(1).text()
                        let e = try tr.child(2).text()
                        stableEffects.append(StableEffect(effect: desc, value: e))
                    }
                    else if text != "指令卡" {
                        // 宝具详情
                        card = try tr.children()[0].child(0).attr("src")
                        name = try tr.children()[1].text()
                        hit = try tr.children()[2].text()
                        level = try tr.children()[3].text()
                        type = try tr.children()[4].text()
                        requirement = try tr.children()[5].text()
                    }
                }
            }

            if card != "" && name != "" && hit != "" && level != "" && type != "" && requirement != "" {
                let servantNoblePhantasm = ServantNoblePhantasm(card: card, name: name, hit: hit, level: level, type: type, requirement: requirement, levelEffects: levelEffects, stableEffects: stableEffects, chargeEffects: chargeEffects)
                return servantNoblePhantasm
            }
            else {
                return nil
            }
        }
        catch {
            print("Bad things happend!")
        }

        return nil
    }

    private func parseSkill(table: Element) -> ServantSkillModel? {
        // let skills: [ServantSkillModel]
        var foundDesc = false

        do {
            var name = ""
            var avatar = ""
            var level = ""
            var coldDown = ""
            var requirement = ""

            var levelEffects = [LevelEffect]()
            var stableEffects = [StableEffect]()

            var fList = [Element]()
            var fList2 = [Element]()

            for child in table.child(1).children() {
                if let fchild = child.children().first() {
                    let skilText = try fchild.text()

                    // 固定效果
                    if child.children().count == 3 {
                        let effect = try child.child(1).text()
                        let val = try child.child(2).text()
                        stableEffects.append(StableEffect(effect: effect, value: val))
                    }
                    // 等级效果 前半部分
                    else if child.children().count == 7 && skilText != "指令卡" {
                        fList.append(child)
                    }
                    else if child.children().count == 5 {
                        // 等级效果 后半部分
                        if foundDesc {
                            fList2.append(child)
                        }
                        // 技能名 等
                        else {
                            avatar = try child.child(0).child(0).attr("src")
                            name = try child.child(1).text()
                            level = try child.child(2).text()
                            coldDown = try child.child(3).text()
                            requirement = try child.child(4).text()

                            foundDesc = true
                        }
                    }
                }
            }

            if fList.count == fList2.count {
                for (index, v) in fList.enumerated() {
                    let name = try v.child(1).text()
                    let v1 = try v.child(2).text()
                    let v2 = try v.child(3).text()
                    let v3 = try v.child(4).text()
                    let v4 = try v.child(5).text()
                    let v5 = try v.child(6).text()
                    let v6 = try fList2[index].child(0).text()
                    let v7 = try fList2[index].child(1).text()
                    let v8 = try fList2[index].child(2).text()
                    let v9 = try fList2[index].child(3).text()
                    let v10 = try fList2[index].child(4).text()

                    levelEffects.append(LevelEffect(effect: name, values: [v1, v2, v3, v4, v5, v6, v7, v8, v9, v10]))
                }

                return ServantSkillModel(
                    name: name,
                    avatar: avatar,
                    level: level,
                    coldDown: coldDown,
                    requirement: requirement,
                    levelEffects: levelEffects,
                    stableEffects: stableEffects
                )
            }
        }
        catch {
            print("Bad things happend!")
        }

        return nil
    }

    private func parseClassSkill(table: Element) -> [ClassSkill] {
        do {
            var classSkills = [ClassSkill]()
            let trs = try table.select("tr")
            for tr in trs {
                if tr.children().count == 4 {
                    let avatar = try tr.child(0).child(0).attr("src")
                    let name = try tr.child(1).text()
                    let level = try tr.child(2).text()
                    let effect = try tr.child(3).text()

                    classSkills.append(ClassSkill(avatar: avatar, name: name, level: level, effect: effect))
                }
            }

            return classSkills
        }
        catch {
            print("Bad things happend!")
        }

        return [ClassSkill]()
    }
}
