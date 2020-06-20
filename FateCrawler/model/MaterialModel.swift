//
//  MaterialModel.swift
//  FateCrawler
//
//  Created by Peter-Guan on 2020/4/21.
//  Copyright © 2020 FoxHound-Peter-Guan. All rights reserved.
//

import Foundation

class MaterialModel: Codable {
    var servantName = ""
    var materials = [SkillModel]()
    var maxLevelMaterials = [SkillModel]()
    var id = ""
}

struct SkillModel: Codable {
    var levelName = ""
    var materialAndCost = [MaterialAndCost]()
    var qp = ""
}

struct MaterialAndCost: Codable {
    let materialName: String
    let materialCost: String
}
