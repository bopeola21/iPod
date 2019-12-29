//
//  Playlist.swift
//  iPod Emulator 2
//
//  Created by Jide Opeola on 12/22/19.
//  Copyright © 2019 Greetings With Crypto. All rights reserved.
//

import Foundation

class Playlist {
    
    var name: String?
    var href: String?
    var id: String?
    
    init(_ dict: [String : Any]) {
        if let id = dict["id"] as? String {
            self.id = id
        }
        
        if let href = dict["href"] as? String {
            self.href = href
        }
        
        if let attributes = dict["attributes"] as? [String : Any],
            let name = attributes["name"] as? String {
            self.name = name
        }
    }
}
