//
//  Helper.swift
//  iPod Emulator 2
//
//  Created by Jide Opeola on 12/28/19.
//  Copyright © 2019 Greetings With Crypto. All rights reserved.
//

import Foundation

class Helper {
    
    class func contentsForFile(_ fileName: String) -> String {
        let filePath = Bundle.main.path(forResource: fileName, ofType: "txt");
        let URL = NSURL.fileURL(withPath: filePath!)
        do {
            let string = try String.init(contentsOf: URL)
            return string
        } catch  {
            print(error);
        }
        
        return ""
    }
}
