//
//  Networking.swift
//  ImagesFromFlickr
//
//  Created by Anita Agrawal on 07/08/18.
//  Copyright © 2018 Anita Agrawal. All rights reserved.
//

import Foundation
import UIKit

/**
 *This class takes care of server calls, getting photos for searched string.
 */

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
    class func makeHTTPRequest(url:String, apiMethod : HTTPMethod = .get, queryParameters:[String:Any], bodyParameters:[String:Any], successHandler:@escaping SuccessHandler, failureHandler:@escaping FailureHandler) -> URLSessionDataTask? {
        
        var path = "\(APIKeys.BaseURL)\(url)&api_key=\(APIKeys.ApiKey)&format=json&nojsoncallback=1&safe_search=1"
        
        queryParameters.forEach { (arg) in
            let (key, value) = arg
            path.append("&\(key)=\(value)")
        }
        
        guard let pathEncodedString = path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed), let pathURL = URL(string: pathEncodedString) else {
            return nil
        }
        //Enabling Network Activity indicator on Status bar
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let task = URLSession.shared.dataTask(with: pathURL) { (data, response, error) in
            //Disabling Network Activity indicator on Status bar, after getting response
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
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
        }
        return task
    }
}
