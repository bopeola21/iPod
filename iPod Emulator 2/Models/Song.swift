//
//  Song.swift
//  iPod Emulator 2
//
//  Created by Jide Opeola on 12/22/19.
//  Copyright © 2019 Greetings With Crypto. All rights reserved.
//

import Foundation

class Song {
    
    var id: String?
    var href: String?
    var trackNumber: Int?
    var albumName: String?
    var artistName: String?
    var imageUrl: String?
    var name: String?
    var releaseDate: String?
    var duration: String?
    
    init(_ dict: [String : Any]) {
        if let id = dict["id"] as? String {
            self.id = id
        }
        
        if let href = dict["href"] as? String {
            self.href = href
        }
        
        if let attr = dict["attributes"] as? [String : Any] {
            if let trackNumber = attr["trackNumber"] as? Int {
                self.trackNumber = trackNumber
            }
            
            if let duration = attr["durationInMillis"] as? Int {
                let time = (Double(duration)/1000)/60
                self.duration = String(format: "%.2f", time)
            }
            
            if let albumName = attr["albumName"] as? String {
                self.albumName = albumName
            }
            
            if let artistName = attr["artistName"] as? String {
                self.artistName = artistName
            }
            
            if let artistName = attr["artistName"] as? String {
                self.artistName = artistName
            }
            
            if let releaseDate = attr["releaseDate"] as? String {
                self.releaseDate = releaseDate
            }
            
            if let playParams = attr["artwork"] as? [String : Any] {
                if let imageUrl = playParams["url"] as? String {
                    let strArr = imageUrl.components(separatedBy: "{w}x{h}")
                    let urlStr = (strArr.first ?? "") + "600x600bb.jpeg"
                    self.imageUrl = urlStr
                }
            }
            
            if let name = attr["name"] as? String {
                self.name = name
            }
        }
        

    }
}
