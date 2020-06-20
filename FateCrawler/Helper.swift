//
//  Helper.swift
//  FateCrawler
//
//  Created by Peter-Guan on 2020/4/15.
//  Copyright © 2020 FoxHound-Peter-Guan. All rights reserved.
//

import Foundation

public func getDataString(input: String) -> String {
    let l_pattern = "\"data\":[{\"name\":\"table\",\"values\":"
    let r_pattern = "},{\"name\":\"curLv\",\"source\":\"table\",\"transform\""

    if input.contains(l_pattern) {
        if let result = input.between(l_pattern, r_pattern) {
            return "{ \"data\": \(result) }"
        }

        return ""
    }
    else {
        return ""
    }

}

public func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)
    return paths[0]
}


public func writeToFile(result: String, ffName: String) {
    let filename = getDocumentsDirectory().appendingPathComponent("Servant_\(ffName)_HP_ATK.json")
    do {
        try result.write(to: filename, atomically: true, encoding: .utf8)
    } catch {
        print("Error \(error)")
    }
}

func writeToFile(materialModel: MaterialModel) {
    do {
        let fileURL = try FileManager.default
            .url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("servant_\(materialModel.id)_material.json")

        try JSONEncoder().encode(materialModel).write(to: fileURL)
    } catch {
        print(error)
    }
}

func readToMem() {
    let cwd = FileManager.default.currentDirectoryPath
    print(cwd)
    if let path = Bundle.main.path(forResource: "template", ofType: "json") {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let decoder = JSONDecoder()
            let materialModel = try decoder.decode(MaterialModel.self, from: data)

            print(materialModel)
        } catch {
            print("Bad things happened")
        }
    }
}
