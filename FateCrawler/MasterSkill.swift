//
//  MasterSkill.swift
//  FateCrawler
//
//  Created by Peter-Guan on 2020/4/16.
//  Copyright © 2020 FoxHound-Peter-Guan. All rights reserved.
//

import Foundation

public struct SkillDetail: Codable {
    let skillName: String
    let countDown: String
    let lvEffect: [LVEffect]?
    let stableEffect: String?
}

public struct LVEffect: Codable {
    let effect: String
    let lv: [String]
}

public struct MasterSkill: Codable {
    let exp: [String]
    let desc: String
    let skills: [SkillDetail]
}
