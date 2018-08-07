//
//  Networking.swift
//  ImagesFromFlickr
//
//  Created by Anita Agrawal on 07/08/18.
//  Copyright © 2018 Anita Agrawal. All rights reserved.
//

import Foundation

typealias SuccessHandler = (_ responseDict:[String: Any]) -> Void

typealias FailureHandler = (_ error:Error?) -> Void

enum HTTPMethod: String {
    case get = "get"
    case post = "post"
    case put = "put"
    case delete = "delete"
}

enum ErrorHandling: Error {
    case dataFoundNil
    case jsonSerializationFailed
}

class ConnectionManager {
    
    class func makeHTTPRequest(url:String, apiMethod : HTTPMethod = .get, queryParameters:[String], bodyParameters:[String:Any], successHandler:@escaping SuccessHandler, failureHandler:@escaping FailureHandler)->Void {
        let path = "\(APIKeys.BaseURL)\(url)&api_key=\(APIKeys.ApiKey)&page=\(queryParameters.first ?? "1")&per_page=20&format=json&nojsoncallback=1"
        guard let pathEncodedString = path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed), let pathURL = URL(string: pathEncodedString) else {
            return
        }
        URLSession.shared.dataTask(with: pathURL) { (data, response, error) in
            
            if let error = error {
                failureHandler(error)
            }
            guard let data = data else {
                failureHandler(ErrorHandling.dataFoundNil)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                guard let jsonResponse = json else {
                    failureHandler(ErrorHandling.jsonSerializationFailed)
                    return
                }
                successHandler(jsonResponse)
            } catch {
                print("didnt work")
                failureHandler(ErrorHandling.jsonSerializationFailed)
            }
        }.resume()
        
    }
}
