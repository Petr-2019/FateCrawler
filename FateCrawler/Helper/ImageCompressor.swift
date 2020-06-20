//
//  ImageCompressor.swift
//  FateCrawler
//
//  Created by Peter-Guan on 2020/6/19.
//  Copyright © 2020 FoxHound-Peter-Guan. All rights reserved.
//

import Cocoa

class ImageCompressor {

    func resize(image: NSImage, w: Int, h: Int) -> NSImage {
        let destSize = NSMakeSize(CGFloat(w), CGFloat(h))
        let newImage = NSImage(size: destSize)
        newImage.lockFocus()
        image.draw(in: NSMakeRect(0, 0, destSize.width, destSize.height), from: NSMakeRect(0, 0, image.size.width, image.size.height), operation: NSCompositingOperation.sourceOver, fraction: CGFloat(1))
        newImage.unlockFocus()
        newImage.size = destSize

        return newImage
    }

    func write(id: String, cardId: String, image: NSImage) {
        do {
            let fileURL = try FileManager.default
                .url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("servant_\(id)_whole_status_\(cardId).jpeg")

            if let data = image.tiffRepresentation {
                try data.write(to: fileURL)
            }
            else {
                print("Image to data failed")
            }

        } catch {
            print(error)
        }
    }

}
