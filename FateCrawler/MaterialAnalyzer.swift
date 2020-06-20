//
//  MaterialAnalyzer.swift
//  FateCrawler
//
//  Created by Peter-Guan on 2020/4/21.
//  Copyright © 2020 FoxHound-Peter-Guan. All rights reserved.
//

import Foundation
import SwiftSoup

class Analyzer {

    static let shared = Analyzer()

    func analyze(rawHTML: String) -> MaterialModel {
        do {
            // http://fgo.vgtime.com/servant/95158
            let doc: Document = try SwiftSoup.parse(rawHTML)
            let tables = try doc.select("table")
            let metas = try doc.select("meta")

            let material = MaterialModel()

            if !metas.isEmpty() {
                let content = try metas[metas.size() - 1].attr("content")
                material.servantName = content
            }

            let spans = try doc.select("span")

            for span in spans {
                if span.ownText().contains("No.") {
                    material.id = span.ownText()
                }
                break
            }

            var locateTH: Element?

            for table in tables {
                let ths = try table.select("th")

                var skip = false
                for th in ths {
                    if th.ownText() == "技能升级" {
                        // found the table
                        locateTH = th
                        skip = true
                        break
                    }
                }
                if skip {
                    break
                }
            }

            if let th = locateTH {
                if let th_parent = th.parent() {
                    let siblings = th_parent.siblingElements()

                    for sibling in siblings {
                        let tds = sibling.children()

                        var i = 0

                        var skillModel = SkillModel()
                        var materials = [MaterialAndCost]()

                        for td in tds {
                            if i == 0 {
                                skillModel.levelName = td.ownText()
                                //print("Level: \(td.ownText())")
                            }
                            else if i == 1 {
                                for div in td.children() {
                                    let title = try div.child(0).attr("title")
                                    let materialCount = div.child(1).ownText()

                                    let m = MaterialAndCost(materialName: title, materialCost: materialCount)
                                    materials.append(m)
                                    //print("\(title): \(materialCount)")
                                }
                            }
                            else if i == 2 {
                                skillModel.qp = td.ownText()
                                //print("QP: \(td.ownText())")
                            }

                            i += 1
                        }

                        skillModel.materialAndCost = materials
                        //print(skillModel.materials)

                        material.materials.append(skillModel)
                    }
                }
            }


            var locateTh2: Element?

            for table in tables {
                let ths = try table.select("th")

                var skip = false
                for th in ths {
                    if th.ownText() == "灵基再临" {
                        // found the table
                        locateTh2 = th
                        skip = true
                        break
                    }
                }
                if skip {
                    break
                }
            }

            if let th = locateTh2 {
                if let th_parent = th.parent() {
                    let siblings = th_parent.siblingElements()

                    for sibling in siblings {
                        let tds = sibling.children()

                        var i = 0

                        var skillModel = SkillModel()
                        var materials = [MaterialAndCost]()

                        for td in tds {
                            if i == 0 {
                                skillModel.levelName = td.ownText()
                                //print("Level: \(td.ownText())")
                            }
                            else if i == 1 {
                                for div in td.children() {
                                    let title = try div.child(0).attr("title")
                                    let materialCount = div.child(1).ownText()

                                    let m = MaterialAndCost(materialName: title, materialCost: materialCount)
                                    materials.append(m)
                                    //print("\(title): \(materialCount)")
                                }
                            }
                            else if i == 2 {
                                skillModel.qp = td.ownText()
                                //print("QP: \(td.ownText())")
                            }

                            i += 1
                        }

                        skillModel.materialAndCost = materials
                        //print(skillModel.materialAndCost)

                        material.maxLevelMaterials.append(skillModel)
                    }
                }
            }

            return material

        } catch {
            print("Bad things happend!")
            return MaterialModel()
        }
    }
}
