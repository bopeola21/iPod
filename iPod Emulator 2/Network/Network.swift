//
//  Network.swift
//  GreetingsWithCrypto
//
//  Created by Jide Opeola on 8/23/18.
//  Copyright © 2018 Bevi Mobile. All rights reserved.
//

import Foundation

enum NetworkError: Error {
  case unknown
  case invalidResponse
  case moreInformationNeeded
  
  var description: String {
    switch self {
    case .unknown: return "An unknown error occurred"
    case .invalidResponse: return "Received an invalid response"
    case .moreInformationNeeded: return "Please check repected information requirements"
    }
  }
}

class Network {
  let session: URLSession
  
  init() {
    session = URLSession.shared
  }
  
  func request(request: Request, completion: @escaping ([String : Any]?, Error?) -> Void) {
        do {
            let request = request.buildURLRequest()
            let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                guard error == nil,
                  let data = data else {
                    completion(nil, error ?? NetworkError.unknown)
                    return
                }

                print("POST request response from server: ")
                print(response as Any)

                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 { // check for http errors
                  print("Error status code \(httpStatus.statusCode)")
                  print("response = \(String(describing: response))")
                  completion(nil, NetworkError.unknown)
                }

                do {
                  if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: AnyObject] {
                    print("Data serialized JSON from server: ")
                    print(json)
                    completion(json, nil)
                  }
                } catch let error {
                  print("Error serializing JSON with error: \(error.localizedDescription)")
                  completion(nil, error)
                }
            }
            task.resume()
        } catch let error {
            print("Error retrieving contents of URL with error: \(error.localizedDescription)")
            completion(nil, error)
        }
  }
}

