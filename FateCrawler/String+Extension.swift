//
//  String+Extension.swift
//  FateCrawler
//
//  Created by Peter-Guan on 2020/4/16.
//  Copyright © 2020 FoxHound-Peter-Guan. All rights reserved.
//

import Foundation

extension String {

    //right is the first encountered string after left
    func between(_ left: String, _ right: String) -> String? {
        guard let leftRange = range(of: left), let rightRange = range(of: right, options: .backwards)
            ,leftRange.upperBound <= rightRange.lowerBound else { return nil }

        let sub = self[leftRange.upperBound...]
        let closestToLeftRange = sub.range(of: right)!
        return String(sub[..<closestToLeftRange.lowerBound])
    }

}
