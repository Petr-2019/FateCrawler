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

    func crawlServantBasicMode() {

    }

    func parse(rawHTML: String) {
        do {
            let doc: Document = try SwiftSoup.parse(rawHTML)

            let h4Labels = try doc.select(".uk-codex-title uk-margin-small-top")
            if let h4Label = h4Labels.first(), let spanLabel = h4Label.children().first() {
                let servantId = try spanLabel.text()

                let ukTables = try doc.select(".uk-table uk-codex-table")
                if let table1 = ukTables.first() {
                    
                }


            }
        }
        catch {
            print("Bad things happend!")
        }
    }

}

// ServantBasicModel
//ServantBasicModel(id: <#T##String#>, gender: <#T##String#>, height: <#T##String#>, weight: <#T##String#>, camp: <#T##String#>, region: <#T##String#>, cards: <#T##[String]#>, source: <#T##String#>, attributes: <#T##[String]#>, tokusei: <#T##[String]#>, nickNames: <#T##[String]#>, illustrator: <#T##String#>, castVoice: <#T##String#>, access: <#T##String#>)
