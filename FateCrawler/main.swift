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

func crawlImages() {
    let crawler = MoonCellCrawler()

    var links = [String]()
    var imgNames = [String]()

    for (index, link) in crawler.imageLinks.enumerated() {
        if (index%2 == 0) {
            links.append(link)
        }
        else {
            imgNames.append(link)
        }
    }

    for (index, link) in links.enumerated() {
        let sema = DispatchSemaphore( value: 0 )

        if let url = URL(string: link) {
            print("Begin the request")

            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                guard let data = data else { return }

                do {
                    let fileURL = try FileManager.default
                        .url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                        .appendingPathComponent(imgNames[index])

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

func crawlBasicInfo() {
    let filterLists = [240, 168, 152, 151, 149, 83]

    let classArray = [
        "1: shielder",
        "2: saber",
        "3: saber",
        "4: saber",
        "5: saber",
        "6: saber",
        "7: saber",
        "8: saber",
        "9: saber",
        "10: saber",
        "11: archer",
        "12: archer",
        "13: archer",
        "14: archer",
        "15: archer",
        "16: archer",
        "17: lancer",
        "18: lancer",
        "19: lancer",
        "20: lancer",
        "21: lancer",
        "22: lancer",
        "23: rider",
        "24: rider",
        "25: rider",
        "26: rider",
        "27: rider",
        "28: rider",
        "29: rider",
        "30: rider",
        "31: caster",
        "32: caster",
        "33: caster",
        "34: caster",
        "35: caster",
        "36: caster",
        "37: caster",
        "38: caster",
        "39: assassin",
        "40: assassin",
        "41: assassin",
        "42: assassin",
        "43: assassin",
        "44: assassin",
        "45: assassin",
        "46: assassin",
        "47: berserker",
        "48: berserker",
        "49: berserker",
        "50: berserker",
        "51: berserker",
        "52: berserker",
        "53: berserker",
        "54: berserker",
        "55: berserker",
        "56: berserker",
        "57: berserker",
        "58: berserker",
        "59: ruler",
        "60: archer",
        "61: caster",
        "62: caster",
        "63: archer",
        "64: lancer",
        "65: rider",
        "66: rider",
        "67: caster",
        "68: saber",
        "69: archer",
        "70: lancer",
        "71: lancer",
        "72: saber",
        "73: rider",
        "74: caster",
        "75: assassin",
        "76: saber",
        "77: archer",
        "78: lancer",
        "79: caster",
        "80: caster",
        "81: assassin",
        "82: berserker",
        "83: alterego",
        "84: archer",
        "85: lancer",
        "86: assassin",
        "87: lancer",
        "88: lancer",
        "89: berserker",
        "90: saber",
        "91: saber",
        "92: assassin",
        "93: ruler",
        "94: rider",
        "95: archer",
        "96: avenger",
        "97: berserker",
        "98: berserker",
        "99: rider",
        "100: caster",
        "101: saber",
        "102: lancer",
        "103: caster",
        "104: caster",
        "105: archer",
        "106: avenger",
        "107: avenger",
        "108: rider",
        "109: assassin",
        "110: assassin",
        "111: caster",
        "112: assassin",
        "113: caster",
        "114: berserker",
        "115: rider",
        "116: berserker",
        "117: assassin",
        "118: rider",
        "119: lancer",
        "120: caster",
        "121: saber",
        "122: archer",
        "123: saber",
        "124: assassin",
        "125: archer",
        "126: saber",
        "127: caster",
        "128: lancer",
        "129: archer",
        "130: caster",
        "131: archer",
        "132: rider",
        "133: assassin",
        "134: lancer",
        "135: ruler",
        "136: caster",
        "137: archer",
        "138: saber",
        "139: assassin",
        "140: lancer",
        "141: lancer",
        "142: archer",
        "143: lancer",
        "144: rider",
        "145: caster",
        "146: lancer",
        "147: avenger",
        "148: lancer",
        "149: alterego",
        "150: caster",
        "151: alterego",
        "152: alterego",
        "153: saber",
        "154: assassin",
        "155: berserker",
        "156: archer",
        "157: archer",
        "158: avenger",
        "159: assassin",
        "160: saber",
        "161: berserker",
        "162: berserker",
        "163: alterego",
        "164: alterego",
        "165: saber",
        "166: moonCancer",
        "167: alterego",
        "168: alterego",
        "169: caster",
        "170: assassin",
        "171: berserker",
        "172: rider",
        "173: ruler",
        "174: berserker",
        "175: caster",
        "176: saber",
        "177: assassin",
        "178: berserker",
        "179: rider",
        "180: archer",
        "181: lancer",
        "182: rider",
        "183: lancer",
        "184: archer",
        "185: assassin",
        "186: lancer",
        "187: saber",
        "188: assassin",
        "189: assassin",
        "190: alterego",
        "191: alterego",
        "192: caster",
        "193: lancer",
        "194: caster",
        "195: foreigner",
        "196: lancer",
        "197: archer",
        "198: foreigner",
        "199: assassin",
        "200: archer",
        "201: caster",
        "202: berserker",
        "203: caster",
        "204: avenger",
        "205: rider",
        "206: rider",
        "207: archer",
        "208: caster",
        "209: alterego",
        "210: assassin",
        "211: rider",
        "212: archer",
        "213: saber",
        "214: lancer",
        "215: caster",
        "216: archer",
        "217: lancer",
        "218: assassin",
        "219: berserker",
        "220: moonCancer",
        "221: saber",
        "222: foreigner",
        "223: saber",
        "224: alterego",
        "225: caster",
        "226: berserker",
        "227: saber",
        "228: lancer",
        "229: ruler",
        "230: assassin",
        "231: rider",
        "232: lancer",
        "233: ruler",
        "234: saber",
        "235: assassin",
        "236: caster",
        "237: caster",
        "238: alterego",
        "239: assassin",
        "240: beast",
        "241: rider",
        "242: ruler",
        "243: assassin",
        "244: moonCancer",
        "245: saber",
        "246: archer",
        "247: berserker",
        "248: archer",
        "249: caster",
        "250: avenger",
        "251: berserker",
        "252: lancer",
        "253: rider",
        "254: saber",
        "255: archer",
        "256: lancer",
        "257: rider",
        "258: caster",
        "259: assassin",
        "260: berserker",
        "261: berserker",
        "262: archer",
        "263: rider",
        "264: saber",
        "265: ruler",
        "266: lancer",
        "267: assassin",
        "268: avenger",
        "269: archer",
        "270: saber",
        "271: archer",
        "272: archer",
        "273: rider",
        "274: rider",
        "275: foreigner",
        "276: archer",
        "277: rider",
        "278: saber",
        "279: lancer",
        "280: lancer"
    ]

    let costArray = [
        "1: 0",
        "2: 16",
        "3: 12",
        "4: 12",
        "5: 12",
        "6: 12",
        "7: 7",
        "8: 16",
        "9: 7",
        "10: 12",
        "11: 12",
        "12: 16",
        "13: 7",
        "14: 12",
        "15: 7",
        "16: 3",
        "17: 7",
        "18: 12",
        "19: 4",
        "20: 7",
        "21: 4",
        "22: 7",
        "23: 7",
        "24: 4",
        "25: 4",
        "26: 7",
        "27: 7",
        "28: 7",
        "29: 12",
        "30: 12",
        "31: 7",
        "32: 7",
        "33: 4",
        "34: 4",
        "35: 7",
        "36: 3",
        "37: 16",
        "38: 7",
        "39: 3",
        "40: 4",
        "41: 12",
        "42: 7",
        "43: 4",
        "44: 4",
        "45: 3",
        "46: 12",
        "47: 12",
        "48: 12",
        "49: 7",
        "50: 3",
        "51: 16",
        "52: 16",
        "53: 3",
        "54: 4",
        "55: 7",
        "56: 7",
        "57: 4",
        "58: 12",
        "59: 16",
        "60: 16",
        "61: 12",
        "62: 16",
        "63: 7",
        "64: 7",
        "65: 16",
        "66: 12",
        "67: 12",
        "68: 16",
        "69: 12",
        "70: 16",
        "71: 7",
        "72: 7",
        "73: 12",
        "74: 12",
        "75: 16",
        "76: 16",
        "77: 16",
        "78: 12",
        "79: 7",
        "80: 7",
        "81: 7",
        "82: 12",
        "83: 12",
        "84: 16",
        "85: 16",
        "86: 16",
        "87: 12",
        "88: 16",
        "89: 12",
        "90: 16",
        "91: 16",
        "92: 12",
        "93: 16",
        "94: 12",
        "95: 7",
        "96: 16",
        "97: 16",
        "98: 16",
        "99: 16",
        "100: 12",
        "101: 12",
        "102: 12",
        "103: 12",
        "104: 7",
        "105: 7",
        "106: 16",
        "107: 4",
        "108: 16",
        "109: 12",
        "110: 7",
        "111: 12",
        "112: 16",
        "113: 16",
        "114: 16",
        "115: 12",
        "116: 12",
        "117: 7",
        "118: 16",
        "119: 16",
        "120: 12",
        "121: 12",
        "122: 12",
        "123: 12",
        "124: 7",
        "125: 7",
        "126: 7",
        "127: 16",
        "128: 16",
        "129: 16",
        "130: 12",
        "131: 12",
        "132: 12",
        "133: 12",
        "134: 12",
        "135: 12",
        "136: 16",
        "137: 12",
        "138: 12",
        "139: 16",
        "140: 12",
        "141: 12",
        "142: 16",
        "143: 16",
        "144: 16",
        "145: 12",
        "146: 12",
        "147: 12",
        "148: 7",
        "149: 12",
        "150: 16",
        "151: 12",
        "152: 12",
        "153: 16",
        "154: 16",
        "155: 16",
        "156: 16",
        "157: 12",
        "158: 12",
        "159: 12",
        "160: 16",
        "161: 16",
        "162: 12",
        "163: 16",
        "164: 12",
        "165: 12",
        "166: 12",
        "167: 16",
        "168: 16",
        "169: 16",
        "170: 12",
        "171: 12",
        "172: 7",
        "173: 16",
        "174: 3",
        "175: 16",
        "176: 12",
        "177: 12",
        "178: 12",
        "179: 16",
        "180: 12",
        "181: 12",
        "182: 12",
        "183: 12",
        "184: 12",
        "185: 12",
        "186: 7",
        "187: 12",
        "188: 12",
        "189: 16",
        "190: 12",
        "191: 12",
        "192: 12",
        "193: 12",
        "194: 12",
        "195: 16",
        "196: 16",
        "197: 12",
        "198: 16",
        "199: 16",
        "200: 12",
        "201: 16",
        "202: 12",
        "203: 7",
        "204: 7",
        "205: 16",
        "206: 16",
        "207: 12",
        "208: 12",
        "209: 16",
        "210: 7",
        "211: 12",
        "212: 16",
        "213: 16",
        "214: 12",
        "215: 16",
        "216: 16",
        "217: 12",
        "218: 12",
        "219: 12",
        "220: 16",
        "221: 12",
        "222: 12",
        "223: 12",
        "224: 16",
        "225: 12",
        "226: 16",
        "227: 12",
        "228: 12",
        "229: 16",
        "230: 12",
        "231: 7",
        "232: 16",
        "233: 12",
        "234: 16",
        "235: 16",
        "236: 12",
        "237: 16",
        "238: 16",
        "239: 16",
        "240: 16",
        "241: 16",
        "242: 12",
        "243: 12",
        "244: 16",
        "245: 12",
        "246: 7",
        "247: 16",
        "248: 12",
        "249: 7",
        "250: 16",
        "251: 7",
        "252: 12",
        "253: 16",
        "254: 3",
        "255: 4",
        "256: 4",
        "257: 3",
        "258: 4",
        "259: 3",
        "260: 4",
        "261: 16",
        "262: 12",
        "263: 12",
        "264: 12",
        "265: 16",
        "266: 12",
        "267: 12",
        "268: 16",
        "269: 12",
        "270: 16",
        "271: 12",
        "272: 16",
        "273: 7",
        "274: 16",
        "275: 16",
        "276: 16",
        "277: 16",
        "278: 16",
        "279: 12",
        "280: 16"
    ]

    struct CompleteInfo: Codable {
        let id: String
        let servantClass: String
        let cost: String
        let name: String
        /// 性别
        let gender: String
        /// 身高
        let height: String
        /// 体重
        let weight: String
        /// 阵营
        let camp: String
        /// 地域
        let region: String
        /// 配卡
        let cards: [String]
        /// 出处
        let source: String
        /// 属性
        let attribute: String
        /// 特性
        let tokusei: [String]
        /// 昵称
        let nickNames: [String]
        /// 绘师
        let illustrator: String
        /// 配音
        let castVoice: String
        /// 入手方式
        let access: String
    }

    var i = 2
    while i <= 280 {
        if filterLists.contains(i) {
            i += 1
            continue
        }

        let basicInfo: BasicInfo = loadLocalFile("/fgo_resource/servant_basicInfo/servant-basicInfo-\(i).json")

        let a1 = classArray[i-1]
        let servantClass = a1.components(separatedBy: " ")[1]
        let cost = costArray[i-1].components(separatedBy: " ")[1]

        let complete = CompleteInfo(
            id: basicInfo.id,
            servantClass: servantClass,
            cost: cost,
            name: basicInfo.name,
            gender: basicInfo.gender,
            height: basicInfo.height,
            weight: basicInfo.weight,
            camp: basicInfo.camp,
            region: basicInfo.region,
            cards: basicInfo.cards,
            source: basicInfo.source,
            attribute: basicInfo.attribute,
            tokusei: basicInfo.tokusei,
            nickNames: basicInfo.nickNames,
            illustrator: basicInfo.illustrator,
            castVoice: basicInfo.castVoice,
            access: basicInfo.access)

        do {
            let fileURL = try FileManager.default
                .url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("servant-basicInfo-\(basicInfo.id).json")

            try JSONEncoder().encode(complete).write(to: fileURL)
        } catch {
            print(error)
        }

        i += 1
    }

}

//let vg = VGTimeCrawler()
//vg.crawlServantSkillMode()

func load<T: Decodable>(_ filename: String, withExtension extensionStr: String) -> T? {
    let data: Data

    do {
        let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("\(filename).\(extensionStr)")

        data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    catch {
        return nil
        //fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

var my_set: Set<String> = Set()

var i = 1

while i <= 283 {
    if let aaa: ServantSkillAndNoble = load("/fgo_resource/servant_skill/servant-skillAndPhantasm-No.\(i)", withExtension: "json") {
        for skill in aaa.skills {
            my_set.insert(skill.avatar)
        }

        for sss in aaa.updatedSkills {
            if let s = sss {
                my_set.insert(s.avatar)
            }
        }

        for cs in aaa.classSkills {
            my_set.insert(cs.avatar)
        }
    }

    i += 1
}



for ele in my_set {
    print(ele)
}
