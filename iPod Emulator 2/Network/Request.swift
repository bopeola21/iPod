//
//  Request.swift
//  iPod Emulator 2
//
//  Created by Jide Opeola on 12/22/19.
//  Copyright © 2019 Greetings With Crypto. All rights reserved.
//

import Foundation

enum NetworkRequestError: Error, CustomStringConvertible {
  case invalidURL(String)
  
  var description: String {
    switch self {
    case .invalidURL(let url):
      return "The url '\(url)' was invalid"
    }
  }
}

struct Request {
    var urlString: String!
    var authHeader: String!
    var userTokenHeader: String!
    
    func buildURLRequest() -> URLRequest {
        let prefix = "https://api.music.apple.com/v1/"
        let newStr = prefix + urlString
        let url = URL(string: newStr)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("Bearer \(authHeader!)", forHTTPHeaderField: "Authorization")
        request.addValue(userTokenHeader, forHTTPHeaderField: "Music-User-Token")
        
        return request
    }
}
